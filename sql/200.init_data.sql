insert into work_order.phone_types(type) values('Home');
insert into work_order.phone_types(type) values('Mobile');
insert into work_order.phone_types(type) values('Work');

insert into work_order.sites(name) values ('Waldorf');
insert into work_order.sites(name) values ('KC');

insert into work_order.wo_state(name) values ('New');
insert into work_order.wo_state(name) values ('In Progress');
insert into work_order.wo_state(name) values ('Waiting');
insert into work_order.wo_state(name) values ('Completed');
insert into work_order.wo_state(name) values ('Closed');
insert into work_order.wo_state(name) values ('Approved');
insert into work_order.wo_state(name) values ('Not Approved');

insert into work_order.labor_rate(rate,code,description) values(75.00,'Home Repair','Standard labor rate for home repair');