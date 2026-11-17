extends WidgetCanva

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel
@export var done: Button

var masterlist : Dictionary[String, String]
var draft_attendance_record : Dictionary[String, bool]

func _enter_tree() -> void:
	super()
	Utils.SafeConnect(done.pressed, _on_done_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	masterlist = passed_data["masterlist"]
	CreateAttendanceRecordDraft(passed_data)
	UpdateDisplayedAttendance()

#region Listeners
func _on_done_pressed() -> void:
	edit_confirmed.emit(draft_attendance_record)
	CloseWidget()
func _on_student_checked(checked : bool, student_id : String) -> void:
	draft_attendance_record[student_id] = checked
#endregion

#region Local
func UpdateDisplayedAttendance() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
func CreateAttendanceRecordDraft(passed_data : Dictionary) -> void:
	draft_attendance_record = passed_data["attendance_record"].duplicate()
#endregion
#region Utils
func _DisplayStudents() -> void:
	for student_id : String in draft_attendance_record:
		_AddStudentPanel(student_id)
func _AddStudentPanel(student_id : String) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	var checkbox : CheckBox  = new_student_panel.get_node("Margin/Contents/CheckBox")
	
	Utils.SafeConnect(checkbox.toggled, _on_student_checked.bind(student_id))
	name_label.text = masterlist.get(student_id, "NULL")
	checkbox.button_pressed = draft_attendance_record.get(student_id, false)
	new_student_panel.visible = true

	list.add_child(new_student_panel)
#endregion
