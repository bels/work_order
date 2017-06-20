package WorkOrder::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

sub index{
	my $self = shift;
}

sub new_workorder_form{
	my $self = shift;
	
	my $customers = $self->customer->list_all;
	my $phone_types = $self->pg->db->query('select type,id from phone_types where active = true order by type asc')->arrays->to_array;
	my $states = $self->pg->db->query('select name,id from wo_state where active = true')->arrays->to_array;
	my $representatives = $self->rep->list_all;
	my $labor_rates = $self->pg->db->query("select rate::TEXT || ' - ' || code,id from labor_rate where active = true order by rate asc")->arrays->to_array;
	$self->stash(
		customers => $customers,
		phone_types => $phone_types,
		wo_states => $states,
		representatives => $representatives,
		labor_rates => $labor_rates,
		js => ['/js/private/new_wo.js']
	);
}

sub new_workorder{
	my $self = shift;
	
	my $id = $self->work_order->add($self->req->params->to_hash);
	$self->session(wo_id => $id);
	$self->redirect_to($self->url_for('approve_workorder_form'));
}

sub list_workorders{
	my $self = shift;
	
	my $work_orders = $self->work_order->list_all;
	warn $self->dumper($work_orders);
	$self->stash(
		wos => $work_orders
	);
}

sub get_workorder{
	my $self = shift;
	
}

sub edit_workorder{
	my $self = shift;
	
}

sub approve_workorder_form{
	my $self = shift;
	
	my $wo = $self->work_order->get($self->session('wo_id'));
	
	warn $self->dumper($wo);
	
	$self->stash(
		wo => $wo
	);
}

sub approve_workorder{
	my $self = shift;
	
	if($self->param('approval')){
		$self->pg->db->query("update work_order set customer_accepted = true,wo_state = (select id from wo_state where name = 'Approved') where id = ?", $self->param('wo_id'));
	} else {
		$self->pg->db->query("update work_order set wo_state = (select id from wo_state where name = 'Not Approved') where id = ?", $self->param('wo_id'));
	}
	$self->session(wo_id => undef); #clearing this out
	$self->redirect_to($self->url_for('index'));
}
1;