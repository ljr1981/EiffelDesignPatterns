indexing

	description:

		"Component"

	library: "Composite library"
	author: "Karine Arnout"
	copyright: "Copyright (c) 2002-2004, ETH Zurich, Switzerland"
	license: "Eiffel Forum License v2 (see License.txt)"
	date: "$Date: 2004/03/15 $"
	revision: "$Revision: 1.0 $"

deferred class COMPONENT [G]

feature -- Basic Operation

	do_something is
			-- Do something.
		deferred
		end

feature -- Status report

	is_composite: BOOLEAN is
			-- Is component a composite?
		do
			Result := False
		end

feature -- Access

	item: COMPONENT [G] is
			-- Current part of composite
		require
			is_composite: is_composite
		do
			Result := parts.item
		ensure
			definition: Result = parts.item
			component_not_void: Result /= Void
		end

	i_th, infix "@" (i: INTEGER): like item is
			-- `i'-th part
		require
			is_composite: is_composite
			index_valid: i > 0 and i <= count
		do
			Result := parts @ i
		ensure
			definition: Result = parts @ i
			component_not_void: Result /= Void
		end

	first: like item is
			-- First component part
		require
			is_composite: is_composite
			not_empty: not is_empty
		do
			Result := parts.first
		ensure
			definition: Result = parts.first
			component_not_void: Result /= Void
		end

	last: like item is
			-- Last component part
		require
			is_composite: is_composite
			not_empty: not is_empty
		do
			Result := parts.last
		ensure
			definition: Result = parts.last
			component_not_void: Result /= Void
		end

feature -- Status report

	has (a_part: like item): BOOLEAN is
			-- Does composite contain `a_part'?
		require
			is_composite: is_composite
			a_part_not_void: a_part /= Void
		do
			Result := parts.has (a_part)
		ensure
			definition: Result = parts.has (a_part)
		end

	is_empty: BOOLEAN is
			-- Does component contain no part?
		require
			is_composite: is_composite
		do
			Result := parts.is_empty
		ensure
			definition: Result = (count = 0)
		end

	off: BOOLEAN is
			-- Is there no component at current position?
		require
			is_composite: is_composite
		do
			Result := parts.off
		ensure
			definition: Result = (after or before)
		end

	after: BOOLEAN is
			-- Is there no valid position to the right of current one?
		require
			is_composite: is_composite
		do
			Result := parts.after
		ensure
			definition: Result = parts.after
		end

	before: BOOLEAN is
			-- Is there no valid position to the left of current one?
		require
			is_composite: is_composite
		do
			Result := parts.before
		ensure
			definition: Result = parts.before
		end

feature -- Measurement

	count: INTEGER is
			-- Number of component parts
		require
			is_composite: is_composite
		do
			Result := parts.count
		ensure
			definition: Result = parts.count
		end

feature -- Element change

	add (a_part: like item) is
			-- Add `a_part' to component `parts'.
		require
			is_composite: is_composite
			a_part_not_void: a_part /= Void
			not_part: not has (a_part)
		do
			debug
				io.put_string ("Adding a part to a composite.%N")
			end
			parts.extend (a_part)
		ensure
			one_more: parts.count = old parts.count + 1
			has_part: has (a_part)
		end

feature -- Removal

	remove (a_part: like item) is
			-- Remove `a_part' from component `parts'.
		require
			is_composite: is_composite
			a_part_not_void: a_part /= Void
			has_part: has (a_part)
		do
			debug
				io.put_string ("Removing a part from a composite.%N")
			end
			parts.search (a_part)
			parts.remove
		ensure
			one_less: parts.count = old parts.count - 1
			not_part: not has (a_part)
		end

feature -- Cursor movement

	start is
			-- Move cursor to first component part.
			-- Go `after' if no such part.
		require
			is_composite: is_composite
		do
			parts.start
		end

	forth is
			-- Move cursor to the next component.
			-- Go `after' if no such part.
		require
			is_composite: is_composite
			not_after: not after
		do
			parts.forth
		end

	finish is
			-- Move cursor to last component.
			-- Go `before' if no such part.
		require
			is_composite: is_composite
		do
			parts.finish
		end

	back is
			-- Move cursor to the previous component.
			-- Go `before' if no such part.
		require
			is_composite: is_composite
			not_before: not before
		do
			parts.back
		end

feature {NONE} -- Implementation

	parts: LINKED_LIST [like item] is
			-- Component parts (which are themselves components)
		deferred
		end

invariant

	parts_consistent:
		is_composite implies (parts /= Void and then not parts.has (Void))
	
end
