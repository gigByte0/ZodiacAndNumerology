SET GLOBAL log_bin_trust_function_creators = 1;
USE ZodiacAndNumerology;
SELECT * FROM ZodiacAndNumerology.NumberofMonth;
SELECT * FROM ZodiacAndNumerology.VenusSigns;
SELECT * FROM ZodiacAndNumerology.SunSigns;
SELECT * FROM ZodiacAndNumerology.Users;
SELECT * FROM ZodiacAndNumerology.Friends;
SELECT * FROM ZodiacAndNumerology.SunSignCompatibility;
SELECT * FROM ZodiacAndNumerology.VedicSunSigns;
SELECT * FROM ZodiacAndNumerology.LifePathNumbers;
SELECT * FROM ZodiacAndNumerology.KuaNumbers;
SELECT * FROM ZodiacAndNumerology.CurrentYearHoroscope;

-- FUNCTION TO GET MONTH NUM FROM MONTH STRING
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getMonthNum;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getMonthNum(mob VARCHAR(30)) 
RETURNS INT(2)
BEGIN 
DECLARE monthNum INT(2);
SELECT NumberOfMonth.numOfMonth INTO monthNum FROM NumberOfMonth WHERE (mob = nameOfMonth);
RETURN monthNum;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getMonthNum("October");
SELECT getMonthNum("March");

-- FUNCTION TO GET USER PASSWORD
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getUserPass;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getUserPass(userN VARCHAR(30)) 
RETURNS VARCHAR(30)
BEGIN 
DECLARE pass VARCHAR(30);
SELECT Users.userPassword INTO pass FROM Users WHERE (Users.userName = userN);
RETURN pass;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getUserPass("gimatt");


-- FUNCTION TO GET USER MOB 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getUserMOB;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getUserMOB(userN VARCHAR(30)) 
RETURNS INT
BEGIN 
DECLARE mob INT(2);
SELECT Users.monthOfBirth INTO mob FROM Users WHERE (Users.userName = userN);
RETURN mob;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getUserMOB("greg");

-- FUNCTION TO GET USER DOB 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getUserDOB;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getUserDOB(userN VARCHAR(30)) 
RETURNS INT
BEGIN 
DECLARE dob INT(2);
SELECT Users.dayOfBirth INTO dob FROM Users WHERE (Users.userName = userN);
RETURN dob;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getUserDOB("greg");

-- FUNCTION TO GET USER YOB 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getUserYOB;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getUserYOB(userN VARCHAR(30)) 
RETURNS INT
BEGIN 
DECLARE yob INT;
SELECT Users.yearOfBirth INTO yob FROM Users WHERE (Users.userName = userN);
RETURN yob;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getUserYOB("greg");

-- FUNCTION TO GET USER SAB 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getUserSAB;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getUserSAB(userN VARCHAR(30)) 
RETURNS VARCHAR(10)
BEGIN 
DECLARE sab VARCHAR(10);
SELECT Users.sexAtBirth INTO sab FROM Users WHERE (Users.userName = userN);
RETURN sab;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getUserSAB("greg");

-- PROCEDURE TO GET LIST OF USER FRIENDS 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.getFriends;
DELIMITER //
CREATE PROCEDURE ZodiacAndNumerology.getFriends(userN VARCHAR(30)) 
BEGIN 
(SELECT Friends.user1Name AS friends FROM ZodiacAndNumerology.Friends WHERE (userN = Friends.user2Name))
UNION 
(SELECT Friends.user2Name FROM ZodiacAndNumerology.Friends WHERE (userN = Friends.user1Name));
END //
DELIMITER ;
-- FUNCTION TEST 
CALL ZodiacAndNumerology.getFriends("gimatt");
-- CALL ZodiacAndNumerology.addUser("john", "109", 03, 10, 1966, "male");
-- CALL ZodiacAndNumerology.addFriend("john", "gimatt");
-- CALL ZodiacAndNumerology.addFriend("greg", "jo");
CALL ZodiacAndNumerology.getFriends("greg");

