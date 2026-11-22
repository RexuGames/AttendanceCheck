@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var forgot_password: Button

func _enter_tree() -> void:
	Utils.SafeConnect(forgot_password.pressed, _on_forgotpassword_pressed)

#region Listeners
func _on_forgotpassword_pressed() -> void:
	Widgets.CreateResetPassword()
	pass
#endregion
