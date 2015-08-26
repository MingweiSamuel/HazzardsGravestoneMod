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
        style = "gs_button_sm",
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
        caption = { "gravestone-settings-mode-chest" }
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
        caption = { "gravestone-percentage-retained" }
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentage-retained-dec-lg",
        style = "gs_button_sm",
        caption = "<<"
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentage-retained-dec-sm",
        style = "gs_button_sm",
        caption = "<"
      })
      percentageRetainedFlow.add({
        type = "progressbar",
        name = "gravestone-settings-percentage-retained", 
        style = "gs_settings_progressbar",
        caption = "69%",
        size = 100
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentage-retained-inc-sm",
        style = "gs_button_sm",
        caption = ">"
      })
      percentageRetainedFlow.add({
        type = "button",
        name = "gravestone-settings-percentage-retained-inc-lg",
        style = "gs_button_sm",
        caption = ">>"
      })
      percentageRetainedFlow.add({
        type = "label",
        name = "gravestone-settings-percentage-retained-value"
      })
    end

    gravestoneFrame.style = "gs_frame"
  end
end

function changePercentageRetained(player, delta)
  local value = player.gui.center.gravestoneFrame.percentageRetainedFlow["gravestone-settings-percentage-retained"].value + delta
  setPercentageRetained(player, value)
end

function setPercentageRetained(player, value)
  value = math.floor(value * 100 + 0.5) / 100
  value = math.min(1, math.max(0, value))
  player.gui.center.gravestoneFrame.percentageRetainedFlow["gravestone-settings-percentage-retained"].value = value
  player.gui.center.gravestoneFrame.percentageRetainedFlow["gravestone-settings-percentage-retained-value"].caption = math.floor(value * 100) .. "%"
end