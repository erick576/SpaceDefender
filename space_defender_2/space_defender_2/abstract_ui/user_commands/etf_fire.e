note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_game then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_1)
			elseif model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > (model.starfighter.curr_health + model.starfighter.health_regen) then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			elseif not model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > (model.starfighter.curr_energy + model.starfighter.energy_regen) then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			else
				-- Clear all Debug Messages
				model.game_info.set_enemy_info ("")
				model.game_info.set_projectile_info ("")
				model.game_info.set_friendly_projectile_action_info ("")
				model.game_info.set_enemy_projectile_action_info ("")
				model.game_info.set_starfighter_action_info ("")
				model.game_info.set_enemy_action_info ("")
				model.game_info.set_natural_enemy_spawn_info ("")

				-- Reset Error Count and Increment Valid Operation Count
				model.game_info.set_error_count (0)
				model.game_info.set_valid_operation_count (model.game_info.valid_operation_count + 1)

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (false)

				-- Perform Fire

			-- Phase 1
				if model.game_info.is_alive = true then
					model.grid.friendly_projectile_movements
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 2
				if model.game_info.is_alive = true then
					model.grid.enemy_projectile_movements
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 3
				if model.game_info.is_alive = true then
					model.starfighter.regenerate
					model.starfighter.use_fire
					model.grid.fire
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 4
				if model.game_info.is_alive = true then
					model.grid.update_enemy_vision
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 5
				if model.game_info.is_alive = true then
					model.grid.enemy_preemptive_action ('F')
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

				if model.game_info.is_alive = true then
					model.grid.enemy_action
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 6
				if model.game_info.is_alive = true then
					model.grid.update_enemy_vision
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 7
				if model.game_info.is_alive = true then
					model.grid.enemy_spawn
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end


				-- Update Score
				model.starfighter.update_score
				model.grid.clear_all

				-- Add Enemy Info to debug mode output
				if not model.game_info.in_normal_mode then
					model.grid.add_enemy_info
					model.grid.add_projectiles_info
				end

				-- Check if Died , If so then exit game
				if model.game_info.is_alive = false then
					-- Transition into Not Started State
					model.app.current_state.set_choice (4)
					model.app.execute_transition
				end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
