package WorkOrder::Model::Representative;
use Mojo::Base -base;

has 'pg';
has 'debug';

sub add{
	my ($self,$params) = @_;

	$self->pg->db->query('insert into representative(first_name,surname,email,phone,site) values(?,?,?,?,?)',
		$params->{'first_name'},$params->{'surname'},$params->{'email'},$params->{'phone_number'},$params->{'site'});
}

sub list_all{
	my $self = shift;
	
	return $self->pg->db->query("select first_name || ' ' || surname, id from representative order by surname asc")->arrays->to_array;
}
1;