note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER

create
	make

feature -- Initialization
	make
		do
			id := 0

			col_pos := 0
			row_pos := 0

			curr_health := 0
			curr_energy := 0
			health := 0
			energy := 0

			health_regen := 0
			energy_regen := 0
			vision := 0
			armour := 0
			move := 0
			move_cost := 0
			projectile_damage := 0
			projectile_cost := 0

			score := 0

			weapon_selected := create {WEAPON_STANDARD}.make
			armour_selected := create {ARMOUR_NONE}.make
			engine_selected := create {ENGINE_STANDARD}.make
			power_selected := create {RECALL}.make
		end


feature -- Attributes

	id : INTEGER

	col_pos : INTEGER
	row_pos : INTEGER

	curr_health : INTEGER
	curr_energy : INTEGER
	health : INTEGER
	energy : INTEGER
	health_regen : INTEGER
	energy_regen : INTEGER
	vision : INTEGER
	armour : INTEGER
	move : INTEGER
	move_cost : INTEGER
	projectile_damage : INTEGER
	projectile_cost : INTEGER

	score : INTEGER

	weapon_selected : WEAPON
	armour_selected : ARMOUR
	engine_selected : ENGINE
	power_selected : POWER

feature -- Commands

	regenerate
		do
			if curr_health + health_regen > health then
				curr_health := health
			else
				curr_health := curr_health + health_regen
			end

			if curr_energy + energy_regen > energy then
				curr_energy := energy
			else
				curr_energy := curr_energy + energy_regen
			end
		end

	move_starfighter (row: INTEGER_32 ; column: INTEGER_32)
		local
			i : INTEGER
		do
			if row = row_pos and column /= col_pos then

				-- Move Right
				if column > col_pos then

					from
						i := col_pos
					until
						i >= column
					loop
						set_col_pos (col_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

				-- Move Left
				-- column < col_pos
				else

					from
						i := col_pos
					until
						i <= column
					loop
						set_col_pos (col_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end

				end

			elseif row /= row_pos and column = col_pos then

				-- Move Up
				if row > row_pos then

					from
						i := row_pos
					until
						i >= row
					loop
						set_row_pos (row_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

				-- Move Down
				-- row < row_pos
				else

					from
						i := row_pos
					until
						i <= row
					loop
						set_row_pos (row_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end

				end

			else

				if row > row_pos and column > col_pos then

					-- Move Up then Right

					from
						i := row_pos
					until
						i >= row
					loop
						set_row_pos (row_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

					from
						i := col_pos
					until
						i >= column
					loop
						set_col_pos (col_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

				elseif row < row_pos and column > col_pos then

					-- Move Down then Right

					from
						i := row_pos
					until
						i <= row
					loop
						set_row_pos (row_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end

					from
						i := col_pos
					until
						i >= column
					loop
						set_col_pos (col_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

				elseif row > row_pos and column < col_pos then

					-- Move Up then Left

					from
						i := row_pos
					until
						i >= row
					loop
						set_row_pos (row_pos + 1)
						curr_energy := curr_energy - move_cost
						i := i + 1
					end

					from
						i := col_pos
					until
						i <= column
					loop
						set_col_pos (col_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end

				-- row < row_pos and column < col_pos
				else

					-- Move Down then Left

					from
						i := row_pos
					until
						i <= row
					loop
						set_row_pos (row_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end

					from
						i := col_pos
					until
						i <= column
					loop
						set_col_pos (col_pos - 1)
						curr_energy := curr_energy - move_cost
						i := i - 1
					end
				end
			end
		end

feature -- Setters for Setting State

	set_col_pos (col : INTEGER)
		do
			col_pos := col
		end

	set_row_pos (row :INTEGER)
		do
			row_pos := row
		end

	set_weapon (weapon : WEAPON)
		do
			weapon_selected := weapon
		end

	set_armour (armour_val : ARMOUR)
		do
			armour_selected := armour_val
		end

	set_engine (engine : ENGINE)
		do
			engine_selected := engine
		end

	set_power (power : POWER)
		do
			power_selected := power
		end

feature -- Exit Game

	reset
		do
			-- Add Up all Selections
			curr_health := weapon_selected.health + armour_selected.health + engine_selected.health
			curr_energy := weapon_selected.energy + armour_selected.energy + engine_selected.energy
			health := weapon_selected.health + armour_selected.health + engine_selected.health
			energy := weapon_selected.energy + armour_selected.energy + engine_selected.energy
			health_regen := weapon_selected.health_regen + armour_selected.health_regen + engine_selected.health_regen
			energy_regen := weapon_selected.energy_regen + armour_selected.energy_regen + engine_selected.energy_regen
			vision := weapon_selected.vision + armour_selected.vision + engine_selected.vision
			armour := weapon_selected.armour + armour_selected.armour + engine_selected.armour
			move := weapon_selected.move + armour_selected.move + engine_selected.move
			move_cost := weapon_selected.move_cost + armour_selected.move_cost + engine_selected.move_cost
			projectile_damage :=  weapon_selected.projectile_damage + armour_selected.projectile_damage + engine_selected.projectile_damage
			projectile_cost :=  weapon_selected.projectile_cost + armour_selected.projectile_cost + engine_selected.projectile_cost

			score := 0
		end

end
