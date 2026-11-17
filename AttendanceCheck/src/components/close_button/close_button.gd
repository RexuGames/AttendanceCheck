extends BaseButton

func _enter_tree() -> void:
	Utils.SafeConnect(pressed, _on_pressed)

#region Listeners
func _on_pressed() -> void:
	EventBus.page_pop_front_request.emit()
#endregion