-- PROCEDURE TO GET LIST OF USER FRIENDS 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getNumFriends;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getNumFriends(userN VARCHAR(30)) 
RETURNS INT
BEGIN
DECLARE numFriends INT; 
SELECT COUNT(a.friends) INTO numFriends FROM
((SELECT Friends.user1Name AS friends FROM ZodiacAndNumerology.Friends WHERE (userN = Friends.user2Name))
UNION 
(SELECT Friends.user2Name FROM ZodiacAndNumerology.Friends WHERE (userN = Friends.user1Name))) as a;
RETURN numFriends;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT ZodiacAndNumerology.getNumFriends("gimatt");


-- FUNCTION TO GET SUN SIGN FROM DATE
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getSunSign;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getSunSign(mob INT, dob INT) 
RETURNS VARCHAR(30)
BEGIN 
DECLARE zodiac_sign VARCHAR(30);
SELECT SunSigns.sunSignName INTO zodiac_sign FROM SunSigns WHERE 
(((SunSigns.monthBegin = mob) AND ((dob >= SunSigns.dayOfMonthBegin) AND (dob <= 31))) OR 
((SunSigns.monthEnd = mob) AND (dob <= SunSigns.dayOfMonthEnd)));
RETURN zodiac_sign;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getSunSign(10, 8);
SELECT getSunSign(12, 24);
SELECT getSunSign(2, 29);

-- FUNCTION TO GET SUN SIGN DESCRIPTION  USER MOB AND DOB
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getSunSignDescription;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getSunSignDescription(mob INT, dob INT) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE sign_decription VARCHAR(100);
SELECT CONCAT(SunSigns.descriptionWord1, ", ", SunSigns.descriptionWord2, ", ", SunSigns.descriptionWord3) 
INTO sign_decription FROM SunSigns WHERE (SunSigns.sunSignName = ZodiacAndNumerology.getSunSign(mob, dob));
RETURN sign_decription;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getSunSignDescription(10, 8);
SELECT getSunSignDescription(12, 24);

-- FUNCTION TO GET SUN SIGN DESCRIPTION FROM USER MOB AND DOB
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getSunSignType;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getSunSignType(mob INT, dob INT) 
RETURNS VARCHAR(60)
BEGIN 
DECLARE sign_type VARCHAR(60);
SELECT CONCAT(SunSigns.elementQuality, " ", SunSigns.element) INTO sign_type FROM SunSigns 
WHERE (SunSigns.sunSignName = ZodiacAndNumerology.getSunSign(mob, dob));
RETURN sign_type;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getSunSignType(10, 28);
SELECT getSunSignType(12, 24);

-- FUNCTION TO GET VENUS SIGN FROM DATE
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getVenusSign;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getVenusSign(mob INT, dob INT, yob INT) 
RETURNS VARCHAR(30)
BEGIN 
DECLARE venus_sign VARCHAR(30);
SELECT d.venusSignName INTO venus_sign FROM 
(SELECT DATEDIFF(CONCAT(yob, "-", mob, "-", dob), CONCAT(c.yearOfVenus, "-", c.numOfMonth, "-", c.dayOfVenus))
AS closestVenus, c.venusSignName FROM (SELECT b.yearOfVenus, a.numOfMonth, b.dayOfVenus, b.venusSignName 
FROM ((SELECT * FROM NumberOfMonth) as a JOIN 
(SELECT VenusSigns.dayOfVenus, VenusSigns.monthOfVenus, VenusSigns.yearOfVenus,
VenusSigns.venusSignName FROM VenusSigns) AS b ON (a.nameOfMonth = b.monthOfVenus))) AS c) AS d 
WHERE (d.closestVenus >= 0) GROUP BY d.closestVenus, d.venusSignName ORDER BY d.closestVenus ASC LIMIT 1;
RETURN venus_sign;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getVenusSign(03, 10, 1966);
SELECT getVenusSign(10, 08, 2002);
SELECT getVenusSign(03, 21, 1970);

