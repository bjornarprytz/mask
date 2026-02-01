@tool
extends ProgrammaticTheme
const UPDATE_ON_SAVE = true

func setup():
	set_save_path("res://generated/global_theme.tres")



var button_color = Color("9b5de5")
var main_button_color = Color("fad752")
var button_border_color = Color.BLACK
var default_border_width = 4 
var default_corner_radius = 5
var default_font_size = 48
var title_font_size = 64
var panel_texture = preload("res://assets/panel-texture.png")

var default_font = preload("res://assets/fonts/Pixelify_Sans/static/PixelifySans-Regular.ttf")
var title_font = preload("res://assets/fonts/it-gridbit-demo/ITGridbitDemo-Regular.otf")
var default_content_margins = content_margins(24, 15)

func define_theme():
	define_default_font(default_font)
	define_default_font_size(default_font_size)
		
	var button_style = stylebox_flat({
		bg_color = button_color,

		border_color = button_border_color,

		content_margin_ = default_content_margins,
		border_ = border_width(default_border_width),
		corner_ = corner_radius(default_corner_radius)
	})
	
	var main_button_style = inherit(button_style, {
		bg_color = main_button_color,
	})
	
	var main_button_hover_style = inherit(main_button_style, {
		bg_color = main_button_color.darkened(.1)
	})

	var main_button_pressed_style = inherit(main_button_style, {
		bg_color = main_button_color.darkened(.85)
	})

	var button_hover_style = inherit(button_style, {
		bg_color = button_color.darkened(.1)
	})

	var button_pressed_style = inherit(button_style, {
		bg_color = button_color.darkened(.85)
	})
	
	define_style("PanelContainer", {
		panel = stylebox_texture({
			texture = panel_texture,
			texture_margin_ = texture_margins(9),
			content_margin_ = default_content_margins,
			axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT,
			axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
			
		})
	})
	
	define_variant_style("Title", "RichTextLabel", {
		normal_font_size = title_font_size,
		normal_font = title_font
	})

	define_style("Button", {
		normal = button_style,
		hover = button_hover_style,
		pressed = button_pressed_style,
	})
	
	define_variant_style("MainButton", "Button", {
		normal = main_button_style,
		font_color = Color.BLACK,
		hover = main_button_hover_style,
		pressed = main_button_pressed_style
	})
