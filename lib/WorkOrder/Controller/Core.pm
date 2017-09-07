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
	my $sites = $self->pg->db->query('select name,id from sites where active = true order by name asc')->arrays->to_array;
	my $labor_rates = $self->pg->db->query("select rate::TEXT || ' - ' || code,id from labor_rate where active = true order by rate asc")->arrays->to_array;
	$self->stash(
		customers => $customers,
		phone_types => $phone_types,
		wo_states => $states,
		representatives => $representatives,
		labor_rates => $labor_rates,
		sites => $sites,
		js => ['/js/private/new_wo.js','/js/private/customer.js'],
		styles => ['/css/private/customer.css']
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

	$self->stash(
		js => ['https://cdn.datatables.net/v/bs/jqc-1.12.4/dt-1.10.15/cr-1.3.3/datatables.min.js','/js/private/work_order.js'],
		styles => ['https://cdn.datatables.net/v/bs/jqc-1.12.4/dt-1.10.15/cr-1.3.3/datatables.min.css'],
		wos => $work_orders
	);
}

sub get_workorder{
	my $self = shift;

	my $states = $self->pg->db->query('select name,id from wo_state where active = true')->arrays->to_array;
	my $wo = $self->work_order->get($self->param('id'));

	$self->stash(
		wo => $wo,
		wo_states => $self->set_selected($states,1,$wo->{'wo_state'}),
		id => $self->param('id')
	);
}

sub edit_workorder{
	my $self = shift;
	
	$self->work_order->edit($self->req->params->to_hash);
	
	$self->redirect_to($self->url_for('get_workorder'));
}

sub approve_workorder_form{
	my $self = shift;

	$self->stash(
		wo => $self->work_order->get($self->session('wo_id'))
	);
}

sub approve_workorder{
	my $self = shift;
	
	$self->work_order->approve($self->req->params->to_hash);
	$self->session(wo_id => undef); #clearing this out
	$self->redirect_to($self->url_for('index'));
}
1;