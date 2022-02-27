CREATE TABLE test (
	user_name varchar(100) -- default collation
);

insert into test values ('João'), ('JOÃO'), ('JOão'), ('Joao'), ('joao')

select * from test where test.user_name = 'joao' -- only 1
select * from test where test.user_name like '%joao%' -- only 1 record
select * from test where test.user_name ilike '%joao%' -- 2 records, whitout accent
select * from test where test.user_name like '%joao%' -- only 1 record
select * from test where lower(test.user_name) = 'joao' -- 2 records, whitout accent
select * from test where lower(test.user_name) like '%joao%' -- 2 records, whitout accent

select * from pg_collation

-- 
CREATE TABLE test2 (
	user_name varchar(100) collate "pt-BR-x-icu"
);

insert into test2 values ('João'), ('JOÃO'), ('JOão'), ('Joao'), ('joao')

select * from test2 where user_name = 'joao' -- only 1
select * from test2 where user_name like '%joao%' -- only 1 record
select * from test2 where user_name ilike '%joao%' -- 2 records, whitout accent
select * from test2 where lower(user_name) = 'joao' -- 2 records, whitout accent
select * from test2 where lower(user_name) like '%joao%' -- 2 records, whitout accent

--
-- REF: https://newbedev.com/how-to-make-my-postgresql-database-use-a-case-insensitive-collation
CREATE COLLATION case_insensitive (
  provider = icu,
  locale = 'und-u-ks-level2',
  deterministic = false
);

CREATE TABLE test3 (
	user_name varchar(100) collate case_insensitive
);

insert into test3 values ('João'), ('JOÃO'), ('JOão'), ('Joao'), ('joao')

select * from test3 where user_name = 'joao' -- only 1
select * from test3 where user_name like '%joao%' -- ERROR:  nondeterministic collations are not supported for LIKE - SQL state: 0A000
select * from test3 where user_name ilike '%joao%' -- ERROR:  nondeterministic collations are not supported for LIKE - SQL state: 0A000
select * from test3 where lower(user_name) = 'joao' -- 2 records, whitout accent
select * from test3 where lower(user_name) like '%joao%' -- ERROR:  nondeterministic collations are not supported for LIKE - SQL state: 0A000

--
-- REF https://blackdeerdev.com/case-insensitive-columns-postgres/

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;

CREATE TABLE test4 (
	user_name citext -- New datatype, without size !!!!
);

insert into test4 values ('João'), ('JOÃO'), ('JOão'), ('Joao'), ('joao')

select * from test4 where user_name = 'joao' -- 2 records, whitout accent
select * from test4 where user_name like '%joao%' -- 2 records, whitout accent
select * from test4 where user_name ilike '%joao%' -- 2 records, whitout accent
select * from test4 where lower(user_name) = 'joao' -- 2 records, whitout accent
select * from test4 where lower(user_name) like '%joao%' -- 2 records, whitout accent

-- 
-- REF https://rotadev.com/does-postgresql-support-accent-insensitive-collations-dev/

CREATE EXTENSION unaccent;

CREATE TABLE test5 (
	user_name varchar(100) -- default collation
);

insert into test5 values ('João'), ('JOÃO'), ('JOão'), ('Joao'), ('joao')

select * from test5 where user_name = 'joao' -- 1 record
select * from test5 where user_name like '%joao%' -- 1 record
select * from test5 where user_name ilike '%joao%' -- 2 records, whitout accent
select * from test5 where lower(user_name) = 'joao' -- 2 records, whitout accent
select * from test5 where lower(user_name) like '%joao%' -- 2 records, whitout accent
select * from test5 where unaccent(user_name) like '%joao%' -- 1 record
select * from test5 where unaccent(lower(user_name)) like '%joao%' -- 5 records !!! 



