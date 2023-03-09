DECLARE @c5 VARCHAR(5);
SELECT 'COALESCE', COALESCE(@c5, 'longer name') 
UNION ALL
SELECT 'ISNULL',   ISNULL(@c5,   'longer name');
GO

DECLARE @c5 VARCHAR(5);
SELECT 
  c = COALESCE(@c5, 'longer name'), 
  i = ISNULL(@c5, 'longer name')
INTO dbo.testing;
SELECT name, t = TYPE_NAME(system_type_id), max_length, is_nullable
  FROM sys.columns
  WHERE [object_id] = OBJECT_ID('dbo.testing');