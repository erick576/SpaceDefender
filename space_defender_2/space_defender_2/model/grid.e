note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create
	make

feature -- Initialization
	make (row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		do
			row_size := row
			col_size := column
			grunt_threshold := g_threshold
			fighter_threshold := f_threshold
			carrier_threshold := c_threshold
			interceptor_threshold := i_threshold
			pylon_threshold := p_threshold

			projectile_id_counter := 0
			enemy_id_counter := 0

			create {ARRAYED_LIST[FRIENDLY_PROJECTILE]} friendly_projectiles.make (0)
			create {ARRAYED_LIST[ENEMY_PROJECTILE]} enemy_projectiles.make (0)

			create {ARRAYED_LIST[ENEMY]} enemies.make (0)

			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_filled ('_', 0, row_size * col_size)
		end

feature -- Attributes

	row_size : INTEGER_32
	col_size : INTEGER_32
	grunt_threshold : INTEGER_32
	fighter_threshold : INTEGER_32
	carrier_threshold : INTEGER_32
	interceptor_threshold : INTEGER_32
	pylon_threshold : INTEGER_32

	projectile_id_counter : INTEGER
	enemy_id_counter : INTEGER

	friendly_projectiles : LIST[FRIENDLY_PROJECTILE]
	enemy_projectiles : LIST[ENEMY_PROJECTILE]

	enemies : LIST[ENEMY]

	grid_char_rows : ARRAY[CHARACTER]
	grid_elements : ARRAY[CHARACTER]


	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

feature -- Helper Methods

	can_see (starfighter : STARFIGHTER ; row : INTEGER ; column : INTEGER) : BOOLEAN
		-- Is this spot in the starfighters vision ?
		local
			column_diff, row_diff : INTEGER
		do
			if (starfighter.col_pos - column) >= 0 then
				column_diff := starfighter.col_pos - column
			else
				column_diff := column - starfighter.col_pos
			end

			if (starfighter.row_pos - row) >= 0 then
				row_diff := starfighter.row_pos - row
			else
				row_diff := row - starfighter.row_pos
			end

			if (starfighter.vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	can_be_seen (starfighter : STARFIGHTER ; enemy_vision : INTEGER ; enemy_row : INTEGER ; enemy_column : INTEGER) : BOOLEAN
		-- Can a Ememy see the starfighter?
		local
			column_diff, row_diff : INTEGER
		do
			if (enemy_column - starfighter.col_pos) >= 0 then
				column_diff := enemy_column - starfighter.col_pos
			else
				column_diff := starfighter.col_pos - enemy_column
			end

			if (enemy_row - starfighter.row_pos) >= 0 then
				row_diff := enemy_row - starfighter.row_pos
			else
				row_diff := starfighter.row_pos - enemy_row
			end

			if (enemy_vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	can_see_enemy (other_enemy : ENEMY ; enemy_vision : INTEGER ; enemy_row : INTEGER ; enemy_column : INTEGER) : BOOLEAN
		-- Can a Ememy see the enemy?
		local
			column_diff, row_diff : INTEGER
		do
			if (enemy_column - other_enemy.col_pos) >= 0 then
				column_diff := enemy_column - other_enemy.col_pos
			else
				column_diff := other_enemy.col_pos - enemy_column
			end

			if (enemy_row - other_enemy.row_pos) >= 0 then
				row_diff := enemy_row - other_enemy.row_pos
			else
				row_diff := other_enemy.row_pos - enemy_row
			end

			if (enemy_vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	is_in_bounds (row : INTEGER ; column : INTEGER) : BOOLEAN
		do
			Result := not (row > row_size or row < 1 or column > col_size or column < 1)
		ensure
			in_bounds : (Result = true and (not (row > row_size or row < 1 or column > col_size or column < 1))) or  (Result = false and ((row > row_size or row < 1 or column > col_size or column < 1)))
		end

feature -- Commands

	add_friendly_projectile_standard (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_STANDARD}.make (row, col, i, t))
		ensure
			size_incremented : friendly_projectiles.count = old friendly_projectiles.count + 1
		end

	add_friendly_projectile_spread (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SPREAD}.make (row, col, i, t))
		ensure
			size_incremented : friendly_projectiles.count = old friendly_projectiles.count + 1
		end

	add_friendly_projectile_snipe (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SNIPE}.make (row, col, i, t))
		ensure
			size_incremented : friendly_projectiles.count = old friendly_projectiles.count + 1
		end

	add_friendly_projectile_rocket (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_ROCKET}.make (row, col, i, t))
		ensure
			size_incremented : friendly_projectiles.count = old friendly_projectiles.count + 1
		end

	add_friendly_projectile_splitter (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SPLITTER}.make (row, col, i, t))
		ensure
			size_incremented : friendly_projectiles.count = old friendly_projectiles.count + 1
		end

	add_enemy_projectile_grunt (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_GRUNT}.make (row, col, i, t, d))
		ensure
			size_incremented : enemy_projectiles.count = old enemy_projectiles.count + 1
		end

	add_enemy_projectile_fighter (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER ; m : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_FIGHTER}.make (row, col, i, t, d, m))
		ensure
			size_incremented : enemy_projectiles.count = old enemy_projectiles.count + 1
		end

	add_enemy_projectile_pylon (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_PYLON}.make (row, col, i, t, d))
		ensure
			size_incremented : enemy_projectiles.count = old enemy_projectiles.count + 1
		end

	increment_projectile_id_counter
		do
			projectile_id_counter := projectile_id_counter - 1
		ensure
			counter_updated : projectile_id_counter = old projectile_id_counter - 1
		end

	increment_enemy_id_counter
		do
			enemy_id_counter := enemy_id_counter + 1
		ensure
			counter_updated : enemy_id_counter = old enemy_id_counter + 1
		end

