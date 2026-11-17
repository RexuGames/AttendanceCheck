@icon("res://addons/at-icons/node/speech_bubble_exclamation.svg")
extends CanvasLayer

var _container: VBoxContainer

func _ready() -> void:
	layer = 100
	_container = VBoxContainer.new()
	_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	_container.alignment = BoxContainer.ALIGNMENT_END
	_container.add_theme_constant_override("separation", 8)
	_container.position.y -= 80
	add_child(_container)

func ShowToast(message: String, icon: Texture2D = null, duration: float = 2.0) -> void:
	var panel := PanelContainer.new()
	panel.modulate.a = 0.0

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.9)
	style.set_corner_radius_all(12)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	panel.add_child(hbox)

	if icon:
		var texture_rect := TextureRect.new()
		texture_rect.texture = icon
		texture_rect.custom_minimum_size = Vector2(24, 24)
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hbox.add_child(texture_rect)

	var label := Label.new()
	label.text = message
	label.add_theme_color_override("font_color", Color.WHITE)
	hbox.add_child(label)

	_container.add_child(panel)

	var tween := create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	tween.tween_interval(duration)
	tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	tween.tween_callback(panel.queue_free)
