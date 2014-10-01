note
	description : "tests application root class"
	date        : "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision    : "$Revision: 95678 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			user: USER_DATA_PROVIDER
			node: NODE_DATA_PROVIDER
			l_security: SECURITY_PROVIDER
		do
				-- Change the path.
			create connection.login_with_connection_string ("Driver=SQLite3 ODBC Driver;Database=./cms_lite.db;LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;")
			create user.make (connection)
			user.new_user ("test", "test", "test")
		end

	connection: DATABASE_CONNECTION_ODBC

end
