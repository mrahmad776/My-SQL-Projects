CREATE DATABASE proj1;
USE proj1;
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100),
    PublishedYear INT,
    Genre VARCHAR(50)
);

CREATE TABLE Members
(
	MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM loans;

INSERT INTO Books (Title, Author, PublishedYear, Genre)
VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Classic'),
('1984', 'George Orwell', 1949, 'Dystopian'),
('Data Science for Beginners', 'John Doe', 2023, 'Tech'),
('SQL Mastery', 'Jane Smith', 2024, 'Tech'),
('The Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasy');

INSERT INTO Members (Name, Email, JoinDate)
VALUES 
('Alice Johnson', 'alice@example.com', '2024-01-15'),
('Bob Smith', 'bob@example.com', '2024-02-10'),
('Charlie Brown', 'charlie@example.com', '2024-03-05');

INSERT INTO Loans(LoanID, BookID, LoanDate,ReturnDate)
VALUES
(1,2,'2024-03-01',NULL),
(2,3,'2024-01-02',NULL),
(1,1,'2024-04-05','2024-05-18');
-- SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM loans;

SELECT 
    Members.Name AS MemberName, 
    Books.Title AS BookTitle, 
    Loans.LoanDate
FROM Loans
JOIN Members ON Loans.MemberID = Members.MemberID
JOIN Books ON Loans.BookID = Books.BookID;

SELECT Books.Title, Members.Name, Loans.LoanDate
FROM Loans
JOIN Books ON Loans.BookID = Books.BookID
JOIN Members ON Loans.MemberID = Members.MemberID
WHERE Loans.ReturnDate IS NULL;