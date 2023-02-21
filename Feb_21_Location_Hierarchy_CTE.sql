-- CTE Location Hierarchy
CREATE TABLE dbo.Location (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ParentID INT,
    IsEndLocation BIT NOT NULL
);
GO

INSERT INTO Location (ID, Name, ParentID, IsEndLocation)
VALUES
    (1, 'North America', NULL, 0),
    (2, 'Europe', NULL, 0),
    (3, 'USA', 1, 0),
    (4, 'Canada', 1, 0),
    (5, 'New York', 3, 0),
    (6, 'Boston', 3, 1),
    (7, 'Toronto', 4, 1),
    (8, 'London', 2, 0),
    (9, 'Paris', 2, 1),
    (10, 'Leeds', 8, 1),
    (11, 'Marseille', 9, 1);
Go


WITH LocationHierarchy (ID, Name, ParentID, Path, HierarchyLevel) AS
(
    -- Anchor member
    SELECT ID, Name, ParentID, CAST(Name AS VARCHAR(100)) AS Path, 0 AS HierarchyLevel
    FROM Location
    WHERE IsEndLocation = 1
    UNION ALL
    -- Recursive member
    SELECT L.ID, L.Name, L.ParentID, CAST(L.Name + ' > ' + LH.Path AS VARCHAR(100)), LH.HierarchyLevel + 1
    FROM Location L
    INNER JOIN LocationHierarchy LH ON L.ID = LH.ParentID
    WHERE L.IsEndLocation = 0
)
SELECT ID, Name, Path, HierarchyLevel, ParentID
FROM LocationHierarchy
ORDER BY HierarchyLevel
