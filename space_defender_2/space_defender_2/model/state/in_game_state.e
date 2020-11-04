note
	description: "Summary description for {IN_GAME_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IN_GAME_STATE

inherit
	STATE

create
	make

feature
    set_choice (i : INTEGER)
  	  -- Set choice value
  	  do
  	  	choice := i
  	  end

  	in_game : BOOLEAN
  	  	-- Is this state in_game or not?
  		do
			Result := true
		end

    display (game_info : GAME_INFO) : STRING
      -- Display current state
      do
      	Result := "In Game"
      end
      
end
