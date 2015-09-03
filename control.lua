require "defines"

require "gui"

--[[ Made by Mingwei "Hazzard" Samuel ]]--
--[[    Inspiration from BiG_MEECH    ]]--
-- GPLv2 --

local int32_max = 2147483647
local debug = true

function serialize(val, depth)
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    local ty = type(val)

    if ty == "table" then
        tmp = tmp .. "{" .. "\n"

        for k, v in pairs(val) do
            tmp = tmp .. string.format("%q", k) .. " : " .. serialize(v, depth + 1) .. "," .. "\n"
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif ty == "number" then
        tmp = tmp .. tostring(val)
    elseif ty == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif ty == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[?:" .. type(val) .. "]\""
    end

    return tmp
end

function log(string, force)
  if not debug and not force then return end
  --for i, player in ipairs(game.players) do
  --  player.print(string)
  --end
  local player = game.get_player("Lugnuts")
  player.print(string)
end

--[[ real stuff below ]]--

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

  function shrinkStack(count)
    local newCount = 0
    for j=1,count do
      newCount = newCount + (math.random() < global.settings.percentageRetained and 1 or 0)
    end
    return newCount
  end
  
  local transfer_stack --function to deal with stacks, based on mode
  if global.settings.mode == 1 then --[[ CHEST/GRAVESTONE ]]--
    local pos = player.surface.find_non_colliding_position(
      "gravestone", player.position, int32_max, 1) --should always spawn
    if not pos then -- gg no re
      log("Unable to spawn gravestone within " .. int32_max .. " tiles.", true)
      return
    end
    
    local grave = player.surface.create_entity{
      name = "gravestone", position = pos, force = player.force }
    log("Spawned gravestone at (" .. pos.x .. ", " .. pos.y .. ")")

    transfer_stack = (function(inv)
      local i = 1
      return (function(stack)
        log("Grave: processing \"" .. stack.name .. "\"x" .. stack.count)
        if not global.settings.saveInventories or not stack.has_grid then
          log("Shrinking stack")
          stack.count = shrinkStack(stack.count)
        end
        if i > #inv or not stack.valid_for_read then
          log("Stack shrunk to zero, or gravestone full")
          return
        end
        log("Setting slot " .. i .. " to \"" .. stack.name .. "\"x" .. stack.count .. " and incrementing")
        inv[i].set_stack(stack)
        i = i + 1
      end)
    end)(grave.get_inventory(defines.inventory.chest))

  else --[[ DROP ON GROUND ]]--
    function drop_items(stack, surface, pos)
      if not pcall(function() -- version >= 12.6
        surface.spill_item_stack(stack, pos)
      end) then -- version < 12.6

      end
    end
    transfer_stack = (function(stack)
      log("Drop: processing \"" .. stack.name .. "\"x" .. stack.count)
      log("Drop")

      if stack.has_grid then --will also work with SimpleItemStacks (has_grid == nil)
        log("Stack is modular {")

        --[[ in version 0.12.6+, spill_item_stack works with ItemStacks, not just SimpleItemStacks ]]--
        
        --local equipments = stack.grid.take_all()
        --for name, count in pairs(equipments) do
        --  log("Equipment: \"" .. name .. "\"x" .. count)
        --  player.surface.spill_item_stack({ name = name, count = count }, player.position) --always spawn equipment
        --end

        if global.settings.saveInventories then
          log("} Not shrinking stack")
          player.surface.spill_item_stack(stack, player.position)
          return
        end
        
        log("}")
      end

      log("test")

      stack.count = shrinkStack(stack.count)
      if not stack.valid_for_read then
        log("Stack shrunk to 0 (removed)")
        return
      end
      log("Stack shrunk to " .. stack.count)
      player.surface.spill_item_stack(stack, player.position)
    end)
  end

  if player.cursor_stack ~= nil and player.cursor_stack.valid_for_read then
    transfer_stack(player.cursor_stack)
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
        transfer_stack(inv[j])
      end
    end
  end
end)
