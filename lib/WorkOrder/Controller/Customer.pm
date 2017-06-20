package WorkOrder::Controller::Customer;
use Mojo::Base 'Mojolicious::Controller';

sub add_form{
	my $self = shift;
}

sub add{
	my $self = shift;
	
	$self->customer->add($self->req->params->to_hash);
	$self->render(json => {success => Mojo::JSON->true}, status => 200);
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
}

1;