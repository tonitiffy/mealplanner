/*Procedure for planning meals*/


/*Procedure for generating supermarket list*/
/*Tables needed: mealplan, dailymeal, meal, recipe, */
DELIMITER $$
CREATE PROCEDURE createUser(
    IN mealPlanID int
)
BEGIN
    
    
    
END$$
DELIMITER ;

select *, * from test1, test2 and test1.mp_id = test2.mp_id;
select breakfast, lunch, dinner, snack1, snack2, snack3 from mealplan where mealplan_id = mealPlanID
select monday, tuesday, wednesday, thursday, friday, saturday, sunday from dailymeal where dailymeal_id = dailyMealID

/*Procedure for the creation of meals based on specified calorie count */


/*Procedure for creating an account */
DELIMITER $$
CREATE PROCEDURE createUser(
    IN p_email            VARCHAR(64),
    IN p_username         VARCHAR(20),
    IN p_password_hash    VARCHAR(64),
    IN p_fname            VARCHAR(30),
    IN p_lname            VARCHAR(30),
    IN p_gender           VARCHAR(6),
    IN p_dob              DATE,
)
BEGIN
    IF ( select exists (select 1 from user where email = p_email) or select exists (select 1 from user where username = p_username)) THEN
     
        select 'Username and/or email already exist.';
     
    ELSE
     
        insert into user
        (
            email,
            username,
            password_hash,
            fname,
            lname,
            gender,
            dob
        )
        values
        (
            p_email,
            p_username,
            p_password_hash,
            p_fname,
            p_lname,
            p_gender,
            p_dob
        );
     
    END IF;
END$$
DELIMITER ;


/*Procedure for signing in*/
DELIMITER $$
CREATE PROCEDURE validateLogin(
    IN p_username VARCHAR(20)
    )
BEGIN
    select * from user where username = p_username;
END$$
DELIMITER ;