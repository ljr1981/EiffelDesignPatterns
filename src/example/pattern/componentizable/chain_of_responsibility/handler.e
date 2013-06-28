indexing

	description:

		"Handler"

	pattern: "Chain of Responsibility"
	reusable_version: "Chain of Responsibility library (see ${PATTERN}/library/chain_of_responsibility)"
	author: "Karine Arnout"
	copyright: "Copyright (c) 2002-2004, ETH Zurich, Switzerland"
	license: "Eiffel Forum License v2 (see License.txt)"
	date: "$Date: 2004/03/15 $"
	revision: "$Revision: 1.0 $"

deferred class HANDLER

feature {NONE} -- Initialization

	make (a_successor: like next) is
			-- Set `next' to `a_successor'.
		require
			a_successor_not_void: a_successor /= Void
		do
			next := a_successor
		ensure
			next_set: next = a_successor
		end

feature -- Access

	next: HANDLER
			-- Successor in the chain of responsibility

feature -- Status report

	can_handle: BOOLEAN is
			-- Can current handle the request?
		deferred
		end

	handled: BOOLEAN
			-- Has request been handled?

feature -- Element change

	set_next (a_successor: like next) is
			-- Set `next' to `a_successor'.
		do
			next := a_successor
		ensure
			next_set: next = a_successor
		end

feature -- Basic operation

	handle is
			-- Handle request if `can_handle'
			-- otherwise forward it to `next'.
			-- If `next' is void, set `handled' to False.
		do
			if can_handle then
				do_handle
				handled := True
			else
				if next /= Void then
					debug
						io.put_string (generating_type)
						io.put_string (" cannot handle request. Forward it to next handler.%N")
					end
					next.handle
					handled := next.handled
				else
					debug
						io.put_string ("Request not handled.%N")
					end
					handled := False
				end
			end
		ensure
			handled_if_possible: can_handle implies handled
			handled_by_next_otherwise: 
				(not can_handle and then next /= Void) implies handled = next.handled
			not_handled_if_next_is_void: 
				(not can_handle and then next = Void) implies not handled
		end

feature {NONE} -- Implementation

	do_handle is
			-- Handle request.
		require
			can_handle: can_handle
		deferred
		end

end
