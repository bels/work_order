package WorkOrder::Controller::Customer;
use Mojo::Base 'Mojolicious::Controller';

sub add_form{
	my $self = shift;
}

sub add{
	my $self = shift;

	my $id = $self->customer->add($self->req->params->to_hash);
	my $name = $self->param('first_name') . ' ' . $self->param('surname');
	$self->render(json => {success => Mojo::JSON->true, id => $id, name => $name}, status => 200);
}

sub list_all{
	my $self = shift;
	
	my $customers = $self->customer->list_all;

	$self->stash(
		customers => $customers
	);
}

sub edit{
	my $self = shift;
}

sub get_customer{
	my $self = shift;
	
	my $customer = $self->customer->get_customer($self->param('id'));
	$self->stash(
		first_name => $customer->{'first_name'},
		surname => $customer->{'surname'},
		phone_number => $customer->{'phone_number'},
		email => $customer->{'email'}
	);
}

1;