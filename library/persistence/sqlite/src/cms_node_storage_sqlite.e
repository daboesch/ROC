note
	description: "Summary description for {CMS_NODE_STORAGE_SQLITE}."
	author: ""
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

deferred class
	CMS_NODE_STORAGE_SQLITE

inherit
	CMS_NODE_STORAGE_SQL
		redefine
			nodes, recent_nodes
		end

feature {NONE} -- Implementation

	db_handler: DATABASE_HANDLER
		deferred
		end

feature -- Access		

	nodes: LIST [CMS_NODE]
			-- List of nodes.
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
			across nodes_iterator as ic loop
				if attached ic.item as l_node then
					Result.force (l_node)
				end
			end
		end

	recent_nodes (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_NODE]
			-- List of recent `a_count' nodes with an offset of `lower'.
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (a_count)
			across recent_nodes_iterator (a_lower, a_count) as ic loop
				if attached ic.item as l_node then
					Result.force (l_node)
				end
			end
		end

feature -- Access: iterator		

	nodes_iterator: DATABASE_ITERATION_CURSOR [detachable CMS_NODE]
			-- List of nodes.
		local
			l_parameters: STRING_TABLE [ANY]
		do
			error_handler.reset
			write_information_log (generator + ".nodes_iterator")
			create l_parameters.make (0)
			sql_query (sql_select_nodes, l_parameters)
			create Result.make (db_handler, agent fetch_node)
		end

	recent_nodes_iterator (a_lower, a_rows: INTEGER): DATABASE_ITERATION_CURSOR [detachable CMS_NODE]
			-- The most recent `a_rows'.
		local
			l_parameters: STRING_TABLE [ANY]
			l_query: STRING
		do
			-- FIXME: check implementation...
			error_handler.reset
			write_information_log (generator + ".recent_nodes_iterator")
			create l_parameters.make (2)
			l_parameters.put (a_rows, "rows")
			l_parameters.put (a_lower, "offset")
			create l_query.make_from_string (sql_select_recent_nodes)
			sql_query (l_query, l_parameters)
			create Result.make (db_handler, agent fetch_node)
		end

end
