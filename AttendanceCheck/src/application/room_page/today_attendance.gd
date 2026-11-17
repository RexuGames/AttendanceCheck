@icon("res://addons/at-icons/node/calendar.svg")
extends Node

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel
@export var attendance_container: VBoxContainer
@export var no_record_container: VBoxContainer
@export var record_attendance: Button

var masterlist : Dictionary[String,String]
var attendance_today : Dictionary[String, bool]

func _enter_tree() -> void:
	Utils.SafeConnect(record_attendance.pressed, _on_record_attendance_pressed)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)

#region Listeners
func _on_masterlist_updated(new_masterlist : Dictionary) -> void:
	masterlist = new_masterlist
	RegisterStudents()
	Log.pr("Masterlist Updated")
func _on_record_attendance_pressed() -> void:
	Log.pr(masterlist)
	Widgets.CreateEditAttendance(attendance_today, masterlist, 
		func(new_record : Dictionary):
			attendance_today = new_record
			UpdateDisplayedAttendance()
			)
	pass
#endregion

#region Global
func Init(attendance_history : Dictionary[Dictionary,Dictionary], masterlist : Dictionary[String,String]) -> void:
	self.masterlist = masterlist
	self.attendance_today = attendance_today
	
	if (attendance_today.is_empty()):
		ToggleAttendanceContainer(false)
	else:
		RegisterStudents()
		ToggleAttendanceContainer(true)
		UpdateDisplayedAttendance()
#endregion

#region Local
## Adds students that is not in today_attenance if today_attendance is not empty!
func RegisterStudents() -> void:
	if (attendance_today.is_empty()): return
	for student_id : String in masterlist:
		if (attendance_today.has(student_id)): continue
		attendance_today[student_id] = false
## Creates Panels for each students in today_attendance
func UpdateDisplayedAttendance() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
	pass
#endregion

#region Utils
func _DisplayStudents() -> void:
	for student_id : String in attendance_today:
		_AddStudentPanel(student_id)
func _AddStudentPanel(student_id : String) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	var remark_label : Label  = new_student_panel.get_node("Margin/Contents/Remark")
	
	remark_label.text = attendance_today.get(student_id, false)
	name_label.text = masterlist.get(student_id, "NULL")
	new_student_panel.visible = true

	list.add_child(new_student_panel)

func ToggleAttendanceContainer(is_toggled : bool) -> void:
	attendance_container.visible = is_toggled
	no_record_container.visible = not is_toggled
	pass
func GetDateToday() -> Dictionary:
	return Time.get_date_dict_from_system()
#endregion
