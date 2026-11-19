extends WidgetCanva

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel
@export var edit: Button
@export var present: Label
@export var absent: Label


var date : Dictionary
var attendance_record : Dictionary
var masterlist : Dictionary

func _enter_tree() -> void:
	super()
	Utils.SafeConnect(edit.pressed, _on_edit_pressed)
	Utils.SafeConnect(EventBus.attendance_updated, _on_attendance_updated)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	attendance_record = passed_data["attendance_record"]
	masterlist = passed_data["masterlist"]
	date = passed_data["date"]
	UpdateDisplayedAttendance()
	UpdateTotalPresentAbsent()

#region Listeners
func _on_attendance_updated(new_record : Dictionary, date : Dictionary):
	if (not self.date == date): return
	attendance_record = new_record
	UpdateDisplayedAttendance()
	UpdateTotalPresentAbsent()
	
func _on_edit_pressed() -> void:
	Widgets.CreateEditAttendance(attendance_record, masterlist, "", date, 
		func(new_record : Dictionary):
			EventBus.attendance_updated.emit(new_record, date)
			)
	pass
#endregion
#region Local
func UpdateTotalPresentAbsent() -> void:
	var total_absent : int = 0
	var total_present : int = 0
	for is_present : bool in attendance_record.values():
		if (is_present):
			total_present += 1
		else:
			total_absent += 1
	present.text = "%d Present" % total_present
	absent.text = "%d Absent" % total_absent
# Updates the original reference
func UpdateAttendanceData(new_record : Dictionary) -> void:
	attendance_record.clear()
	attendance_record.merge(new_record)
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