-- FUNCTION TO GET FRIEND COMPATIBILITY OUT OF 10
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getFriendCompatibility;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getFriendCompatibility(user1Name VARCHAR(30), user2Name VARCHAR(30)) 
RETURNS INT 
BEGIN 
DECLARE compatibility INT;
DECLARE dob1 INT;
DECLARE dob2 INT;
DECLARE mob1 INT;
DECLARE mob2 INT;
DECLARE yob1 INT;
DECLARE yob2 INT;
DECLARE friend1SunSign VARCHAR(30);
DECLARE friend1VenusSign VARCHAR(30);
DECLARE friend2SunSign VARCHAR(30);
DECLARE friend2VenusSign VARCHAR(30);
SELECT Users.dayOfBirth INTO dob1 FROM Users WHERE (user1Name = Users.userName);
SELECT Users.dayOfBirth INTO dob2 FROM Users WHERE (user2Name = Users.userName);
SELECT Users.monthOfBirth INTO mob1 FROM Users WHERE (user1Name = Users.userName);
SELECT Users.monthOfBirth INTO mob2 FROM Users WHERE (user2Name = Users.userName);
SELECT Users.yearOfBirth INTO yob1 FROM Users WHERE (user1Name = Users.userName);
SELECT Users.yearOfBirth INTO yob2 FROM Users WHERE (user2Name = Users.userName);
SET friend1SunSign = ZodiacAndNumerology.getSunSign(mob1, dob1);
SET friend1VenusSign = ZodiacAndNumerology.getVenusSign(mob1, dob1, yob1);
SET friend2SunSign = ZodiacAndNumerology.getSunSign(mob2, dob2);
SET friend2VenusSign = ZodiacAndNumerology.getVenusSign(mob2, dob2, yob2);
SELECT SUM(a.rating) INTO compatibility FROM
(SELECT SunSignCompatibility.rate AS rating FROM SunSignCompatibility WHERE 
(((friend1VenusSign = SunSignCompatibility.sunSignOne) AND (friend2VenusSign = SunSignCompatibility.sunSignTwo)) OR 
((friend1VenusSign = SunSignCompatibility.sunSignTwo) AND (friend2VenusSign = SunSignCompatibility.sunSignOne)))
UNION ALL
SELECT SunSignCompatibility.rate AS sunSignRating FROM SunSignCompatibility WHERE 
(((friend1SunSign = SunSignCompatibility.sunSignOne) AND (friend2SunSign = SunSignCompatibility.sunSignTwo)) OR 
((friend1SunSign = SunSignCompatibility.sunSignTwo) AND (friend2SunSign = SunSignCompatibility.sunSignOne)))) AS a;
RETURN compatibility;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getFriendCompatibility("gimatt", "greg");
SELECT getFriendCompatibility("greg", "gimatt");
CALL addUser("jo", "1234", 03, 21, 1970, "female");
CALL addFriend("jo", "greg");
CALL addBestFriend("jo", "greg");
-- SELECT getFriendCompatibility("Libra", "Scorpio", "Libra", "Scorpio");
-- SELECT getFriendCompatibility("Gemini", "Sagittarius", "Capricorn", "Pisces");

-- FUNCTION TO GET SUN SIGN FROM DATE
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getVedicSunSign;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getVedicSunSign(mob INT, dob INT) 
RETURNS VARCHAR(30)
BEGIN 
DECLARE vedic_sign VARCHAR(30);
SELECT CONCAT(VedicSunSigns.sunSignName, " (", VedicSunSigns.vedicSignName, ")") INTO vedic_sign FROM VedicSunSigns 
WHERE (((VedicSunSigns.monthBegin = mob) AND ((dob >= VedicSunSigns.dayOfMonthBegin) AND (dob <= 31))) OR 
((VedicSunSigns.monthEnd = mob) AND (dob <= VedicSunSigns.dayOfMonthEnd)));
RETURN vedic_sign;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getVedicSunSign(10, 8);
SELECT getVedicSunSign(12, 24);
SELECT getVedicSunSign(2, 29);
SELECT getVedicSunSign(3, 21);

