--Fonts
data:extend({
  {
    type = "font",
    name = "font-s",
    from = "default",
    size = 12
  },
  {
    type = "font",
    name = "font-m",
    from = "default",
    size = 14
  },
  {
    type = "font",
    name = "font-l",
    from = "default",
    size = 16
  },
  {
    type = "font",
    name = "font-sb",
    from = "default-semibold",
    size = 12
  },
  {
    type = "font",
    name = "font-mb",
    from = "default-semibold",
    size = 14
  },
  {
    type = "font",
    name = "font-lb",
    from = "default-semibold",
    size = 16
  }
})

--Gui styles
data.raw["gui-style"].default["gs_main"] =
{
    type = "button_style",
    parent = "button_style",
    width = 34,
    height = 34,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    hovered_font_color = { r = 0.1, g = 0.1, b = 0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["gs_frame"] =
{
    type = "frame_style",
    font = "font-m",
    minimal_width = 640,
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 10,
    left_padding = 2,
    scalable = false, 
}

data.raw["gui-style"].default["gs_frame_hidden"] =
{
    type = "frame_style",
    parent = "lv_frame",
    visible = false
}

data.raw["gui-style"].default["gs_header_label"] =
{
    type = "label_style",
    parent = "label_style",
    width = 630,
    align = "center",
    font = "font-lb"
}

data.raw["gui-style"].default["gs_button_sm"] =
{
    type = "button_style",
    parent = "button_style",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    width = 24,
    height = 24,
    font = "font-sb",
    align = "center",
    hovered_font_color = { r = 0.1, g = 0.1, b = 0.1 },
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = 0,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = 16,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__gravestone-mod__/graphics/gravestone-gui.png",
            width = 16,
            height = 16,
            x = 0,
            y = 32
        }
    }
}

data.raw["gui-style"].default["gs_settings_label"] =
{
    type = "label_style",
    parent = "label_style",
    width = 220,
    align = "right",
    font = "font-m"
}

data.raw["gui-style"].default["gs_settings_progressbar"] =
{
    type = "progressbar_style",
    parent = "progressbar_style",
    top_padding = 8
}