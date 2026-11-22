@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var email_edit: LineEdit
@export var done: Button
@export var step_1_contents: VBoxContainer
@export var step_2: Node
@export var hint: Label

func _enter_tree() -> void:
	Utils.SafeConnect(done.pressed, _on_done_pressed)

#region Listeners
func _on_done_pressed() -> void:
	done.disabled = true
	var email : String = email_edit.text
	Supabase.RequestFindEmail(email, 
		func(data : Dictionary):
			Log.pr("Complete", data)
			if (data.has("error")):
				_ShowError(data["error"])
			else:
				Log.succ("Email found!")
				NextStep(email)
			done.disabled = false
			)
	pass
#endregion

#region Local
func InitStep() -> void:
	email_edit.text = ""
	step_1_contents.visible = true
	pass
func NextStep(email : String) -> void:
	step_2.InitStep(email)
	step_1_contents.visible = false
#endregion

#region Utils
func _ShowError(text : String) -> void:
	hint.text = text
	await get_tree().create_timer(2).timeout
	hint.text = ""
#endregion
