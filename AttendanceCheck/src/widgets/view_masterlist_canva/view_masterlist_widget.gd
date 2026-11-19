extends WidgetCanva

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel

var masterlist : Dictionary

func InitWidget(passed_data : Dictionary) -> void:
	masterlist = passed_data["masterlist"]
	UpdateDisplayedAttendance()

#region Local
func UpdateDisplayedAttendance() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
#endregion

#region Utils
func _DisplayStudents() -> void:
	for student_id : String in masterlist:
		_AddStudentPanel(student_id)
func _AddStudentPanel(student_id : String) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	
	name_label.text = masterlist.get(student_id, "NULL")
	new_student_panel.visible = true

	list.add_child(new_student_panel)
#endregion
