extends MarginContainer

func _ready() -> void:
	if (OS.get_name() == "Android"):
		apply_safe_area()
		get_tree().get_root().size_changed.connect(apply_safe_area)

func apply_safe_area() -> void:
	var safe_area = DisplayServer.get_display_safe_area()
	var screen_size_physical = DisplayServer.screen_get_size()

	# Get the actual scale factor Godot is using to map window px -> viewport/canvas units
	var viewport = get_tree().get_root()
	var canvas_scale = viewport.get_final_transform().get_scale()

	var top_margin = safe_area.position.y / canvas_scale.y
	var bottom_margin = (screen_size_physical.y - (safe_area.position.y + safe_area.size.y)) / canvas_scale.y
	var left_margin = safe_area.position.x / canvas_scale.x
	var right_margin = (screen_size_physical.x - (safe_area.position.x + safe_area.size.x)) / canvas_scale.x

	add_theme_constant_override("margin_top", int(top_margin))
	add_theme_constant_override("margin_bottom", int(bottom_margin))
