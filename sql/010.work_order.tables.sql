set search_path to work_order,public;
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

CREATE TABLE sites(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	name TEXT NOT NULL,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON sites TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON sites
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE representative(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	first_name TEXT NOT NULL,
	surname TEXT,
	email TEXT,
	phone TEXT,
	site UUID REFERENCES sites(id) ON DELETE SET NULL
);

GRANT SELECT, INSERT, UPDATE, DELETE ON representative TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON representative
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE labor_rate(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	rate NUMERIC,
	code TEXT,
	description TEXT,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON labor_rate TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON labor_rate
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE wo_state(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	name TEXT NOT NULL,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON wo_state TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON wo_state
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE work_order(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	work_order_number BIGSERIAL,
	representative UUID REFERENCES representative(id) ON DELETE SET NULL,
	customer UUID REFERENCES customer(id) ON DELETE CASCADE,
	problem_description TEXT,
	work_performed TEXT,
	hours NUMERIC,
	labor_rate UUID REFERENCES labor_rate(id) ON DELETE SET NULL,
	parts_cost NUMERIC,
	customer_accepted BOOLEAN DEFAULT false,
	wo_state UUID REFERENCES wo_state(id) ON DELETE SET NULL,
	site UUID REFERENCES sites(id) ON DELETE SET NULL
);

GRANT USAGE, SELECT ON SEQUENCE work_order_work_order_number_seq TO wo_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON work_order TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON work_order
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE phone_types(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	type TEXT NOT NULL,
	active BOOLEAN DEFAULT true
);

GRANT SELECT, INSERT, UPDATE, DELETE ON phone_types TO wo_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON phone_types
	FOR EACH ROW EXECUTE PROCEDURE integrity_enforcement();

CREATE TABLE phone_number(
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT current_timestamp,
	modified TIMESTAMPTZ DEFAULT current_timestamp,
	customer UUID NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
	phone_number TEXT,
	type UUID REFERENCES phone_types(id) ON DELETE SET NULL
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