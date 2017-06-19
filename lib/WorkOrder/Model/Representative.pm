package WorkOrder::Model::Representative;
use Mojo::Base -base;

has 'pg';
has 'debug';

sub add{
	my ($self,$params) = @_;

	$self->pg->db->query('insert into representative(first_name,surname,email,phone,site) values(?,?,?,?,?)',
		$params->{'first_name'},$params->{'surname'},$params->{'email'},$params->{'phone_number'},$params->{'site'});
}
1;