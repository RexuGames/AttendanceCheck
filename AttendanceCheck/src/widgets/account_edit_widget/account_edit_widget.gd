extends WidgetCanva

@export_group("References")
@export var name_edit: LineEdit
@export var done: Button


func _enter_tree() -> void:
	super()
	Utils.SafeConnect(done.pressed, _on_done_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	name_edit.text = passed_data["username"]

#region Listeners
func _on_done_pressed() -> void:
	edit_confirmed.emit(name_edit.text)
	CloseWidget()
#endregion
