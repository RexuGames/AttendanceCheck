extends WidgetCanva

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel


var attendance_record : Dictionary
var masterlist : Dictionary

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	attendance_record = passed_data["attendance_record"]
	masterlist = passed_data["masterlist"]
	UpdateDisplayedAttendance()

#region Local
func UpdateDisplayedAttendance() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
	pass
#endregion

#region Utils
func _DisplayStudents() -> void:
	for student_id : String in attendance_record:
		_AddStudentPanel(student_id)
func _AddStudentPanel(student_id : String) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	var remark_label : Label  = new_student_panel.get_node("Margin/Contents/Remark")
	
	remark_label.text = "Present" if (attendance_record.get(student_id, false)) else "Absent"
	name_label.text = masterlist.get(student_id, "NULL")
	new_student_panel.visible = true

	list.add_child(new_student_panel)
#endregion
