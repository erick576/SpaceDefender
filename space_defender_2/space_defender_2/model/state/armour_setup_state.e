note
	description: "Summary description for {ARMOUR_SETUP_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_SETUP_STATE

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
			Result := false
		end

    display (game_info : GAME_INFO) : STRING
      -- Display current state
      do
      	Result := "Armour Setup"
      end

end
