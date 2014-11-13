note
	description: "[API Layout, to provide paths(config, application, log, documentation, www, html cj)]"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	APPLICATION_LAYOUT

create
	make_default,
	make_with_path

feature {NONE} -- Initialization

	make_default
			-- Create a default layout based on current working directory.
		local
			p: PATH
		do
			create p.make_current
			p := p.extended ("site")
			make_with_path (p)
		end

	make_with_path (p: PATH)
			-- Create a layour based on a path `p'.
		do
			path := p.absolute_path.canonical_path
		end

feature -- Access

	path: PATH

feature -- Access: internal

	config_path: PATH
			-- Configuration file path.
		local
			p: detachable PATH
		do
			p := internal_config_path
			if p = Void then
				p := path.extended ("config")
				internal_config_path := p
			end
			Result := p
		end

	application_config_path: PATH
			-- Database Configuration file path.
		local
			p: detachable PATH
		do
			p := internal_application_config_path
			if p = Void then
				p := config_path.extended ("application_configuration.json")
				internal_application_config_path := p
			end
			Result := p
		end

	logs_path: PATH
			-- Directory for logs.
		local
			p: detachable PATH
		do
			p := internal_logs_path
			if p = Void then
				p := path.extended ("logs")
				internal_logs_path := p
			end
			Result := p
		end

	documentation_path: PATH
			-- Directory for API documentation.
		local
			p: detachable PATH
		do
			p := internal_documentation_path
			if p = Void then
				p := path.extended ("doc")
				internal_documentation_path := p
			end
			Result := p
		end

	www_path: PATH
			-- Directory for www.
		local
			p: detachable PATH
		do
			p := internal_www_path
			if p = Void then
				p := path.extended ("www")
				internal_www_path := p
			end
			Result := p
		end

	assets_path: PATH
			-- Directory for public assets.
			-- css, images, js.
		local
			p: detachable PATH
		do
			p := internal_assets_path
			if p = Void then
				p := www_path.extended ("assets")
				internal_assets_path := p
			end
			Result := p
		end

	template_path: PATH
			-- Directory for templates (HTML, etc).
		local
			p: detachable PATH
		do
			p := internal_template_path
			if p = Void then
				p := www_path.extended ("template")
				internal_template_path := p
			end
			Result := p
		end

feature {NONE} -- Implementation

	internal_config_path: detachable like config_path
			-- Configuration file path.

	internal_application_config_path: detachable like application_config_path
			-- Database Configuration file path.

	internal_logs_path: detachable like logs_path
			-- Directory for logs.

	internal_documentation_path: detachable like documentation_path
			-- Directory for API documentation.

	internal_www_path: detachable like www_path
			-- Directory for www.

	internal_assets_path: detachable like assets_path
			-- Directory for public assets.
			-- css, images, js.

	internal_template_path: detachable like template_path
			-- Directory for templates (HTML, etc).

end