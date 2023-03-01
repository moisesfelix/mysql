DROP SCHEMA IF EXISTS tic_tac_toe;
CREATE SCHEMA tic_tac_toe;
USE tic_tac_toe;
#PROCEDURE TO INIT GAME
DELIMITER $$ 
    DROP PROCEDURE IF EXISTS tic_tac_toe.init $$
	CREATE PROCEDURE tic_tac_toe.init()
    BEGIN
		CREATE TABLE tic_tac_toe.game (
			__ varchar(3),
			c_1 int,
			c_2 int,
			c_3 int,
			PRIMARY KEY(__)
		);

		#INIT GAME
		INSERT INTO tic_tac_toe.game (__) VALUES ("r_1");
		INSERT INTO tic_tac_toe.game (__) VALUES ("r_2");
		INSERT INTO tic_tac_toe.game (__) VALUES ("r_3");

	END $$	
DELIMITER ;
#PROCEDURE TO PLAY GAME
DELIMITER $$
    DROP PROCEDURE IF EXISTS tic_tac_toe.play $$
	CREATE PROCEDURE tic_tac_toe.play(
		r INT, 
		c INT,
        who VARCHAR(255)
        )
    BEGIN
        CASE c
			WHEN 1 THEN 
				UPDATE tic_tac_toe.game
					SET c_1 = who
					WHERE __ = CONCAT("r_", r);
			WHEN 2 THEN 
				UPDATE tic_tac_toe.game
					SET c_2 = who
					WHERE __ = CONCAT("r_", r);
			WHEN 3 THEN 
				UPDATE tic_tac_toe.game
					SET c_3 = who
					WHERE __ = CONCAT("r_", r);
		END CASE;
		SELECT * FROM tic_tac_toe.game;
	END $$	
DELIMITER ;
#PROCEDURE TO RESET GAME
DELIMITER $$
    DROP PROCEDURE IF EXISTS tic_tac_toe.resetGame $$
	CREATE PROCEDURE tic_tac_toe.resetGame()
    BEGIN
		UPDATE tic_tac_toe.game SET c_1 = NULL WHERE __ = CONCAT("r_", 1);    
        UPDATE tic_tac_toe.game SET c_1 = NULL WHERE __ = CONCAT("r_", 2);   
		UPDATE tic_tac_toe.game SET c_1 = NULL WHERE __ = CONCAT("r_", 3);   
		UPDATE tic_tac_toe.game SET c_2 = NULL WHERE __ = CONCAT("r_", 1);   
		UPDATE tic_tac_toe.game SET c_2 = NULL WHERE __ = CONCAT("r_", 2);   
		UPDATE tic_tac_toe.game SET c_2 = NULL WHERE __ = CONCAT("r_", 3);   
		UPDATE tic_tac_toe.game SET c_3 = NULL WHERE __ = CONCAT("r_", 1);   
		UPDATE tic_tac_toe.game SET c_3 = NULL WHERE __ = CONCAT("r_", 2);
        UPDATE tic_tac_toe.game SET c_3 = NULL WHERE __ = CONCAT("r_", 3);
	END $$	
DELIMITER ;
#PROCEDURE TO VERIFY IF PLAYER IS WIN
DELIMITER $$
    DROP PROCEDURE IF EXISTS tic_tac_toe.verifyIfWin $$
	CREATE PROCEDURE tic_tac_toe.verifyIfWin(IN player int, OUT result int)
    BEGIN
		DECLARE r1, r2, r3, result INT;
        DECLARE win VARCHAR(255);
		SET r1 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_1 = player AND __ = "r_1"));
		SET r2 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_2 = player AND __ = "r_2"));
		SET r3 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_3 = player AND __ = "r_3"));                
		SET result = r1 + r2 + r3;        
        IF result = 3 THEN  SET win = "diagonal win";
			ELSE 
				SET result = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE c_1 = player AND c_2 = player AND c_3 = player AND __ = "r_1");
				IF result = 1 THEN  SET win = "horizontal line 1 win";
					ELSE 
						SET result = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE c_1 = player AND c_2 = player AND c_3 = player AND __ = "r_2");
						IF result = 1 THEN  SET win = "horizontal line 2 win";
                        ELSE 
							SET result = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE c_1 = player AND c_2 = player AND c_3 = 0 AND __ = "r_3");
							IF result = 1 THEN  SET win = "horizontal line 3 win";
                            ELSE
								SET r1 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_1 = player AND __ = "r_1"));
								SET r2 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_1 = player AND __ = "r_2"));
								SET r3 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_1 = player AND __ = "r_3"));
								SET result = r1 + r2 + r3;
								IF result = 3 THEN  SET win = "vertical col 1 win";
								ELSE
									SET r1 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_2 = player AND __ = "r_1"));
									SET r2 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_2 = player AND __ = "r_2"));
									SET r3 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_2 = player AND __ = "r_3"));
									SET result = r1 + r2 + r3;
									IF result = 3 THEN  SET win = CONCAT("vertical col 2 win: ", player);
										ELSE
										SET r1 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_3 = player AND __ = "r_1"));
										SET r2 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_3 = player AND __ = "r_2"));
										SET r3 = (SELECT COUNT(*) FROM tic_tac_toe.game WHERE (c_3 = player AND __ = "r_3"));
										SET result = r1 + r2 + r3;
										IF result = 3 THEN  SET win = CONCAT("vertical col 3 win: ", player);
										END IF;	
									END IF;
								END IF;
							END IF;
						END IF;
				END IF;
        END IF;
        SELECT win;
	END $$	
DELIMITER ;

CALL tic_tac_toe.init();
CALL tic_tac_toe.resetGame();
CALL tic_tac_toe.play(1,3,0);
CALL tic_tac_toe.play(2,3,0);
#CALL tic_tac_toe.play(2,3,0);
CALL tic_tac_toe.play(3,3,0);
call tic_tac_toe.verifyIfWin(0, @result);
#SELECT * FROM tic_tac_toe.game;