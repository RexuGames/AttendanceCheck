extends PageCanva
class_name WidgetCanva


func InitWidget(passed_data : Dictionary) -> void:
	EventBus.page_push_request.emit(self, {})
	pass
