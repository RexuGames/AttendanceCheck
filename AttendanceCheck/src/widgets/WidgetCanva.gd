extends PageCanva
class_name WidgetCanva
signal edit_confirmed(value : Variant)

#region Global
func InitWidget(passed_data : Dictionary) -> void:
	EventBus.page_push_request.emit(self, {})
#endregion

#region Local
func CloseWidget() -> void:
	EventBus.page_pop_front_request.emit()
#endregion
