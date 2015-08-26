require "defines"

require "gui"

--[[ Made by Mingwei "Hazzard" Samuel ]]--
--[[ Inspiration from BiG_MEECH ]]--
-- GPLv2 --

game.on_event(defines.events.on_tick, function(event)
  for i,player in ipairs(game.players) do
    setGuiButtonVisible(player, player.get_item_count("gravestone-controller") > 0)
  end
end)

game.on_event(defines.events.on_gui_click, function(event)
  local player = game.players[event.player_index]

  --show (or hide ?) settings gui
  if event.element.name == "gravestone-button-main" or
      event.element.name == "gravestone-button-close" then
    toggleGui(player)
  end

  if event.element.name == "gravestone-settings-percentage-retained-dec-lg" then
    changePercentageRetained(player, -0.1)
  elseif event.element.name == "gravestone-settings-percentage-retained-dec-sm" then
    changePercentageRetained(player, -0.01)
  elseif event.element.name == "gravestone-settings-percentage-retained-inc-sm" then
    changePercentageRetained(player, 0.01)
  elseif event.element.name == "gravestone-settings-percentage-retained-inc-lg" then
    changePercentageRetained(player, 0.1)
  end
end)

game.on_event(defines.events.on_entity_died, function(event)
  local entity = event.entity
  if entity.type ~= "player" then return end

  local pos = entity.surface.find_non_colliding_position(
    "gravestone", entity.position, 8, 1)
  if not pos then return end

  local grave = entity.surface.create_entity{
    name="gravestone", position=pos, force=entity.force}
  local grave_inv = grave.get_inventory(defines.inventory.chest)

  local count = 0
  for i, id in ipairs{
      defines.inventory.player_guns,
      defines.inventory.player_tools,
      defines.inventory.player_ammo,
      defines.inventory.player_armor,
      defines.inventory.player_quickbar,
      defines.inventory.player_main,
      defines.inventory.player_trash} do
    local inv = entity.get_inventory(id)
    for j = 1, #inv do
      if inv[j].valid_for_read then
        count = count + 1
        if count > #grave_inv then return end
        grave_inv[count].set_stack(inv[j])
      end
    end
  end
end)