extends PageCanva
class_name WidgetCanva
signal edit_confirmed(value : Variant)

func InitWidget(passed_data : Dictionary) -> void:
	EventBus.page_push_request.emit(self, {})
	pass
