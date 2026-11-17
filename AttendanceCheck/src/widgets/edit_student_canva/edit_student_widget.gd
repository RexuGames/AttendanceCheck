extends WidgetCanva

@export_group("References")
@export var title: Label
@export var name_edit: LineEdit
@export var done: Button


func _enter_tree() -> void:
	super()
	Utils.SafeConnect(done.pressed, _on_done_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	title.text = "Add Student" if (passed_data["is_adding"]) else "Edit Student"
	name_edit.text = passed_data["name"]

#region Listeners
func _on_done_pressed() -> void:
	edit_confirmed.emit(name_edit.text)
	CloseWidget()
#endregion
