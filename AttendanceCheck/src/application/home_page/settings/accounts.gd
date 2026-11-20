@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var accounts: Button
@export var account_page: PageCanva


func _enter_tree() -> void:
	Utils.SafeConnect(accounts.pressed, _on_accounts_pressed)

#region Listeners
func _on_accounts_pressed() -> void:
	EventBus.page_push_request.emit(account_page, {})
	pass
#endregion
