note
	description: "Summary description for {COMPOSITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITE[T -> attached ANY]

feature {NONE}
	children : LINKED_LIST[T]

feature -- Abstraction function
	model : SEQ[T]
		do
			create Result.make_empty
			across
				children as cursor
			loop
				Result.append (cursor.item)
			end
		ensure
			consistent_counts:
				children.count = Result.count
			consistent_items:
				across
					1 |..| Result.count as i
				all
					Result[i.item] ~ children[i.item]
				end
		end

	add (c : T)
		do
			children.extend (c)
		ensure
			model.count ~ (old model.deep_twin).appended (c).count
		end
end
