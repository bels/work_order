package WorkOrder::Controller::Representative;
use Mojo::Base 'Mojolicious::Controller';

sub add_form{
	my $self = shift;
	
	my $sites = $self->pg->db->query('select name,id from sites where active = true order by name asc')->arrays->to_array;
	warn $self->dumper($sites);
	$self->stash(
		sites => $sites
	);
}

sub add{
	my $self = shift;
	
	$self->rep->add($self->req->params->to_hash);
	$self->redirect_to($self->url_for('add_representative_form'));
}

sub list_all{
	my $self = shift;
	#we will check if this is an ajax request.  if it is, we will just return data, if not we will render a page
}

sub edit{
	my $self = shift;
}

sub get_rep{
	my $self = shift;
	
}
1;