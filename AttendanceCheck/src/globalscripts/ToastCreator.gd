@icon("res://addons/at-icons/node/speech_bubble_exclamation.svg")
extends CanvasLayer

var _container: VBoxContainer

func show_toast(message: String, long_duration: bool = false) -> void:
	if not OS.get_name() == "Android":
		print("Toast (non-Android): ", message)
		return

	var Toast = JavaClassWrapper.wrap("android.widget.Toast")
	var Activity = JavaClassWrapper.wrap("org.godotengine.godot.Godot")

	# Get the current activity instance
	var activity = Engine.get_singleton("GodotLib").get_activity() if Engine.has_singleton("GodotLib") else null

	# More reliable: use OS.get_main_window() isn't a thing — use this instead:
	var context = _get_activity()
	if context == null:
		push_error("Could not get Android activity context")
		return

	var duration = Toast.LENGTH_LONG if long_duration else Toast.LENGTH_SHORT
	var toast = Toast.makeText(context, message, duration)
	toast.show()


func _get_activity() -> JavaObject:
	# Godot exposes the current activity via the special "GodotApp" singleton in 4.x
	if Engine.has_singleton("GodotApp"):
		return Engine.get_singleton("GodotApp")
	return null
