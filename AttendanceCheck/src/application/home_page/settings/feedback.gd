extends Node

@export_group("References")
@export var feeback: Button

func _enter_tree() -> void:
	Utils.SafeConnect(feeback.pressed, _on_feedback_pressed)

#region Listeners
func _on_feedback_pressed() -> void:
	Widgets.CreateConfirmation("This will take you to google forms.",
	func(yes : bool) -> void:
		OS.shell_open("https://forms.gle/73CakR7Y9E8z7kTDA")
		)
	pass
#endregion
