package WorkOrder::Controller::Representative;
use Mojo::Base 'Mojolicious::Controller';

sub add_form{
	my $self = shift;
	
	my $sites = $self->pg->db->query('select name,id from sites where active = true order by name asc')->arrays->to_array;
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
	
	$self->stash(
		reps => $self->rep->list_all
	);
}

sub edit{
	my $self = shift;
}

sub get_rep{
	my $self = shift;

warn $self->dumper($self->param('id'));
	my $rep = $self->rep->get($self->param('id'));
	warn $self->dumper($rep);
	$self->stash(
		template => 'representative/get_rep',
		first_name => $rep->{'first_name'},
		surname => $rep->{'surname'},
		email => $rep->{'email'},
		site => $rep->{'site'},
		phone => $rep->{'phone'}
	);
}
1;