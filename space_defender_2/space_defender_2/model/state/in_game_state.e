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
		ensure then
			correct_output : Result = true
		end

    in_setup : BOOLEAN
        -- Is this state in setup or not?
  		do
			Result := false
		ensure then
			correct_output : Result = false
		end

	in_setup_select : BOOLEAN
  	    -- Is this state eligible for state setup?
  		do
			Result := false
		ensure then
			correct_output : Result = false
		end

	in_bounds (i : INTEGER) : BOOLEAN
	  -- Is the selected in the equipment selected bounds?
	  do
	  		Result := false
	  end

	setup_select (i : INTEGER)
	  -- Select the equipment only for setup states
	  do
	  end

    display : STRING
      -- Display current state
      do
		create Result.make_empty
      	game_info.set_state_message (game_info.state_in_game)
      	game_info.set_state_specific_message ("")

      	if game_info.is_error then
      		game_info.set_status_message (game_info.error_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_error)

      	elseif game_info.is_valid_operation then
      		game_info.set_status_message (game_info.ok_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_operation)
      	else
      		game_info.set_status_message (game_info.ok_status)
      		Result.append (game_info.display_state)
	      	Result.append (game_info.display_state_specific)
	      	Result.append ("%N")
	      	Result.append (game_info.display_objects)
	      	Result.append ("%N")

	      	if game_info.in_normal_mode = false then
	     		Result.append (game_info.display_debug_mode)
			end

	      	Result.append (game_info.display_grid)
      	end

      end

end
