note
	description: "[
			Interface responsible to instantiate CMS_STORAGE_MYSQL object.
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-01-27 19:15:02 +0100 (mar., 27 janv. 2015) $"
	revision: "$Revision: 96542 $"

class
	CMS_STORAGE_MYSQL_BUILDER

inherit
	CMS_STORAGE_STORE_SQL_BUILDER

	GLOBAL_SETTINGS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
		end

feature -- Factory

	storage (a_setup: CMS_SETUP): detachable CMS_STORAGE_MYSQL
		local
			conn: DATABASE_CONNECTION
		do
			if attached (create {APPLICATION_JSON_CONFIGURATION_HELPER}).new_database_configuration (a_setup.environment.application_config_path) as l_database_config then
				create {DATABASE_CONNECTION_MYSQL} conn.login_with_connection_string (l_database_config.connection_string)
				if conn.is_connected then
					create Result.make (conn)
					set_map_zero_null_value (False)	--| This way we map 0 to 0, instead of Null as default.
					if Result.is_available then
						if not Result.is_initialized then
							initialize (a_setup, Result)
						end
					end
				end
			end
		end


end
