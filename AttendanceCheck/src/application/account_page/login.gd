@icon("res://addons/at-icons/node/script.svg")
extends Node

@export var ERROR_COLOR = Color.RED
@export var OK_COLOR = Color.GREEN
@export_group("References")
@export var email_edit: LineEdit
@export var password_edit: LineEdit
@export var show_password: CheckButton
@export var login: Button
@export var signup: Button
@export var signup_control: Control
@export var login_control: Control
@export var hint_label: Label

func _enter_tree() -> void:
	Utils.SafeConnect(login.pressed, _on_login_pressed)
	Utils.SafeConnect(signup.pressed, _on_signup_pressed)
	Utils.SafeConnect(show_password.toggled, _on_showpassword_toggled)

#region Listeners
func _on_login_pressed() -> void:
	var email : String = email_edit.text
	var password : String = password_edit.text
	if (not IsValidInputs(email,password)): return
	login.disabled = true
	
	Supabase.RequestLoginAccount(email, password, 
		func(data : Dictionary):
			if (data.has("error")):
				_ShowError(data["error"])
			else:
				_ShowSuccess("Logged in!")
				Log.pr(data["data"]["uuid"])
				EventBus.logged_in.emit(data["data"]["uuid"])
				EventBus.page_pop_front_request.emit()
			login.disabled = false
			)
	pass
func _on_signup_pressed() -> void:
	signup_control.visible = true
	login_control.visible = false
	pass
func _on_showpassword_toggled(toggled_on : bool) -> void:
	password_edit.secret = !toggled_on
	pass
#endregion

#region Local
func IsValidInputs(email: String, password: String) -> bool:

	# --- Email checks ---
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

	# --- Password checks ---
	if password.is_empty():
		_ShowError("Please enter a password!")
		return false

	if password.strip_edges().is_empty():
		_ShowError("Password cannot be just spaces!")
		return false

	return true
#endregion

#region Utils
func _ShowError(text : String) -> void:
	Log.warn(text)
	hint_label.text = text
	hint_label.add_theme_color_override("font_color", ERROR_COLOR)
	await get_tree().create_timer(2).timeout
	hint_label.text = ""
func _ShowSuccess(text : String) -> void:
	hint_label.text = text
	hint_label.add_theme_color_override("font_color", OK_COLOR)
	await get_tree().create_timer(2).timeout
	hint_label.text = ""
#endregion
