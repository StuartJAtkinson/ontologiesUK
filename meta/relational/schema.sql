drop table if exists people_parliamentary_blocs;
drop table if exists house_seat_incumbencies;
drop table if exists house_seats;
drop table if exists house_seat_end_reasons;
drop table if exists houses;
drop table if exists gendered_rank_labels;
drop table if exists gender_identities;
drop table if exists people;
drop table if exists genders;
drop table if exists peerages;
drop table if exists peerage_ranks;
drop table if exists parliamentary_bloc_affiliations;
drop table if exists parliamentary_blocs;
drop table if exists political_parties;



create table houses (
	id serial,
	name varchar(50) not null,
	primary key (id)
);
create table people (
	id serial,
	date_of_birth date null,
	date_of_birth_exact boolean not null,
	year_of_birth smallint null,
	date_of_death date null,
	date_of_death_exact boolean not null,
	year_of_death smallint null,
	primary key (id)
);
create table parliamentary_bloc_affiliations (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table political_parties (
	id serial,
	name varchar(255) not null,
	electoral_commission_id varchar(255) not null,
	primary key (id)
);
create table parliamentary_blocs (
	id serial,
	name varchar(255) not null,
	political_party_id int null,
	constraint fk_political_party foreign key (political_party_id) references political_parties(id),
	primary key (id)
);
create table people_parliamentary_blocs (
	id serial,
	start_date date null,
	end_date date null,
	person_id int not null,
	parliamentary_bloc_id int not null,
	parliamentary_bloc_affiliation_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_parliamentary_bloc foreign key (parliamentary_bloc_id) references parliamentary_blocs(id),
	constraint fk_parliamentary_bloc_affiliation foreign key (parliamentary_bloc_affiliation_id) references parliamentary_bloc_affiliations(id),
	primary key (id)
);
create table genders (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table gender_identities (
	id serial,
	start_date date null,
	end_date date null,
	person_id int not null,
	gender_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_gender foreign key (gender_id) references genders(id),
	primary key (id)
);
create table peerage_ranks (
	id serial,
	degree smallint not null,
	primary key (id)
);
create table peerages (
	id serial,
	peerage_rank_id int not null,
	constraint fk_peerage_rank foreign key (peerage_rank_id) references peerage_ranks(id),
	primary key (id)
);
create table gendered_rank_labels (
	id serial,
	label varchar(255) not null,
	gender_id int not null,
	peerage_rank_id int not null,
	constraint fk_gender foreign key (gender_id) references genders(id),
	constraint fk_peerage_rank foreign key (peerage_rank_id) references peerage_ranks(id),
	primary key (id)
);
create table house_seat_end_reasons (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table house_seats (
	id serial,
	start_date date not null,
	end_date date not null,
	peerage_id int null,
	house_id int not null,
	house_seat_end_reason_id int null,
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	constraint fk_house foreign key (house_id) references houses(id),
	constraint fk_house_seat_end_reason foreign key (house_seat_end_reason_id) references house_seat_end_reasons(id),
	primary key (id)
);
create table house_seat_incumbencies (
	id serial,
	start_date date not null,
	end_date date not null,
	person_id int not null,
	house_seat_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_house_seat foreign key (house_seat_id) references house_seats(id),
	primary key (id)
);