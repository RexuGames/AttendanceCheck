extends WidgetCanva

@export_group("References")
@export var done: Button
@export var title: Label
@export var name_edit: LineEdit

var room_draft : RoomResource

func _enter_tree() -> void:
	super()
	Utils.SafeConnect(done.pressed, _on_done_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	title.text = "Create Room" if (passed_data["is_adding"]) else "Edit Room"
	room_draft = passed_data["room"].duplicate()
	name_edit.text = room_draft.name
	

#region Listeners
func _on_done_pressed() -> void:
	room_draft.name = name_edit.text
	edit_confirmed.emit(room_draft)
	CloseWidget()
#endregion