-- FUNCTION TO GET DESCRIPTION OF LIFE PATH NUMBER
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getLifePathDescription;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getLifePathDescription(lpn INT) 
RETURNS VARCHAR(200)
BEGIN 
DECLARE des VARCHAR(200);
SELECT GROUP_CONCAT(LifePathNumbers.descriptionWord1, ", ", LifePathNumbers.descriptionWord2, ", ",
LifePathNumbers.descriptionWord3,", ", LifePathNumbers.descriptionWord4, ", ", LifePathNumbers.descriptionWord5) 
INTO des FROM ZodiacAndNumerology.LifePathNumbers 
WHERE (lpn = LifePathNumbers.lifePathNumber);
RETURN des;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getLifePathDescription(8);
SELECT getLifePathDescription(4);

-- FUNCTION TO GET TYPE OF LIFE PATH NUMBER
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getLifePathType;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getLifePathType(lpn INT) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE typ VARCHAR(100);
SELECT LifePathNumbers.lifePathType INTO typ FROM ZodiacAndNumerology.LifePathNumbers WHERE 
(LifePathNumbers.lifePathNumber = lpn);
RETURN typ;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getLifePathType(8);
SELECT getLifePathType(4);

-- FUNCTION TO GET LIFE PATH NUMBER FROM dob 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getLifePathNumber;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getLifePathNumber(mob INT, dob INT, yob INT) 
RETURNS INT 
BEGIN
DECLARE lifePath_num INT;
DECLARE yearLP INT;
DECLARE monthLP INT;
DECLARE dayLP INT;
DECLARE LPNum INT;
SET yearLP = (SUBSTRING(yob, 1, 1) + SUBSTRING(yob, 2, 1) + SUBSTRING(yob, 3, 1) + SUBSTRING(yob, 4, 1));
IF (mob < 10) THEN SET monthLP = (SUBSTRING(mob, 1, 0) + RIGHT(mob, 1));
ELSE SET monthLP = (LEFT(mob, 1) + RIGHT(mob, 1));
END IF;
IF (dob < 10) THEN SET dayLP = (SUBSTRING(dob, 1, 0) + RIGHT(dob, 1));
ELSE SET dayLP = (LEFT(dob, 1) + RIGHT(dob, 1));
END IF;
IF (yearLP >= 10) THEN SET yearLP = (LEFT(yearLP, 1) + RIGHT(yearLP, 1));
END IF;
SET LPNum = yearLP + monthLP + dayLP;
IF ((LPNum >= 10) AND (NOT ((LPNum = 11) OR (LPNum = 22)))) THEN SET LPNum = (LEFT(LPNUm, 1) + RIGHT(LPNum, 1));
END IF;
SELECT LifePathNumbers.lifePathNumber INTO lifePath_num FROM LifePathNumbers WHERE
 (LPNum = LifePathNumbers.lifePathNumber);
RETURN lifePath_num;
END //
DELIMITER ;
-- TEST FUNCTION
SELECT getLifePathNumber(03, 21, 1970);
SELECT getLifePathNumber(10, 08, 2002);
SELECT getLifePathNumber(03, 10, 1966);

-- FUNCTION TO GET Kua Lucky Colors 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getKuaColors;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getKuaColors(kn int) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE col VARCHAR(100);
SELECT GROUP_CONCAT(KuaNumbers.kuaLuckyColor1, ", ", KuaNumbers.kuaLuckyColor2) INTO col 
FROM ZodiacAndNumerology.KuaNumbers WHERE (KuaNumbers.kuaNumber = kn);
RETURN col;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getKuaColors(8);
SELECT getKuaColors(4);

-- FUNCTION TO GET Kua Lucky Season 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getKuaLuckySeason;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getKuaLuckySeason(kn INT) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE typ VARCHAR(100);
SELECT KuaNumbers.kuaLuckySeason INTO typ FROM KuaNumbers WHERE (KuaNumbers.kuaNumber = kn);
RETURN typ;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getKuaLuckySeason(8);
SELECT getKuaLuckySeason(4);


