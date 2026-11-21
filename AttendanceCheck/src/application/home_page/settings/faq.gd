@icon("res://addons/at-icons/node/help.svg")
extends Node

@export_group("References")
@export var FAQ_page: PageCanva
@export var faq_button: Button

func _enter_tree() -> void:
	Utils.SafeConnect(faq_button.pressed, _on_faq_pressed)

#region Listeners
func _on_faq_pressed() -> void:
	EventBus.page_push_request.emit(
		FAQ_page, {}
	)
	pass
#endregion