feature -- Turn Commands

	fire
		require
			is_alive : game_info.is_alive = true
		do
			-- Add to debug output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) fires at location [" + grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "]." + "%N")
			end

			game_info.starfighter.weapon_selected.fire
		end

	friendly_projectile_movements
		require
			is_alive : game_info.is_alive = true
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > friendly_projectiles.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					friendly_projectiles.at (index_curr).do_turn
				else
					index_curr := friendly_projectiles.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	enemy_projectile_movements
		require
			is_alive : game_info.is_alive = true
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > enemy_projectiles.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					enemy_projectiles.at (index_curr).do_turn
				else
					index_curr := enemy_projectiles.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	update_enemy_vision
		require
			is_alive : game_info.is_alive = true
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > enemies.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					if is_in_bounds (enemies.at (index_curr).row_pos , enemies.at (index_curr).col_pos) then
						enemies.at (index_curr).update_seen_by_starfighter
						enemies.at (index_curr).update_can_see_starfighter
					end
				else
					index_curr := enemies.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	enemy_spawn
		require
			is_alive : game_info.is_alive = true
		local
			random : RANDOM_GENERATOR_ACCESS
			j , damage_with_armour: INTEGER
			first_num, second_num : INTEGER
			did_spawn , do_spawn : BOOLEAN
		do
			first_num := random.rchoose (1, row_size)
			second_num := random.rchoose (1, 100)

			-- Check if occupied
			do_spawn := true
			from
				j := 1
			until
				j > enemies.count
			loop
				if enemies.at (j).row_pos = first_num and enemies.at (j).col_pos = col_size then
					do_spawn := false
				end
				j := j + 1
			end

			if do_spawn = true then

				did_spawn := false

				if second_num >= 1 and second_num < grunt_threshold then
					-- Grunt Spawns
					increment_enemy_id_counter
					enemies.force (create {GRUNT}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= grunt_threshold and second_num < fighter_threshold then
					-- Fighter Spawns
					increment_enemy_id_counter
					enemies.force (create {FIGHTER}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= fighter_threshold and second_num < carrier_threshold then
					-- Carriern Spawns
					increment_enemy_id_counter
					enemies.force (create {CARRIER}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= carrier_threshold and second_num < interceptor_threshold then
					-- Interceptor Spawns
					increment_enemy_id_counter
					enemies.force (create {INTERCEPTOR}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= interceptor_threshold and second_num < pylon_threshold then
					-- Pylon Spawns
					increment_enemy_id_counter
					enemies.force (create {PYLON}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				else
					-- Nothing Spawns
					did_spawn := false
				end

				-- Collision Checks
				if did_spawn = true then

					-- Update seen
					enemies.at (enemies.count).update_can_see_starfighter
					enemies.at (enemies.count).update_seen_by_starfighter

					-- Add to debug Output
					if not game_info.in_normal_mode then
						game_info.append_natural_enemy_spawn_info ("    A " + enemies.at (enemies.count).name + "(id:" + enemies.at (enemies.count).id.out + ") spawns at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "].")
					end

					-- Collisions with Friendly Projectiles
					from
						j := 1
					until
						j > friendly_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = friendly_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = friendly_projectiles.at (j).col_pos then
							damage_with_armour := friendly_projectiles.at (j).damage - enemies.at (enemies.count).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health - damage_with_armour)

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (friendly_projectiles.at (j).row_pos, friendly_projectiles.at (j).col_pos) then
								game_info.append_natural_enemy_spawn_info ("      The " + enemies.at (enemies.count).name + " collides with friendly projectile(id:" +  friendly_projectiles.at (j).id.out + ") at location [" + grid_char_rows.at (friendly_projectiles.at (j).row_pos).out + "," + friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage.")
							end

							if enemies.at (enemies.count).curr_health < 0 then
								enemies.at (enemies.count).set_curr_health (0)
							end

							friendly_projectiles.at (j).set_col (99)
							friendly_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := friendly_projectiles.count + 1

							if is_in_bounds (enemies.at (enemies.count).row_pos , enemies.at (enemies.count).col_pos) then

								-- Add to debug Output
								if not game_info.in_normal_mode then
									game_info.append_natural_enemy_spawn_info ("      The " + enemies.at (enemies.count).name + " at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "] has been destroyed.")
								end

								enemies.at (enemies.count).discharge_after_death
							end
							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collisions with Enemy Projectiles
					from
						j := 1
					until
						j > enemy_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = enemy_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = enemy_projectiles.at (j).col_pos then
							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health + enemy_projectiles.at (j).damage)

							if enemies.at (enemies.count).curr_health > enemies.at (enemies.count).health then
								enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).health)
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (enemy_projectiles.at (j).row_pos, enemy_projectiles.at (j).col_pos) then
								game_info.append_natural_enemy_spawn_info ("      The " + enemies.at (enemies.count).name + " collides with enemy projectile(id:" + enemy_projectiles.at (j).id.out + ") at location [" + grid_char_rows.at (enemy_projectiles.at (j).row_pos).out + "," + enemy_projectiles.at (j).col_pos.out + "], healing " + enemy_projectiles.at (j).damage.out + " damage.")
							end

							enemy_projectiles.at (j).set_col (99)
							enemy_projectiles.at (j).set_row (99)
						end

						j := j + 1
					end


					-- Collision with the Starfighter
					if enemies.at (enemies.count).row_pos = game_info.starfighter.row_pos and enemies.at (enemies.count).col_pos = game_info.starfighter.col_pos then
							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - enemies.at (enemies.count).curr_health)

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
								game_info.append_natural_enemy_spawn_info ("      The " + enemies.at (enemies.count).name + " collides with Starfighter(id:0) at location [" + grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + enemies.at (enemies.count).curr_health.out + " damage.")
							end

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							-- Add to debug Output
							if not game_info.in_normal_mode then
								game_info.append_natural_enemy_spawn_info ("      The " + enemies.at (enemies.count).name + " at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "] has been destroyed.")
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
								game_info.append_natural_enemy_spawn_info ("      The Starfighter at location [" + grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed.")
							end

							if is_in_bounds (enemies.at (enemies.count).row_pos , enemies.at (enemies.count).col_pos) then
								enemies.at (enemies.count).discharge_after_death
							end
							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
					end

				end
			end
		end

	spawn_interceptor (row : INTEGER ; column : INTEGER)
		require
			is_alive : game_info.is_alive = true
		local
			i , j, damage_with_armour: INTEGER
			do_spawn : BOOLEAN
		do
			do_spawn := true
			from
				i := 1
			until
				i > enemies.count
			loop
				if enemies.at (i).row_pos = row and enemies.at (i).col_pos = column then
					do_spawn := false
				end
				i := i + 1
			end

			if do_spawn = true then
				increment_enemy_id_counter
				enemies.force (create {INTERCEPTOR}.make (row, column, enemy_id_counter))
				enemies.at (enemies.count).set_is_turn_over (true)

				-- Add to debug Output
				if not game_info.in_normal_mode then
					if is_in_bounds (enemies.at (enemies.count).row_pos , enemies.at (enemies.count).col_pos) then
						game_info.append_enemy_action_info ("      A " + enemies.at (enemies.count).name + "(id:" + enemies.at (enemies.count).id.out + ") spawns at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "]." + "%N")
					else
						game_info.append_enemy_action_info ("      A " + enemies.at (enemies.count).name + "(id:" + enemies.at (enemies.count).id.out + ") spawns at location out of board." + "%N")
					end
				end

				if is_in_bounds (row, column) then

					-- Update seen
					enemies.at (enemies.count).update_can_see_starfighter
					enemies.at (enemies.count).update_seen_by_starfighter

					-- Collisions with Friendly Projectiles
					from
						j := 1
					until
						j > friendly_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = friendly_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = friendly_projectiles.at (j).col_pos then
							damage_with_armour := friendly_projectiles.at (j).damage - enemies.at (enemies.count).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health - damage_with_armour)

							if enemies.at (enemies.count).curr_health < 0 then
								enemies.at (enemies.count).set_curr_health (0)
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (friendly_projectiles.at (j).row_pos, friendly_projectiles.at (j).col_pos) then
								game_info.append_enemy_action_info ("      The " + enemies.at (enemies.count).name + " collides with friendly projectile(id:" +  friendly_projectiles.at (j).id.out + ") at location [" + grid_char_rows.at (friendly_projectiles.at (j).row_pos).out + "," + friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
							end

							friendly_projectiles.at (j).set_col (99)
							friendly_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := friendly_projectiles.count + 1

							if is_in_bounds (enemies.at (enemies.count).row_pos , enemies.at (enemies.count).col_pos) then
								-- Add to debug Output
								if not game_info.in_normal_mode and is_in_bounds (enemies.at (enemies.count).row_pos, enemies.at (enemies.count).col_pos) then
									game_info.append_enemy_action_info ("      The " + enemies.at (enemies.count).name + " at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "] has been destroyed." + "%N")
								end

								enemies.at (enemies.count).discharge_after_death
							end
							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collisions with Enemy Projectiles
					from
						j := 1
					until
						j > enemy_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = enemy_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = enemy_projectiles.at (j).col_pos then
							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health + enemy_projectiles.at (j).damage)

							if enemies.at (enemies.count).curr_health > enemies.at (enemies.count).health then
								enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).health)
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (enemy_projectiles.at (j).row_pos, enemy_projectiles.at (j).col_pos) then
								game_info.append_enemy_action_info ("      The " + enemies.at (enemies.count).name + " collides with enemy projectile(id:" + enemy_projectiles.at (j).id.out + ") at location [" + grid_char_rows.at (enemy_projectiles.at (j).row_pos).out + "," + enemy_projectiles.at (j).col_pos.out + "], healing " + enemy_projectiles.at (j).damage.out + " damage." + "%N")
							end

							enemy_projectiles.at (j).set_col (99)
							enemy_projectiles.at (j).set_row (99)
						end

						j := j + 1
					end


					-- Collision with the Starfighter
					if enemies.at (enemies.count).row_pos = game_info.starfighter.row_pos and enemies.at (enemies.count).col_pos = game_info.starfighter.col_pos then
							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - enemies.at (enemies.count).curr_health)

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (game_info.starfighter.row_pos , game_info.starfighter.col_pos) then
								game_info.append_enemy_action_info ("      The " + enemies.at (enemies.count).name + " collides with Starfighter(id:0) at location [" + grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + enemies.at (enemies.count).curr_health.out + " damage." + "%N")
							end

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (enemies.at (enemies.count).row_pos, enemies.at (enemies.count).col_pos) then
								game_info.append_enemy_action_info ("      The " + enemies.at (enemies.count).name + " at location [" + grid_char_rows.at (enemies.at (enemies.count).row_pos).out + "," + enemies.at (enemies.count).col_pos.out + "] has been destroyed." + "%N")
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and is_in_bounds (game_info.starfighter.row_pos , game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
								game_info.append_enemy_action_info ("      The Starfighter at location [" + grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
							end

							if is_in_bounds (enemies.at (enemies.count).row_pos , enemies.at (enemies.count).col_pos) then
								enemies.at (enemies.count).discharge_after_death
							end
							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
					end
				end

			end
		end

	enemy_preemptive_action (type : CHARACTER)
		require
			is_alive : game_info.is_alive = true
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > enemies.count
			loop
				if is_in_bounds (enemies.at (i).row_pos , enemies.at (i).col_pos) then
					enemies.at (i).preemptive_action (type)
				end

				if game_info.starfighter.curr_health = 0 then
					i := enemies.count + 1
				end

				i := i + 1
			end
		end

	enemy_action
		require
			is_alive : game_info.is_alive = true
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > enemies.count
			loop
				if enemies.at (i).can_see_starfighter then
					if is_in_bounds (enemies.at (i).row_pos , enemies.at (i).col_pos) then
						enemies.at (i).action_when_starfighter_is_seen
					end
				else
					if is_in_bounds (enemies.at (i).row_pos , enemies.at (i).col_pos) then
						enemies.at (i).action_when_starfighter_is_not_seen
					end
				end

				if game_info.starfighter.curr_health = 0 then
					i := enemies.count + 1
				end

				i := i + 1
			end
		end

	clear_all
		-- Clear all out of bound items
		local
			i : INTEGER
			new_friendly_projectiles : LIST[FRIENDLY_PROJECTILE]
			new_enemy_projectiles : LIST[ENEMY_PROJECTILE]
			new_enemies : LIST[ENEMY]
		do
			create {ARRAYED_LIST[FRIENDLY_PROJECTILE]} new_friendly_projectiles.make (1)
			create {ARRAYED_LIST[ENEMY_PROJECTILE]} new_enemy_projectiles.make (1)
			create {ARRAYED_LIST[ENEMY]} new_enemies.make (1)

			from
				i := 1
			until
				i > friendly_projectiles.count
			loop
				if is_in_bounds (friendly_projectiles.at (i).row_pos , friendly_projectiles.at (i).col_pos) then
					new_friendly_projectiles.force (friendly_projectiles.at (i))
				end
				i := i + 1
			end

			from
				i := 1
			until
				i > enemy_projectiles.count
			loop
				if is_in_bounds (enemy_projectiles.at (i).row_pos , enemy_projectiles.at (i).col_pos) then
					new_enemy_projectiles.force (enemy_projectiles.at (i))
				end
				i := i + 1
			end

			from
				i := 1
			until
				i > enemies.count
			loop
				if is_in_bounds (enemies.at (i).row_pos , enemies.at (i).col_pos) then
					new_enemies.force (enemies.at (i))
				end
				i := i + 1
			end

			friendly_projectiles := new_friendly_projectiles
			enemy_projectiles := new_enemy_projectiles
			enemies := new_enemies
		end

feature -- Debug Mode Output

	add_enemy_info
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > enemies.count
			loop
				game_info.append_enemy_info ("    [" + enemies.at (i).id.out + "," + enemies.at (i).symbol.out + "]->health:" + enemies.at (i).curr_health.out + "/" + enemies.at (i).health.out + ", Regen:" + enemies.at (i).health_regen.out + ", Armour:" + enemies.at (i).armour.out + ", Vision:" + enemies.at (i).vision.out + ", seen_by_Starfighter:" + enemies.at (i).seen_by_starfighter_output + ", can_see_Starfighter:" + enemies.at (i).can_see_starfighter_output + ", location:[" + grid_char_rows.at (enemies.at (i).row_pos).out + "," + enemies.at (i).col_pos.out + "]")
				i := i + 1
			end
		end

	add_projectiles_info
		local
			i , j , k : INTEGER
		do
			j := 1
			k := 1

			from
				i := -1
			until
				i < projectile_id_counter
			loop
				if friendly_projectiles.valid_index (j) and friendly_projectiles.at (j).id = i then
					game_info.append_projectile_info ("    [" + friendly_projectiles.at (j).id.out + ",*]->damage:" + friendly_projectiles.at (j).damage.out + ", move:" + friendly_projectiles.at (j).move.out + ", location:[" + grid_char_rows.at (friendly_projectiles.at (j).row_pos).out + "," + friendly_projectiles.at (j).col_pos.out + "]")
					j := j + 1
				end

				if enemy_projectiles.valid_index (k) and enemy_projectiles.at (k).id = i then
					game_info.append_projectile_info ("    [" + enemy_projectiles.at (k).id.out + ",<]->damage:" + enemy_projectiles.at (k).damage.out + ", move:" + enemy_projectiles.at (k).move.out + ", location:[" + grid_char_rows.at (enemy_projectiles.at (k).row_pos).out + "," + enemy_projectiles.at (k).col_pos.out + "]")
					k := k + 1
				end
				i := i - 1
			end
		end

end