-- FUNCTION TO GET Kua direction group, Lucky and unlucky directions
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getKuaDirections;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getKuaDirections(kn INT) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE typ VARCHAR(100);
SELECT GROUP_CONCAT(KuaNumbers.kuaDirectionGroup, ", ", KuaNumbers.kuaLuckyDirection, ", ", 
KuaNumbers.kuaUnluckyDirection) INTO typ FROM KuaNumbers WHERE (KuaNumbers.kuaNumber = kn);
RETURN typ;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getKuaDirections(8);
SELECT getKuaDirections(4);

-- FUNCTION TO GET Kua luck 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getKuaLuck;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getKuaLuck(kn INT) 
RETURNS VARCHAR(100)
BEGIN 
DECLARE typ VARCHAR(100);
SELECT KuaNumbers.kuaLuck INTO typ FROM KuaNumbers WHERE (KuaNumbers.kuaNumber = kn);
RETURN typ;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getKuaLuck(8);
SELECT getKuaLuck(4);


-- FUNCTION TO GET KUA NUMBER 
DROP FUNCTION IF EXISTS ZodiacAndNumerology.getKuaNumber;
DELIMITER //
CREATE FUNCTION ZodiacAndNumerology.getKuaNumber(mob INT, dob INT, yob INT, sexAtBirth VARCHAR(10)) 
RETURNS INT
BEGIN 
DECLARE kuaNum INT;
DECLARE kua_num INT;
-- CONSIDER CHINESE CALANDER (Considers new year starts feb. 4)
IF ((mob = 1) OR ((mob = 2) AND (dob < 4))) THEN SET yob = yob - 1;
END IF;
-- ADD YEAR OF BIRTH DIGITS
SET kuaNum = (SUBSTRING(yob, 1, 1) + SUBSTRING(yob, 2, 1) + SUBSTRING(yob, 3, 1) + SUBSTRING(yob, 4, 1));
-- REDUCE IF 2 DIGIT RESULT
IF (kuaNum >= 10) THEN SET kuaNum = (LEFT(kuaNum, 1) + RIGHT(kuaNum, 1));
END IF;
-- ADD 4 FOR FEMALE
-- SUBTRACT FROM 11 FOR MALE 
IF (sexAtBirth = "female") THEN SET kuaNum = kuaNum + 4;
ELSE IF (sexAtBirth = "male") THEN SET kuaNum = 11 - kuaNum;
END IF;
END IF;
-- REDUCE RESULT 
IF ((kuaNum >= 10) AND (sexAtBirth =  "female")) THEN SET kuaNum = (LEFT(kuaNum, 1) + RIGHT(kuaNum, 1));
END IF;
-- FOR FEMALE 
IF ((sexAtBirth = "female") AND (kuaNum = 5)) THEN SET kuaNum = 8;
ELSE IF ((sexAtBirth = "male") AND (kuaNum = 5)) THEN SET kuaNum = 2;
END IF;
END IF;
SELECT KuaNumbers.kuaNumber INTO kua_num FROM KuaNumbers WHERE (KuaNumbers.kuaNumber = kuaNum);
RETURN kua_num;
END //
DELIMITER ;
-- FUNCTION TEST 
SELECT getKuaNumber(10, 8, 2002, "female");
SELECT getKuaNumber(3, 10, 1966, "male");
SELECT getKuaNumber(2, 29, 1996, "male");
SELECT getKuaNumber(3, 21, 1970, "female");

-- PROCEDURE TO ADD USERS 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.addUser;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.addUser(userName VARCHAR(50), userPassword VARCHAR(30), monthOfBirth INT,
dayOfBirth INT, yearOfBirth INT, sexAtBirth ENUM("male", "female")) 
BEGIN 
INSERT INTO ZodiacAndNumerology.Users VALUE
(userName, userPassword, monthOfBirth, dayOfBirth, yearOfBirth, sexAtBirth); 
END //
DELIMITER ;
-- CALL ZodiacAndNumerology.addUser("jo", "hello1234", 03, 10, 1970, "female");

