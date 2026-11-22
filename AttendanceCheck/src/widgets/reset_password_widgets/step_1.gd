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
	var email : String = email_edit.text
	
	if (not IsInputValid(email)): return
	done.disabled = true
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
func IsInputValid(email : String) -> bool:
	if email.strip_edges().is_empty():
		_ShowError("Please enter an email!")
		return false

	if not email.to_lower().ends_with("@gmail.com"):
		_ShowError("Invalid email address!")
		return false

	if email.strip_edges().length() <= "@gmail.com".length():
		_ShowError("Please enter a valid email address!")
		return false

	if email.contains(" "):
		_ShowError("Email address cannot contain spaces!")
		return false

	return true
func InitStep() -> void:
	step_1_contents.visible = true
	pass
func NextStep(email : String) -> void:
	step_2.InitStep(email)
	step_1_contents.visible = false
#endregion

#region Utils
func _ShowError(text : String) -> void:
	hint.visible = true
	hint.text = text
	await get_tree().create_timer(5).timeout
	hint.visible = false
#endregion
