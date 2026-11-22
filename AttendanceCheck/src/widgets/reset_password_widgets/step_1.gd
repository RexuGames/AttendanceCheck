@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var email_edit: LineEdit
@export var done: Button
@export var step_1: VBoxContainer
@export var step_2: VBoxContainer
@export var hint: Label

func _enter_tree() -> void:
	Utils.SafeConnect(done.pressed, _on_done_pressed)

#region Listeners
func _on_done_pressed() -> void:
	var email : String = email_edit.text
	Supabase.RequestFindEmail(email, 
		func(data : Dictionary):
			Log.pr("Complete", data)
			if (data.has("error")):
				_ShowError(data["error"])
			else:
				Log.succ("Email found!")
				MoveToNextStep()
			)
	pass
#endregion

#region Local
func MoveToNextStep() -> void:
	step_1.visible = false
	step_2.visible = true
#endregion

#region Utils
func _ShowError(text : String) -> void:
	hint.text = text
	await get_tree().create_timer(2).timeout
	hint.text = ""
#endregion