-- PROCEDURE TO DELETE USER ACCOUNT -> THIS WILL TAKE USER BACK TO LOGIN 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.removeUser;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.removeUser(userName VARCHAR(50)) 
BEGIN 
DELETE FROM ZodiacAndNumerology.Users WHERE (Users.userName = userName);
END //
DELIMITER ;
-- CALL ZodiacAndNumerology.removeUser("jo");

-- PROCEDURE TO ADD FRIENDS 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.addFriend;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.addFriend(user1Name VARCHAR(30), user2Name VARCHAR(30)) 
BEGIN 
INSERT INTO ZodiacAndNumerology.Friends VALUE (user1Name, user2Name, 0);
END //
DELIMITER ;
-- CALL addFriend("gimatt", "greg");

-- PROCEDURE TO REMOVE FRIENDS 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.removeFriend;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.removeFriend(user1Name VARCHAR(30), user2Name VARCHAR(30)) 
BEGIN 
DELETE FROM ZodiacAndNumerology.Friends WHERE ((Friends.user1Name = user1Name) AND (Friends.user2Name = user2Name));
END //
DELIMITER ;
-- CALL removeFriend("gimatt", "greg");


-- PROCEDURE TO ADD FRIENDS AS BEST FRIENDS REMOVE BEST FRIENDS
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.addBestFriend;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.addBestFriend(user1Name VARCHAR(30), user2Name VARCHAR(30))
BEGIN 
UPDATE ZodiacAndNumerology.Friends SET Friends.bestFriend = 1 WHERE 
((Friends.user1Name = user1Name) AND (Friends.user2Name = user2Name));
END //
DELIMITER ;
CALL addBestFriend("gimatt", "greg");

-- PROCEDURE TO REMOVE FRIENDS AS BEST FRIENDS 
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.removeBestFriend;
DELIMITER // 
CREATE PROCEDURE ZodiacAndNumerology.removeBestFriend(user1Name VARCHAR(30), user2Name VARCHAR(30))
BEGIN 
UPDATE ZodiacAndNumerology.Friends SET Friends.bestFriend = 0 WHERE 
((Friends.user1Name = user1Name) AND (Friends.user2Name = user2Name));
END //
DELIMITER ;
CALL removeBestFriend("gimatt", "greg");

-- FUNCTION TO GET 2022 HOROSCOPE 
-- GETS HOROSCOPE FROM KUA NUMER -> BASED ON LUCKY AND UNLUCKY DIRECTION
-- THIS WILL RETURN ONE EVENT THAT IS "LIKELY" TO HAPPEN AND ONE EVENT THAT IS "UNLIKELY" TO HAPPEN
DROP PROCEDURE IF EXISTS ZodiacAndNumerology.get2022Horoscope;
DELIMITER //
CREATE PROCEDURE ZodiacAndNumerology.get2022Horoscope(mob INT, dob INT, yob INT, sexAtBirth VARCHAR(10)) 
BEGIN 
DECLARE kuaNum INT;
DECLARE luckyDirection VARCHAR(30);
DECLARE unluckyDirection VARCHAR(30);
DECLARE likelyEvent VARCHAR(100);
DECLARE unlikelyEvent VARCHAR(100);
SET kuaNum = ZodiacAndNumerology.getKuaNumber(mob, dob, yob, sexAtBirth);
SELECT KuaNumbers.kuaLuckyDirection INTO luckyDirection FROM KuaNumbers WHERE (kuaNum = KuaNumbers.kuaNumber);
SELECT KuaNumbers.kuaUnluckyDirection INTO unluckyDirection FROM KuaNumbers WHERE (kuaNum = KuaNumbers.kuaNumber);
(SELECT CurrentYearHoroscope.yearPrediction AS predictions FROM CurrentYearHoroscope 
WHERE (CurrentYearHoroscope.directionType = luckyDirection)) 
UNION 
(SELECT CurrentYearHoroscope.yearPrediction AS unlucky FROM CurrentYearHoroscope 
WHERE (CurrentYearHoroscope.directionType = unluckyDirection)); 
END //
DELIMITER ;
-- PROCEDURE TEST 
CALL get2022Horoscope(10, 8, 2002, "female");
CALL get2022Horoscope(02, 29, 1996, "male");