@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var step_3_contents: VBoxContainer
@export var password_edit: LineEdit
@export var confirm_password_edit: LineEdit
@export var done: Button
@export var hint: Label

var email : String = ""
var code : int = 0

func _enter_tree() -> void:
	Utils.SafeConnect(done.pressed, _on_done_pressed)

#region Listeners
func _on_done_pressed() -> void:
	var password : String = password_edit.text
	var confirm : String = confirm_password_edit.text
	if (not IsValidInputs(password, confirm)): return
	done.disabled = true
	Supabase.RequestChangePassword(email, password, 
		func(data : Dictionary):
			Log.pr(data)
			if (data.has("error")):
				_ShowHint(data["error"], Color.RED)
			else:
				Log.succ("Password Changed!")
				EventBus.page_pop_front_request.emit()
			done.disabled = false
			)
			
	pass
#endregion

#region Global
func InitStep(email : String) -> void:
	self.email = email
	Log.pr(email)
	step_3_contents.visible = true

#endregion

#region Local
func IsValidInputs(password: String, confirm: String) -> bool:
	# --- Password checks ---
	if password.is_empty():
		_ShowHint("Please enter a password!", Color.RED)
		return false

	if password.strip_edges().is_empty():
		_ShowHint("Password cannot be just spaces!", Color.RED)
		return false

	if password.length() < 5:
		_ShowHint("Password must be at least 5 characters!", Color.RED)
		return false

	if password.contains(" "):
		_ShowHint("Password cannot contain spaces!", Color.RED)
		return false

	# --- Confirm password checks ---
	if confirm.is_empty():
		_ShowHint("Please confirm your password!", Color.RED)
		return false

	if password != confirm:
		_ShowHint("Passwords do not match!", Color.RED)
		return false

	return true
#endregion

#region Utils
func _ShowHint(text : String, color : Color = Color.BLACK) -> void:
	hint.visible = true
	hint.text = text
	hint.add_theme_color_override("font_color", color)
	await get_tree().create_timer(5).timeout
	hint.visible = false
#endregion
