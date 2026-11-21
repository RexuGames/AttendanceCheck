@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var accounts: Button
@export var account_page: PageCanva
@export var title: Label
@export var desc: Label

func _enter_tree() -> void:
	Utils.SafeConnect(accounts.pressed, _on_accounts_pressed)
	Utils.SafeConnect(EventBus.logged_in, _on_logged_in)
	Utils.SafeConnect(EventBus.signed_in, _on_signed_in)
	Utils.SafeConnect(EventBus.userdata_loaded, _on_userdata_loaded)


#region Listeners
func _on_userdata_loaded(_a : Resource) -> void:
	UpdateDisplay()
func _on_signed_in(_a,_b,_c) -> void:
	UpdateDisplay()
func _on_logged_in(_a) -> void:
	UpdateDisplay()
func _on_accounts_pressed() -> void:
	if (Userdata.resource.account_uuid.is_empty()):
		EventBus.page_push_request.emit(account_page, {})
	pass
#endregion

#region Local
func UpdateDisplay() -> void:
	var userdata : UserdataResource = Userdata.resource
	if (userdata.account_uuid.is_empty()):
		title.text = "Login / Signup"
		desc.text = "Saves data to cloud."
	else:
		title.text = userdata.account_username
		desc.text = userdata.account_email
	pass
#endregion
