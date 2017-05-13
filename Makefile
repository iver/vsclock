PG_HOST ?= 127.0.0.1
PG_PORT ?= 5432
PG_USER ?= meetup_user
PG_PASS ?= pass
PG_DATABASE ?= meetup

shell:
	@PGPASSWORD=$(PG_PASS) psql -U$(PG_USER) -h$(PG_HOST) -p$(PG_PORT) $(PG_DATABASE)

reset:
	@PGPASSWORD=$(PG_PASS) psql -U$(PG_USER) -h$(PG_HOST) -p$(PG_PORT) postgres -c "DROP DATABASE IF EXISTS $(PG_DATABASE)";
	@PGPASSWORD=$(PG_PASS) psql -U$(PG_USER) -h$(PG_HOST) -p$(PG_PORT) postgres -c "CREATE DATABASE $(PG_DATABASE) OWNER $(PG_USER)";
	@cat *.sql | PGPASSWORD=$(PG_PASS) psql -U$(PG_USER) -h$(PG_HOST) -p$(PG_PORT) $(PG_DATABASE);

init:
	@sudo -u postgres psql --command "CREATE USER $(PG_USER) WITH PASSWORD '$(PG_PASS)';";
	@sudo -u postgres psql --command "CREATE DATABASE $(PG_DATABASE) OWNER $(PG_USER);";
	@sudo -u postgres psql --command "ALTER USER $(PG_USER) CREATEDB;";
	@sudo -u postgres psql --command "GRANT ALL PRIVILEGES ON DATABASE $(PG_DATABASE) TO $(PG_USER);";

drop:
	@sudo -u postgres psql --command "DROP DATABASE IF EXISTS $(PG_DATABASE);";
	@sudo -u postgres psql --command "REASSIGN OWNED BY $(PG_USER) TO postgres;";
	@sudo -u postgres psql --command "DROP ROLE IF EXISTS $(PG_USER);";

