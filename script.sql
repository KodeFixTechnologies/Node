-- Create Database
CREATE DATABASE CompanyDB;
GO

-- Use Database
USE CompanyDB;
GO

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL
);

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2),
    DepartmentID INT,
    HireDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE
);

-- Create Employee_Project Table (Many-to-Many Relationship)
CREATE TABLE Employee_Project (
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE DEFAULT GETDATE(),
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Insert Departments
INSERT INTO Departments (DepartmentName) VALUES ('HR'), ('IT'), ('Finance'), ('Marketing');

-- Insert Employees
INSERT INTO Employees (FirstName, LastName, Email, Salary, DepartmentID) VALUES 
('John', 'Doe', 'john.doe@email.com', 50000, 1),
('Jane', 'Smith', 'jane.smith@email.com', 60000, 2),
('Alice', 'Brown', 'alice.brown@email.com', 55000, 3),
('Bob', 'Williams', 'bob.williams@email.com', 70000, 2);

-- Insert Projects
INSERT INTO Projects (ProjectName, StartDate, EndDate) VALUES 
('Website Development', '2024-01-01', '2024-06-01'),
('Mobile App', '2024-02-15', '2024-08-15'),
('Cloud Migration', '2024-03-10', '2024-09-10');

-- Assign Employees to Projects
INSERT INTO Employee_Project (EmployeeID, ProjectID) VALUES 
(1, 1), (2, 1), (2, 2), (3, 2), (3, 3), (4, 3);

-- Stored Procedure: Get Employees by Department
CREATE PROCEDURE GetEmployeesByDepartment @DeptID INT
AS
BEGIN
    SELECT * FROM Employees WHERE DepartmentID = @DeptID;
END;

-- Stored Procedure: Pagination
CREATE PROCEDURE GetEmployeesPaged
    @PageNumber INT,
    @PageSize INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Employees
    ORDER BY EmployeeID
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

-- Example Queries
-- Get All Employees with Departments
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Get Employees Working on Projects
SELECT e.FirstName, e.LastName, p.ProjectName, ep.AssignedDate
FROM Employees e
INNER JOIN Employee_Project ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID;

-- Execute Stored Procedures
-- Get Employees by Department (Example: Department ID 2)
EXEC GetEmployeesByDepartment @DeptID = 2;

-- Get Employees with Pagination (Example: Page 2, 2 Records Per Page)
EXEC GetEmployeesPaged @PageNumber = 2, @PageSize = 2;
