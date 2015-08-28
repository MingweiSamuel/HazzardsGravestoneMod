require "defines"

require "gui"

--[[ Made by Mingwei "Hazzard" Samuel ]]--
--[[    Inspiration from BiG_MEECH    ]]--
-- GPLv2 --

game.on_init(function() init() end)
game.on_load(function() init() end)

function init()
  local effectiveVersion = 2 -- force rebuild the gui in updates
  if global.version ~= effectiveVersion then
    global.version = effectiveVersion
    for i,player in ipairs(game.players) do
      destroyGui(player)
    end
  end


  global.settings = global.settings or {}
  global.settings.mode = global.settings.mode or 1 -- 1=chest, 2=drop
  if global.settings.percentageRetained == nil then global.settings.percentageRetained = 1 end
  if global.settings.saveInventories == nil then global.settings.saveInventories = true end
end

game.on_event(defines.events.on_tick, function(event)
  for i,player in ipairs(game.players) do
    updateGui(player)
    setGuiButtonVisible(player, player.get_item_count("gravestone-controller") > 0)
  end
end)

game.on_event(defines.events.on_gui_click, function(event)
  local player = game.players[event.player_index]

  --parse path
  local i = 1
  local path = {}
  for v in string.gmatch(event.element.name, "[^%-]+") do
    path[i] = v
    i = i + 1
  end

  if path[1] == "gravestone" then
    if path[2] == "button" then
      if path[3] == "main" or path[3] == "close" then
        toggleGui(player)
      end
    elseif path[2] == "settings" then
      if path[3] == "percentageretained" then
        local delta = 0.1
        if path[4] == "dec" then
          delta = delta * -1
        end
        if path[5] == "sm" then
          delta = delta / 10
        end
        global.settings.percentageRetained = global.settings.percentageRetained + delta
      elseif path[3] == "mode" then
        global.settings.mode = 3 - global.settings.mode -- 1 -> 2, 2 -> 1
      elseif path[3] == "saveinventories" then
        global.settings.saveInventories = not global.settings.saveInventories
      end
    end
  end
end)

game.on_event(defines.events.on_entity_died, function(event)
  local player = event.entity
  if player.type ~= "player" then return end
  
  local transfer_stack --function to deal with stacks, based on mode
  if global.settings.mode == 1 then -- chest
    local pos = player.surface.find_non_colliding_position(
      "gravestone", player.position, 8, 1)
    if not pos then return end -- shouldn't happen
    
    local grave = player.surface.create_entity{
      name="gravestone", position=pos, force=player.force}

    transfer_stack = (function(inv)
      return (function(stack, i)
        if i > #inv then return end
        inv[i].set_stack(stack)
      end)
    end)(grave.get_inventory(defines.inventory.chest))
  else -- ground
    transfer_stack = (function(stack, i)
      player.surface.spill_item_stack(stack, player.position) --will this work with ItemStack's instead of SimpleItemStack's?
    end)
  end

  local count = 0
  if player.cursor_stack ~= nil and player.cursor_stack.valid_for_read then
    count = count + 1
    transfer_stack(player.cursor_stack, count)
  end
  for i, id in ipairs{
      defines.inventory.player_guns,
      defines.inventory.player_tools,
      defines.inventory.player_ammo,
      defines.inventory.player_armor,
      defines.inventory.player_quickbar,
      defines.inventory.player_main,
      defines.inventory.player_trash} do
    local inv = player.get_inventory(id)
    for j = 1, #inv do
      if inv[j].valid_for_read then
        count = count + 1
        transfer_stack(inv[j], count)
      end
    end
  end
end)
