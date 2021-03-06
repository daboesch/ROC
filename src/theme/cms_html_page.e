note
	description: "Summary description for {CMS_HTML_PAGE}."
	author: ""
	date: "$Date: 2015-02-16 20:14:19 +0100 (lun., 16 févr. 2015) $"
	revision: "$Revision: 96643 $"

class
	CMS_HTML_PAGE

create
	make,
	make_typed

feature {NONE} -- Initialization

	make_typed (a_type: attached like type)
			-- Make current page with optional page type `a_type'.
		do
			make
			type := a_type
		end

	make
		do
			create regions.make (5)
			language := "en"

			status_code := {HTTP_STATUS_CODE}.ok
			create header.make
			create {ARRAYED_LIST [STRING]} head_lines.make (5)
			header.put_content_type_text_html
			create variables.make (0)
		end

feature -- Access

	type: detachable READABLE_STRING_8
			-- Optional page type.
			-- such as "front", "about", ... that could be customized by themes.

	is_front: BOOLEAN

	is_https: BOOLEAN

	title: detachable READABLE_STRING_32

	language: STRING

	head_lines: LIST [STRING]

	head_lines_to_string: STRING
		do
			create Result.make_empty
			across
				head_lines as h
			loop
				Result.append (h.item)
				Result.append_character ('%N')
			end
		end

	variables: STRING_TABLE [detachable ANY]

feature -- Status


	status_code: INTEGER

feature -- Header

	header: HTTP_HEADER

feature -- Region

	regions: STRING_TABLE [STRING_8]
			-- header
			-- content
			-- footer
			-- could have sidebar first, sidebar second, ...

	region (n: STRING_8): STRING_8
		do
			if attached regions.item (n) as r then
				Result := r
			else
				Result := ""
				debug
					Result := "{{" + n + "}}"
				end
			end
		end

feature -- Element change

	set_is_front (b: BOOLEAN)
			-- Set `is_front' to `b'.
		do
			is_front := b
		end

	set_is_https (b: BOOLEAN)
			-- Set `is_https' to `b'.
		do
			is_https := b
		end

	register_variable (a_value: detachable ANY; k: READABLE_STRING_GENERAL)
		do
			variables.force (a_value, k)
		end

	add_to_region (s: STRING; k: STRING)
		local
			r: detachable STRING
		do
			r := regions.item (k)
			if r = Void then
				create r.make_from_string (s)
				set_region (r, k)
			else
				r.append (s)
			end
		end

	set_region (s: STRING; k: STRING)
		do
			regions.force (s, k)
		end

feature -- Element change

	set_status_code (c: like status_code)
		do
			status_code := c
		end

	set_language (s: like language)
		do
			language := s
		end

	set_title (s: like title)
		do
			title := s
		end

	add_meta_name_content (a_name: STRING; a_content: STRING)
		local
			s: STRING_8
		do
			s := "<meta name=%"" + a_name + "%" content=%"" + a_content + "%" />"
			head_lines.extend (s)
		end

	add_meta_http_equiv (a_http_equiv: STRING; a_content: STRING)
		local
			s: STRING_8
		do
			s := "<meta http-equiv=%"" + a_http_equiv + "%" content=%"" + a_content + "%" />"
			head_lines.extend (s)
		end

	add_style (a_href: STRING; a_media: detachable STRING)
		local
			s: STRING_8
		do
			s := "<link rel=%"stylesheet%" href=%""+ a_href + "%" type=%"text/css%""
			if a_media /= Void then
				s.append (" media=%""+ a_media + "%"")
			end
			s.append ("/>")
			head_lines.extend (s)
		end

	add_javascript_url (a_src: STRING)
		local
			s: STRING_8
		do
			s := "<script type=%"text/javascript%" src=%"" + a_src + "%"></script>"
			head_lines.extend (s)
		end

	add_javascript_content (a_script: STRING)
		local
			s: STRING_8
		do
			s := "<script type=%"text/javascript%">%N" + a_script + "%N</script>"
			head_lines.extend (s)
		end

note
	copyright: "2011-2014, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
