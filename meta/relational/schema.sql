drop table if exists change_events;
drop type if exists change_types;
drop table if exists kingdom_ranks;
drop table if exists external_identifiers;
drop table if exists external_identifier_authorities;
drop table if exists authority_owners;
drop table if exists house_seat_incumbencies;
drop table if exists peerage_holdings;
drop table if exists house_seats;
drop table if exists law_lord_incumbencies;
drop table if exists peerages;
drop table if exists jurisdictions;
drop table if exists peerage_types;
drop table if exists special_remainder_types;
drop table if exists letters_patents;
drop table if exists people_parliamentary_blocs;
drop table if exists house_seat_end_reasons;
drop table if exists house_seat_incumbency_end_reasons;
drop table if exists houses;
drop table if exists rank_labels;
drop table if exists bishopric_incumbencies;
drop table if exists bishopric_parliamentary_seniority_incumbencies;
drop table if exists people;
drop table if exists peerage_ranks;
drop table if exists parliamentary_bloc_affiliation_types;
drop table if exists parliamentary_blocs;
drop table if exists political_parties;
drop table if exists kingdoms;
drop table if exists genders;
drop table if exists letters_patent_times;
drop table if exists constituency_groups;
drop table if exists bishopric_parliamentary_seniorities;
drop table if exists winning_candidates;
drop table if exists bishoprics;
drop table if exists counties;
drop table if exists regions;

