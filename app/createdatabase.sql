/*Create Database*/
CREATE DATABASE mealplanner;
USE mealplanner;

/*Create Tables*/
CREATE TABLE user(
	user_id			int auto_increment not null unique,
	email			varchar(),
	username		varchar(),
	password_hash	varchar(),
	fname			varchar(),
	lname			varchar(),
	gender			varchar(),
	dob				date,
	primary key(user_id) 
);

CREATE TABLE mealplan(
	mealplan_id		,
	user_id			,
	start_date		,
	monday			,
	tuesday			,
	wednesday		,
	thursday		,
	friday			,
	primary key(mealplan_id)
);

CREATE TABLE dailymeal(
	dailymeal_id	,
	breakfast		,
	lunch			,
	dinner			,
	snack1			,
	snack2			,
	snakc3			,
	primary key(dailymeal_id)
);

CREATE TABLE meal(
	meal_id			,
	meal_calories	,
	meal_servings	,
	image			,
	primary key(meal_id)
);

CREATE TABLE meal_course(
	meal_id			,
	course			,
	primary key(meal_id)
);

CREATE TABLE recipe(
	recipe_id		,
	user_id			,
	created			,
	recipe_name		,
	description		,
	recipe_calories	,
	recipe_servings	,
	primary key(recipe_id)
);

CREATE TABLE recipe_type(
	recipe_id			,
	recipe_type			,
	primary key(meal_id)
);

CREATE TABLE kitchen(
	kitchen_id		,
	user_id			,
	ingredient		,
	quantity		,
	status			,
	primary key(kitchen_id)
);

CREATE TABLE ingredient(
	ingredient_id	,
	ingredient_name	,
	primary key(ingredient_id)
);

CREATE TABLE measurement(
	measurement_id		,
	measurement_name	,
	primary key(measurement_id)
);

CREATE TABLE recipeIngredient(
	recipe_id			,
	recipe_ingredient	,
	recipe_measurement	,
	quantity			,
	primary key(recipe_id)
);

CREATE TABLE recipeInstruction(
	recipe_id		,
	instruction_num	,
	instruction_des	,
	
	primary key(recipe_id)
);

CREATE TABLE recipe_meal(
	recipe_id		,
	meal_id			,
	primary key(recipe_id, meal_id)
);