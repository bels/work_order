package WorkOrder::Model::WorkOrder;
use Mojo::Base -base;

has 'pg';
has 'debug';

sub add{
	my ($self,$params) = @_;
	
	my $id = $self->pg->db->query('insert into work_order(customer,representative,problem_description,labor_rate,wo_state) values(?,?,?,?,?) returning id',
		$params->{'customer'},$params->{'representative'},$params->{'problem'},$params->{'labor_rate'},$params->{'wo_state'})->hash;
		
	return $id->{'id'};
}

sub list_all{
	my $self = shift;
	
my $sql =<<SQL;
select
	wo.id,
	wo.genesis,
	wo.work_order_number,
	c.first_name || ' ' || c.surname as customer_name
from
	work_order wo
join
	customer c
on
	wo.customer = c.id
order
	by wo.genesis desc
SQL
	return $self->pg->db->query($sql)->hashes->to_array;
}

sub edit{
	
}

sub approve{
	
}

sub get{
	my ($self,$id) = @_;
my $sql =<<SQL;
select
	wo.id,
	wo.genesis,
	wo.representative,
	r.first_name || ' ' || r.surname as representative_name,
	wo.customer,
	c.first_name || ' ' || c.surname as customer_name,
	wo.labor_rate,
	lr.rate as labor_rate_value,
	wo.wo_state,
	ws.name as wo_state_name,
	wo.problem_description
from
	work_order wo
join
	representative r
on
	wo.representative = r.id
join
	customer c
on
	wo.customer = c.id
join
	labor_rate lr
on
	wo.labor_rate = lr.id
join
	wo_state ws
on
	wo.wo_state = ws.id
where
	wo.id = ?
SQL
	return $self->pg->db->query($sql,$id)->hash;
}

1;