create type change_types as enum ('insert', 'update', 'delete');
create table change_events (
	id serial,
	table_name varchar(255) not null,
	row_id int not null,
	change_type change_types not null,
	change_at timestamp not null,
	primary key (id)
);
create table regions (
	id serial,
	name varchar(255) not null,
	primary key (id)
);
create table counties (
	id serial,
	name varchar(255) not null,
	is_palatine boolean default false,
	region_id int not null,
	constraint fk_region foreign key (region_id) references regions(id),
	primary key (id)
);
create table bishoprics (
	id serial,
	title varchar(255) not null,
	diocese varchar(255) not null,
	primary key (id)
);
create table letters_patent_times (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table genders (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table kingdoms (
	id serial,
	name varchar(50) not null,
	start_on date,
	end_on date,
	primary key (id)
);
create table houses (
	id serial,
	name varchar(50) not null,
	primary key (id)
);
create table people (
	id serial,
	year_of_birth smallint null,
	month_of_birth smallint null,
	day_of_birth smallint null,
	year_of_death smallint null,
	month_of_death smallint null,
	day_of_death smallint null,
	gender_id int,
	constraint fk_gender foreign key (gender_id) references genders(id),
	primary key (id)
);
create table letters_patents (
	id serial,
	patent_on date not null,
	ordinality_on_date int not null,
	previous_rank varchar(255),
	previous_of_title boolean default false,
	previous_title varchar(255),
	person_id int not null,
	kingdom_id int not null,
	previous_kingdom_id int,
	letters_patent_time_id int,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	constraint fk_previous_kingdom foreign key (previous_kingdom_id) references kingdoms(id),
	constraint fk_letters_patent_time_id foreign key (letters_patent_time_id) references letters_patent_times(id),
	primary key (id)
);
create table special_remainder_types (
	id serial,
	description varchar(1000) not null,
	primary key (id)
);
create table peerage_ranks (
	id serial,
	label varchar(255),
	degree smallint not null,
	primary key (id)
);
create table peerage_types (
	id serial,
	label varchar(255),
	primary key (id)
);
create table peerages (
	id serial,
	of_title boolean default false,
	title varchar(255) not null,
	territorial_designation varchar(255) not null,
	extinct_on date default null,
	last_number int default null,
	peerage_rank_id int not null,
	special_remainder_type_id int not null,
	letters_patent_id int not null,
	peerage_type_id int not null,
	kingdom_id int not null,
	constraint fk_peerage_rank foreign key (peerage_rank_id) references peerage_ranks(id),
	constraint fk_special_remainder_type foreign key (special_remainder_type_id) references special_remainder_types(id),
	constraint fk_letters_patent foreign key (letters_patent_id) references letters_patents(id),
	constraint fk_peerage_type foreign key (peerage_type_id) references peerage_types(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	primary key (id)
);
create table jurisdictions (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table law_lord_incumbencies (
	id serial,
	appointed_on date not null,
	end_on date not null,
	peerage_id int not null,
	jurisdiction_id int not null,
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	constraint fk_jurisdiction foreign key (jurisdiction_id) references jurisdictions(id),
	primary key (id)
);
create table peerage_holdings (
	id serial,
	start_on date not null,
	end_on date not null,
	ordinal_number int not null,
	person_id int not null,
	peerage_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	primary key (id)
);
create table parliamentary_bloc_affiliation_types (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table political_parties (
	id serial,
	name varchar(255) not null,
	abbreviation varchar(10) not null,
	primary key (id)
);
create table parliamentary_blocs (
	id serial,
	name varchar(255) not null,
	abbreviation varchar(10) not null,
	background_colour char(6) null,
	text_colour char(6) null,
	low_res_logo bytea null,
	low_res_logo_mime_type varchar(20) null,
	high_res_logo bytea null,
	high_res_logo_mime_type varchar(20) null,
	political_party_id int null,
	constraint fk_political_party foreign key (political_party_id) references political_parties(id),
	primary key (id)
);
create table people_parliamentary_blocs (
	id serial,
	start_on date null,
	end_on date null,
	person_id int not null,
	whip_withdrawn boolean default false,
	resigned_whip boolean default false,
	notes varchar(255) null,
	parliamentary_bloc_id int not null,
	parliamentary_bloc_affiliation_type_id int not null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_parliamentary_bloc foreign key (parliamentary_bloc_id) references parliamentary_blocs(id),
	constraint fk_parliamentary_bloc_affiliation_type foreign key (parliamentary_bloc_affiliation_type_id) references parliamentary_bloc_affiliation_types(id),
	primary key (id)
);
create table rank_labels (
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
create table constituency_groups (
	id serial,
	primary key (id)
);
create table bishopric_parliamentary_seniorities (
	id serial,
	rank int not null,
	primary key (id)
);
create table house_seats (
	id serial,
	start_on date not null,
	end_on date not null,
	house_seat_end_reason_id int null,
	house_id int not null,
	constituency_group_id int,
	bishopric_id int,
	bishopric_parliamentary_seniority_id int,
	peerage_id int null,
	constraint fk_house foreign key (house_id) references houses(id),
	constraint fk_house_seat_end_reason foreign key (house_seat_end_reason_id) references house_seat_end_reasons(id),
	constraint fk_contituency_group foreign key (constituency_group_id) references constituency_groups(id),
	constraint fk_bishopric foreign key (bishopric_id) references bishoprics(id),
	constraint fk_bishopric_parliamentary_seniority foreign key (bishopric_parliamentary_seniority_id) references bishopric_parliamentary_seniorities(id),
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	primary key (id)
);
create table house_seat_incumbency_end_reasons (
	id serial,
	label varchar(255) not null,
	primary key (id)
);
create table winning_candidates (
	id serial,
	primary key (id)
);
create table bishopric_incumbencies (
	id serial,
	start_on date not null,
	end_on date,
	bishopric_id int not null,
	person_id int not null,
	constraint fk_bishopric foreign key (bishopric_id) references bishoprics(id),
	constraint fk_person foreign key (person_id) references people(id),
	primary key (id)
);
create table bishopric_parliamentary_seniority_incumbencies (
	id serial,
	start_on date not null,
	end_on date,
	bishopric_parliamentary_seniority_id int not null,
	person_id int not null,
	constraint fk_bishopric_parliamentary_seniority foreign key (bishopric_parliamentary_seniority_id) references bishopric_parliamentary_seniorities(id),
	constraint fk_person foreign key (person_id) references people(id),
	primary key (id)
);
create table house_seat_incumbencies (
	id serial,
	start_on date not null,
	end_on date,
	house_seat_incumbency_end_reason_id int null,
	person_id int not null,
	house_seat_id int not null,
	winning_candidate_id int,
	bishopric_incumbency_id int,
	bishopric_parliamentary_seniority_incumbency_id int,
	peerage_holding_id int,
	constraint fk_house_seat_incumbency_end_reason foreign key (house_seat_incumbency_end_reason_id) references house_seat_incumbency_end_reasons(id),
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_house_seat foreign key (house_seat_id) references house_seats(id),
	constraint fk_winning_candidate foreign key (winning_candidate_id) references winning_candidates(id),
	constraint fk_bishopric_incumbency foreign key (bishopric_incumbency_id) references bishopric_incumbencies(id),
	constraint fk_bishopric_parliamentary_seniority_incumbency foreign key (bishopric_parliamentary_seniority_incumbency_id) references bishopric_parliamentary_seniority_incumbencies(id),
	constraint fk_peerage_holding foreign key (peerage_holding_id) references peerage_holdings(id),
	primary key (id)
);
create table authority_owners (
	id serial,
	name varchar(255) not null,
	primary key (id)
);
create table external_identifier_authorities (
	id serial,
	name varchar(255) not null,
	authority_owner_id int not null,
	constraint fk_authority_owner foreign key (authority_owner_id) references authority_owners(id),
	primary key (id)
);
create table external_identifiers (
	id serial,
	value varchar(255) not null,
	uri varchar(255) null,
	external_identifier_authority_id int not null,
	political_party_id int null,
	parliamentary_bloc_id int null,
	person_id int null,
	peerage_id int null,
	house_id int null,
	letters_patent_id int null,
	special_remainder_type_id int null,
	jurisdiction_id int null,
	law_lord_incumbency_id int null,
	peerage_type_id int null,
	peerage_rank_id int null,
	peerage_holding_id int null,
	constraint fk_external_identifier_authority foreign key (external_identifier_authority_id) references external_identifier_authorities(id),
	constraint fk_political_party foreign key (political_party_id) references political_parties(id),
	constraint fk_parliamentary_bloc foreign key (parliamentary_bloc_id) references parliamentary_blocs(id),
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	constraint fk_house foreign key (house_id) references houses(id),
	constraint fk_letters_patent foreign key (letters_patent_id) references letters_patents(id),
	constraint fk_special_remainder_type foreign key (special_remainder_type_id) references special_remainder_types(id),
	constraint fk_jurisdiction foreign key (jurisdiction_id) references jurisdictions(id),
	constraint fk_law_lord_incumbency foreign key (law_lord_incumbency_id) references law_lord_incumbencies(id),
	constraint fk_peerage_type foreign key (peerage_type_id) references peerage_types(id),
	constraint fk_peerage_rank foreign key (peerage_rank_id) references peerage_ranks(id),
	constraint fk_peerage_holding foreign key (peerage_holding_id) references peerage_holdings(id),
	primary key (id)
);
create table kingdom_ranks (
	id serial,
	peerage_rank_id int not null,
	kingdom_id int not null,
	constraint fk_peerage_rank foreign key (peerage_rank_id) references peerage_ranks(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	primary key (id)
);