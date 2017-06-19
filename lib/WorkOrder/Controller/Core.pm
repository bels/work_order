package WorkOrder::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

sub index{
	my $self = shift;
}

sub new_workorder_form{
	my $self = shift;
	
	my $customers = $self->customer->list;
	my $phone_types = $self->pg->db->query('select type,id from phone_types where active = true order by type asc')->arrays->to_array;
	warn $self->dumper($customers);
	$self->stash(
		customers => $customers,
		phone_types => $phone_types,
		js => ['/js/private/new_wo.js']
	);
}

sub new_workorder{
	my $self = shift;
	
}

sub list_workorders{
	my $self = shift;
	
}

sub get_workorder{
	my $self = shift;
	
}

sub edit_workorder{
	my $self = shift;
	
}

1;