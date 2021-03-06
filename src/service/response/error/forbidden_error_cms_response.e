note
	description: "Summary description for {FORBIDDEN_ERROR_CMS_RESPONSE}."
	date: "$Date: 2014-11-13 19:34:00 +0100 (jeu., 13 nov. 2014) $"
	revision: "$Revision: 96086 $"

class
	FORBIDDEN_ERROR_CMS_RESPONSE

inherit

	CMS_RESPONSE
		redefine
			custom_prepare
		end

create
	make

feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			page.register_variable (request.absolute_script_url (request.path_info), "request")
			page.set_status_code ({HTTP_STATUS_CODE}.forbidden)
			page.register_variable (page.status_code.out, "code")
		end

feature -- Execution

	process
			-- Computed response message.
		do
			set_title ("Forbidden")
			set_page_title ("Forbidden")
			set_main_content ("<em>Access denied for resource <strong>" + request.request_uri + "</strong>.</em>")
		end
end

