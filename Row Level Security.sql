CREATE FUNCTION dbo.fn_UserAccessSecurity(@User AS SYSNAME)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS Is_accessrights
WHERE @User in (
	select ua.nObjectKey from dbo.UserAccess
	where user_name = USER_NAME() 
	) 
or USER_NAME() = 'sa';
GO

CREATE SECURITY POLICY UserAccess_SecurityPolicy
	ADD FILTER PREDICATE dbo.fn_UserAccessSecurity(nObjectKey) 
	ON dbo.Objects1
	ADD FILTER PREDICATE dbo.fn_UserAccessSecurity(nObjectKey) 
	ON dbo.Objects2
	ADD FILTER PREDICATE dbo.fn_UserAccessSecurity(nObjectKey) 
	ON dbo.Objects3
	ADD FILTER PREDICATE dbo.fn_UserAccessSecurity(nObjectKey) 
	ON dbo.Objects4
WITH (STATE = ON);
GO

-- может и не надо делать...
GRANT SELECT ON dbo.UserAccess TO IT;
GRANT SELECT ON dbo.UserAccess TO Sales;
GRANT SELECT ON dbo.UserAccess TO HR;
GRANT SELECT ON dbo.UserAccess TO Finance;
GRANT SELECT ON dbo.UserAccess TO HOD;

-- создаем таблицу для связи логина с nObjectKey
CREATE TABLE dbo.UserAccess
(
	row_id			int identify(1,1) not null primary key,
	user_name		varchar(50), -- ключ юзера
	object_key		int, -- ключ объекта
	date_create		date -- дата добавления
)

-- перечень пользователей бд логинов uid_sysusers
use SFZ_UZIYAMO_DEBUG
select * from sys.sysusers where islogin=1 and hasdbaccess=1
order by 1
