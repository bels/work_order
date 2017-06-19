set search path to work_order,public;
CREATE TABLE customer(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	first_name TEXT NOT NULL,
	middle_name TEXT,
	surname TEXT NOT NULL,
	street TEXT,
	city TEXT,
	state TEXT,
	zip TEXT
);

GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON customer
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE work_order(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	work_order_number BIGSERIAL,
	
);

GRANT SELECT, INSERT, UPDATE, DELETE ON work_order TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON work_order
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();
	
CREATE TABLE phone_number(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	customer UUID NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
	phone_number TEXT
);

GRANT SELECT, INSERT, UPDATE, DELETE ON phone_number TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON phone_number
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();
	
CREATE TABLE email(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	customer UUID NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
	email TEXT
);

GRANT SELECT, INSERT, UPDATE, DELETE ON email TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON email
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();