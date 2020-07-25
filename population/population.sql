use my_schema;
select * from population;
select * from zipcodes;

alter table population change `Total Population` `total_population` varchar(20);
alter table population change `Percent Males` `percent_males` varchar(20);
alter table zipcodes change `ZIP code` `zip_code` varchar(10);

# Check null values
select * from population 
where zip is null or total_population is null or percent_males is null;

select * from zipcodes
where zip_code is null or State is null;

# Change format of dummy values
select * from population
where zip like '%[0-9]-[0-9]%';

select case when locate('%', percent_males) > 0 then 1 else 0
end as dummy
from population;

update population
set percent_males = case when length(percent_males) = 3 then left(percent_males, 2)
else percent_males
end;

update population
set percent_males = percent_males/100;

set sql_safe_updates = 0;

update population
set zip = case when locate('-', zip) > 0 then substring(zip,1, locate('-', zip)-1)
else zip
end;

select case when locate(',', state) > 0 then 1 else 0
end as dummy
from zipcodes;

update zipcodes
set state = case when locate(',', state) > 0 then substring(state, 1, locate(',', state) - 1) 
else state
end;

set sql_safe_updates = 1;

# Join tables
select zip, total_population, percent_males, zipcodes.state
from population join zipcodes 
on population.zip = zipcodes.zip_code;