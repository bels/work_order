package WorkOrder;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;
use WorkOrder::Model::Representative;
use WorkOrder::Model::Customer;
use WorkOrder::Model::WorkOrder;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');
  $self->helper(pg => sub { state $pg = Mojo::Pg->new( shift->config('pg'))});
  $self->helper(rep => sub { 
	my $app = shift;
	state $rep = WorkOrder::Model::Representative->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 :  0) ;
  });
  
  $self->helper(customer => sub { 
	my $app = shift;
	state $core = WorkOrder::Model::Customer->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 :  0) ;
  });
  
  $self->helper(work_order => sub { 
	my $app = shift;
	state $core = WorkOrder::Model::WorkOrder->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 :  0) ;
  });
  
  $self->helper(set_selected => sub{
  	#must pass in an array ref containing a hashref in each element
  	my ($app,$list,$index_to_match,$selected) = @_;

  	for my $i (0 .. scalar @{$list} - 1){
  		if($list->[$i][$index_to_match] eq $selected){
  			push(@{$list->[$i]},selected => 'selected');
  		}
  	}
  	
  	return $list;
  });
  $self->pg->search_path(['work_order','public']);
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('core#index')->name('index');
  $r->get('/representative/add')->to('representative#add_form')->name('add_representative_form');
  $r->post('/representative/add')->to('representative#add')->name('add_representative');
  $r->get('/representative/list')->to('representative#list_all')->name('list_representatives');
  $r->post('/representative/edit')->to('representative#edit')->name('edit_representative');
  $r->get('/representative/:id')->to('representative#get_rep')->name('get_representative');
  $r->get('/work_order/new')->to('core#new_workorder_form')->name('new_workorder_form');
  $r->post('/work_order/new')->to('core#new_workorder')->name('new_workorder');
  $r->get('/work_order/approve')->to('core#approve_workorder_form')->name('approve_workorder_form');
  $r->post('/work_order/approve')->to('core#approve_workorder')->name('approve_workorder');
  $r->get('/work_order/list')->to('core#list_workorders')->name('list_workorders');
  $r->post('/work_order/edit/:id')->to('core#edit_workorder')->name('edit_workorder');
  $r->get('/work_order/:id')->to('core#get_workorder')->name('get_workorder');
  $r->post('/customer/add')->to('customer#add')->name('add_customer');
  $r->get('/customer/list')->to('customer#list_all')->name('list_customers');
  $r->post('/customer/edit')->to('customer#edit')->name('edit_customer');
  $r->get('/customer/:id')->to('customer#get_customer')->name('get_customer');
}

1;
