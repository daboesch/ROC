note
	description: "[
			Theme used when expected theme is missing.
			It is mainly used to report missing theme error.
		]"
	date: "$Date: 2014-11-19 20:00:19 +0100 (mer., 19 nov. 2014) $"
	revision: "$Revision: 96123 $"

class
	MISSING_CMS_THEME

inherit

	CMS_THEME

create
	make

feature {NONE} -- Initialization

	make (a_setup: like setup)
		do
			setup := a_setup
		ensure
			setup_set: setup = a_setup
		end

feature -- Access

	name: STRING = "missing theme"

	regions: ARRAY [STRING]
		do
			create Result.make_empty
		end

	page_template: CMS_TEMPLATE
			-- theme template page.
		do
			create {MISSING_CMS_TEMPLATE} Result.make (Current)
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		do
			to_implement ("Add a better response message, maybe using smarty template")
			Result := "Service Unavailable"
		end
end
