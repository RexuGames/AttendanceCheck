@icon("res://addons/at-icons/node/script.svg")
extends Node

@export var ERROR_COLOR = Color.RED
@export var  OK_COLOR = Color.GREEN
@export_group("References")
@export var email_edit: LineEdit
@export var password_edit: LineEdit
@export var username_edit: LineEdit
@export var show_password: CheckButton
@export var show_confirm_password: CheckButton
@export var login_control: Control
@export var confirm_password_edit: LineEdit
@export var sign_up_button: Button
@export var login_button: Button
@export var signup_control: Control
@export var hint_label: Label

func _enter_tree() -> void:
	Utils.SafeConnect(show_password.toggled, _on_show_password_toggled)
	Utils.SafeConnect(show_confirm_password.toggled, _on_show_confirmpassword_toggled)
	Utils.SafeConnect(login_button.pressed, _on_login_pressed)
	Utils.SafeConnect(sign_up_button.pressed, _on_signup_pressed)

#region Listeners
func _on_show_password_toggled(toggled_on : bool) -> void:
	password_edit.secret = !toggled_on 
	Log.pr(password_edit.secret)
func _on_show_confirmpassword_toggled(toggled_on : bool) -> void:
	confirm_password_edit.secret = !toggled_on
func _on_signup_pressed() -> void:
	
	var email : String = email_edit.text
	var username : String = username_edit.text
	var password : String = password_edit.text
	var confirm : String = confirm_password_edit.text
	
	if (not IsValidInputs(email,password,confirm)): return
	sign_up_button.disabled = true
	Log.pr("R")
	Supabase.RequestCreateAccount(email, password,
		func(data : Dictionary):
			if (data.has("error")):
				_ShowError(data["error"])
			else:
				var uuid : String = data["uuid"]
				EventBus.signed_in.emit(uuid, username)
				EventBus.page_pop_front_request.emit()
			sign_up_button.disabled = false
	)
	pass
func _on_login_pressed() -> void:
	signup_control.visible = false
	login_control.visible = true
#endregion

#region Local
func IsValidInputs(email: String, password: String, confirm: String) -> bool:

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

	if password.length() < 5:
		_ShowError("Password must be at least 5 characters!")
		return false

	if password.contains(" "):
		_ShowError("Password cannot contain spaces!")
		return false

	# --- Confirm password checks ---
	if confirm.is_empty():
		_ShowError("Please confirm your password!")
		return false

	if password != confirm:
		_ShowError("Passwords do not match!")
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
