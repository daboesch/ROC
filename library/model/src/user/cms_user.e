note
	description: "[
				Interface representing a USER in the CMS system.
			]"
	date: "$Date: 2015-01-27 19:15:02 +0100 (mar., 27 janv. 2015) $"
	revision: "$Revision: 96542 $"

class
	CMS_USER

inherit

	DEBUG_OUTPUT

create
	make,
	make_with_id -- MAYBE: export to CMS_STORAGE

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_32)
			-- Create an object with name `a_name'.
		require
			a_name_not_empty: not a_name.is_whitespace
		do
			name := a_name
			initialize
		ensure
			name_set: name = a_name
		end

	make_with_id (a_id: INTEGER_64)
		require
			a_id_valid: a_id > 0
		do
			id := a_id
			name := {STRING_32} ""
			initialize
		ensure
			id_set: id = a_id
		end

	initialize
		do
			create creation_date.make_now_utc
		end

feature -- Access

	id: INTEGER_64
			-- Unique id.

	name: READABLE_STRING_32
			-- User name.

	password: detachable READABLE_STRING_32
			-- User password (plain text password).

	hashed_password: detachable READABLE_STRING_8
			-- Hashed user password.

	email: detachable READABLE_STRING_32
			-- User email.

	profile: detachable CMS_USER_PROFILE
			-- User profile.

	creation_date: DATE_TIME
			-- Creation date.

	last_login_date: detachable DATE_TIME
			-- User last login.

feature -- Roles

	roles: detachable LIST [CMS_USER_ROLE]
			-- If set, list of roles for current user.			

feature -- Access: data			

	data: detachable STRING_TABLE [detachable ANY]
			-- Additional data.

	data_item (k: READABLE_STRING_GENERAL): detachable ANY
			-- Additional item data associated with key `k'.
		do
			if attached data as l_data then
				Result := l_data.item (k)
			end
		end

feature -- Status report

	has_id: BOOLEAN
		do
			Result := id > 0
		end

	has_email: BOOLEAN
		do
			Result := attached email as e and then not e.is_empty
		end

	debug_output: STRING_32
		do
			create Result.make_from_string (name)
			if has_id then
				Result.append_character (' ')
				Result.append_character ('<')
				Result.append_integer_64 (id)
				Result.append_character ('>')
			end
		end

	same_as (other: detachable CMS_USER): BOOLEAN
			-- Is Current same as `other'?
		do
			Result := other /= Void and then id = other.id
		end

feature -- Change element

	set_id (a_id: like id)
			-- Set `id' with `a_id'.
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_name (n: like name)
			-- Set `name' with `n'.
		do
			name := n
		ensure
			name_set: name = n
		end

	set_password (a_password: like password)
			-- Set `password' with `a_password'.
		do
			password := a_password
			hashed_password := Void
		ensure
			password_set: password = a_password
			hashed_password_void: hashed_password = Void
		end

	set_hashed_password (a_hashed_password: like hashed_password)
			-- Set `hashed_password' with `a_hashed_password'.
		do
			hashed_password := a_hashed_password
			password := Void
		ensure
			password_void: password = Void
			hashed_password_set: hashed_password = a_hashed_password
		end

	set_email (a_email: like email)
			-- Set `email' with `a_email'.
		do
			email := a_email
		ensure
			email_set: email = a_email
		end

	set_profile (prof: like profile)
			-- Set `profile' with `prof'.
		do
			profile := prof
		ensure
			profile_set: profile = prof
		end

	set_profile_item (k: READABLE_STRING_8; v: READABLE_STRING_8)
		local
			prof: like profile
		do
			prof := profile
			if prof = Void then
				create prof.make
				profile := prof
			end
			prof.force (v, k)
		end

	set_last_login_date (dt: like last_login_date)
		do
			last_login_date := dt
		end

	set_last_login_date_now
		do
			set_last_login_date (create {DATE_TIME}.make_now_utc)
		end

feature -- Element change: roles

	set_roles (lst: like roles)
			-- Set `roles' to `lst'.
		do
			roles := lst
		end

feature -- Change element: data		

	set_data_item (k: READABLE_STRING_GENERAL; d: like data_item)
			-- Associate data item `d' with key `k'.
		local
			l_data: like data
		do
			l_data := data
			if l_data = Void then
				create l_data.make (1)
				data := l_data
			end
			l_data.force (d, k)
		end

	remove_data_item (k: READABLE_STRING_GENERAL)
			-- Remove data item associated with key `k'.	
		do
			if attached data as l_data then
				l_data.remove (k)
			end
		end

invariant

	id_or_name_set: id > 0 or else not name.is_whitespace

note
	copyright: "2011-2015, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
