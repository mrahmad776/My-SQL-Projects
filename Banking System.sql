CREATE DATABASE PROJ3;
USE PROJ3;

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    OwnerName VARCHAR(100),
    Balance DECIMAL(10, 2)
);

INSERT INTO Accounts (AccountID, OwnerName, Balance)
VALUES
    (1, 'Alice (Account A)', 1000.00),
    (2, 'Bob (Account B)', 500.00),
    (3, 'Charlie', 2500.00),
    (4, 'Diana', 150.50),
    (5, 'Evan', 0.00);
SELECT * FROM Accounts;

START TRANSACTION;
UPDATE Accounts
SET Balance = Balance - 100
Where AccountID = 1;

UPDATE Accounts
SET Balance = Balance + 100
Where AccountID = 2;

SELECT * FROM Accounts
COMMIT

DELIMITER $$
CREATE PROCEDURE Transactions()
BEGIN 
START TRANSACTION;
UPDATE Accounts
SET Balance = Balance - 100
Where AccountID = 1;

UPDATE Accounts
SET Balance = Balance + 100
Where AccountID = 2;

SELECT * FROM Accounts;
COMMIT;
END $$
DELIMITER ;

-- CALL TRANSACTIONS()

CREATE TABLE TransactionLogs 
(
id INT AUTO_INCREMENT PRIMARY KEY,
	AccountID INT,
    OldBalance INT,
    NewBalance INT,
	created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER UpdateTransaction
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN 
INSERT INTO TransactionLogs(AccountID,OldBalance,NewBalance)
VALUES(NEW.AccountID,Old.Balance,NEW.Balance);
END $$

DELIMITER ; 

CALL TRANSACTIONS();


