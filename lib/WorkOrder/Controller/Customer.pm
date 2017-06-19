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
	#we will check if this is an ajax request.  if it is, we will just return data, if not we will render a page
}

sub edit{
	my $self = shift;
}

sub get_customer{
	my $self = shift;
}

1;