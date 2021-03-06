package WorkOrder::Model::Customer;
use Mojo::Base -base;

has 'pg';
has 'debug';

sub add{
	my ($self,$params) = @_;

	my $result = $self->pg->db->query('insert into customer(first_name,middle_name,surname,street,city,state,zip) values(?,?,?,?,?,?,?) returning id',
		$params->{'first_name'},$params->{'middle_name'},$params->{'surname'},$params->{'street'},$params->{'city'},$params->{'state'},$params->{'zip'})->hash;
	if(defined($result->{'id'})){
		#later loop and accept multiple
		if(ref($params->{'phone_number'}) eq 'ARRAY'){
			my $index = 0;
			foreach my $phone_number (@{$params->{'phone_number'}}){
				$self->pg->db->query('insert into phone_number(customer,phone_number,type) values(?,?,?)',$result->{'id'},$phone_number,$params->{'phone_type'}->[$index]);
				$index++;
			}
		} else {
			$self->pg->db->query('insert into phone_number(customer,phone_number,type) values(?,?,?)',$result->{'id'},$params->{'phone_number'},$params->{'phone_type'});
		}
		$self->pg->db->query('insert into email(customer,email) values(?,?)',$result->{'id'},$params->{'email'});
	}
	return $result->{'id'};
}

sub list_all{
	my $self = shift;
	
	return $self->pg->db->query("select first_name || ' ' || surname, id from customer order by surname asc")->arrays->to_array;
}

sub get_customer{
	my ($self,$id) = @_;

my $sql =<<SQL;
select
	first_name,
	surname,
	phone_number,
	email
from
	customer
join
	phone_number
on
	phone_number.customer = customer.id
join
	email
on
	email.customer = customer.id
where
	customer.id = ?
SQL
	return $self->pg->db->query($sql,$id)->hash;
}
1;