/*Create Database*/
CREATE DATABASE mealplanner;
USE mealplanner;

/*Create Tables*/
CREATE TABLE user(
	user_id			int auto_increment not null unique,
	email			varchar(64),
	username		varchar(20),
	password_hash	varchar(100),
	fname			varchar(30),
	lname			varchar(30),
	gender			varchar(6),
	dob				date,
	primary key(user_id) 
);

CREATE TABLE ingredient(
	ingredient_id	int auto_increment not null unique,
	ingredient_name	varchar(20),
	primary key(ingredient_id)
);

CREATE TABLE measurement(
	measurement_id		int auto_increment not null unique,
	measurement_name	varchar(20),
	primary key(measurement_id)
);

CREATE TABLE meal(
	meal_id			int auto_increment not null unique,
	meal_calories	int,
	meal_servings	int,
	image			varchar(200),
	primary key(meal_id)
);

CREATE TABLE meal_course(
	meal_id			int,
	course			varchar(20),
	primary key(meal_id),
	foreign key(meal_id) references meal(meal_id) on delete cascade on update cascade
);
create table test1(dm_id int not null, cat varchar(15), m_id int, mp_id int, primary key(dm_id, cat));
create table test2(mp_id int not null, day int, primary key(mp_id, day));

insert into test1 (dm_id, cat, m_id, mp_id) values(1,'breakfast', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(1,'lunch', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(1,'dinner', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(2,'breakfast', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(2,'lunch', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(2,'dinner', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(3,'breakfast', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(3,'lunch', 1, 1);
insert into test1 (dm_id, cat, m_id, mp_id) values(3,'dinner', 1, 1);
insert into test2 (mp_id, day) values(1,1);
insert into test2 (mp_id, day) values(1,2);
insert into test2 (mp_id, day) values(1,3);




CREATE TABLE dailymeal(
	dailymeal_id	int auto_increment not null unique,
	breakfast		int,
	lunch			int,
	dinner			int,
	snack1			int,
	snack2			int,
	snakc3			int,
	primary key(dailymeal_id),
	foreign key(breakfast) references meal(meal_id) on delete cascade on update cascade,
	foreign key(lunch) references meal(meal_id) on delete cascade on update cascade,
	foreign key(dinner) references meal(meal_id) on delete cascade on update cascade,
	foreign key(snack1) references meal(meal_id) on delete cascade on update cascade,
	foreign key(snack2) references meal(meal_id) on delete cascade on update cascade,
	foreign key(snack3) references meal(meal_id) on delete cascade on update cascade,
);

CREATE TABLE mealplan(
	mealplan_id		int auto_increment not null unique,
	user_id			int,
	start_date		date,
	monday			int,
	tuesday			int,
	wednesday		int,
	thursday		int,
	friday			int,
	saturday		int,
	sunday			int,
	primary key(mealplan_id),
	foreign key(user_id) references user(user) on delete cascade on update cascade,
	foreign key(monday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(tuesday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(wednesday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(thursday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(friday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(saturday) references dailymeal(dailymeal_id) on delete cascade on update cascade,
	foreign key(sunday) references dailymeal(dailymeal_id) on delete cascade on update cascade
);

CREATE TABLE recipe(
	recipe_id		int auto_increment not null unique,
	user_id			int,
	created			date,
	recipe_name		varchar(200),
	description		varchar(1000),
	recipe_calories	int,
	recipe_servings	int,
	primary key(recipe_id),
	foreign key(user_id) references user(user) on delete cascade on update cascade
);

CREATE TABLE recipe_type(
	recipe_id			int,
	recipe_type			varchar(20),
	primary key(meal_id)
);

CREATE TABLE kitchen(
	kitchen_id		int auto_increment not null unique,
	user_id			int,
	ingredient		int,
	quantity		int,
	status			varchar(20),
	primary key(kitchen_id),
	foreign key(user_id) references user(user) on delete cascade on update cascade
);

CREATE TABLE recipeIngredient(
	recipe_id			int,
	recipe_ingredient	int,
	recipe_measurement	int,
	quantity			int,
	primary key(recipe_id)
	foreign key(recipe_id) references recipe(recipe_id) on delete cascade on update cascade,
	foreign key(recipe_ingredient) references ingredient(ingredient_id) on delete cascade on update cascade,
	foreign key(recipe_measurement) references measurement(measurement_id) on delete cascade on update cascade
);

CREATE TABLE recipeInstruction(
	recipe_id		int,
	instruction_num	int,
	instruction_des	varchar(500),
	primary key(recipe_id),
	foreign key(recipe_id) references recipe(recipe_id) on delete cascade on update cascade
);

CREATE TABLE recipe_meal(
	recipe_id		int,
	meal_id			int,
	primary key(recipe_id, meal_id)
	foreign key(recipe_id) references recipe(recipe_id) on delete cascade on update cascade,
	foreign key(meal_id) references meal(meal_id) on delete cascade on update cascade
);