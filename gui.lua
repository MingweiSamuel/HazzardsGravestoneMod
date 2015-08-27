function setGuiButtonVisible(player, visible)
  local guiButton = player.gui.top["gravestone-button-main"]
  if visible then
    if guiButton == nil then
      player.gui.top.add({
        type = "button",
        name = "gravestone-button-main",
        style = "gs_main"
      })
    end
  else
    if guiButton ~= nil then
      guiButton.destroy()
    end
  end
end

function guiVisible(player)
  local gravestoneFrame = player.gui.center.gravestoneFrame
  if gravestoneFrame == nil then
    return false
  end
  return gravestoneFrame.style.name == "gs_frame"
end

function toggleGui(player)
  if guiVisible(player) then
    player.gui.center.gravestoneFrame.style = "gs_frame_hidden"
  else
    local gravestoneFrame = player.gui.center.gravestoneFrame

    --create gui if it doesn't exist
    if gravestoneFrame == nil then
      gravestoneFrame = player.gui.center.add({
        type = "frame",
        name = "gravestoneFrame",
        direction = "vertical",
        style = "gs_frame"
      })

      local headerFlow = gravestoneFrame.add({
        type = "flow",
        name = "headerFlow",
        direction = "horizontal"
      })
      headerFlow.add({
        type = "label",
        name = "headerLabel",
        style = "gs_header_label",
        caption = { "gravestone-settings" }
      })
      headerFlow.add({
        type = "button",
        name = "gravestone-button-close",
        style = "gs_button_icon",
        caption = "X"
      })

      local modeFlow = gravestoneFrame.add({
        type = "flow",
        name = "modeFlow",
        direction = "horizontal"
      })
      modeFlow.add({
        type = "label",
        name = "modeLabel",
        style = "gs_settings_label",
        caption = { "gravestone-settings-mode" }
      })
      modeFlow.add({
        type = "button",
        name = "gravestone-settings-mode",
        style = "gs_button",
        caption = "..."
      })

      local percentageRetainedFlow = gravestoneFrame.add({
        type = "flow",
        name = "percentageRetainedFlow",
        direction = "horizontal"
      })
      percentageRetainedFlow.add({
        type = "label",
        name = "percentageRetainedLabel",
        style = "gs_settings_label",
        caption = { "gravestone-settings-percentageretained" }
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentageretained-dec-lg",
        style = "gs_button_icon",
        caption = "<<"
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentageretained-dec-sm",
        style = "gs_button_icon",
        caption = "<"
      })
      percentageRetainedFlow.add({
        type = "progressbar",
        name = "gravestone-settings-percentageretained", 
        style = "gs_settings_progressbar",
        caption = "69%",
        size = 100
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentageretained-inc-sm",
        style = "gs_button_icon",
        caption = ">"
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentageretained-inc-lg",
        style = "gs_button_icon",
        caption = ">>"
      })
      percentageRetainedFlow.add({
        type = "label",
        name = "gravestone-settings-percentageretained-value"
      })

      local saveInventoriesFlow = gravestoneFrame.add({
        type = "flow",
        name = "saveInventoriesFlow",
        direction = "horizontal"
      })
      saveInventoriesFlow.add({
        type = "label",
        name = "saveInventoriesLabel",
        style = "gs_settings_label",
        caption = { "gravestone-settings-saveinventories" }
      })
      saveInventoriesFlow.add({
        type = "button",
        name = "gravestone-settings-saveinventories",
        style = "gs_button",
        caption = "..."
      })
    end

    gravestoneFrame.style = "gs_frame"
  end
end

function destroyGui(player)
  if player.gui.center.gravestoneFrame ~= nil then
    player.gui.center.gravestoneFrame.destroy()
  end
end

function updateGui(player)
  if not guiVisible(player) then return end

  local modeCaption = { "gravestone-settings-mode-" .. ({ "chest", "drop" })[global.settings.mode]}
  player.gui.center.gravestoneFrame.modeFlow["gravestone-settings-mode"].caption = modeCaption

  local percentageRetained = global.settings.percentageRetained
  percentageRetained = math.floor(percentageRetained * 100 + 0.5) / 100
  percentageRetained = math.min(1, math.max(0, percentageRetained))
  player.gui.center.gravestoneFrame.percentageRetainedFlow["gravestone-settings-percentageretained"].value = percentageRetained
  player.gui.center.gravestoneFrame.percentageRetainedFlow["gravestone-settings-percentageretained-value"].caption = math.floor(percentageRetained * 100) .. "%"

  local saveInventoriesCaption = { "gravestone-settings-saveinventories-" .. (global.settings.saveInventories and "yes" or "no")}
  player.gui.center.gravestoneFrame.saveInventoriesFlow["gravestone-settings-saveinventories"].caption = saveInventoriesCaption
end