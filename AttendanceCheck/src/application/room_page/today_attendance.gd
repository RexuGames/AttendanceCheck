@icon("res://addons/at-icons/node/calendar.svg")
extends Node

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel
@export var attendance_container: VBoxContainer
@export var no_record_container: VBoxContainer
@export var record_attendance: Button
@export var view_attendance: Button
@export var total_label: Label


var masterlist : Dictionary[String,String]
var attendance_today : Dictionary[String, bool]

func _enter_tree() -> void:
	Utils.SafeConnect(record_attendance.pressed, _on_record_attendance_pressed)
	Utils.SafeConnect(view_attendance.pressed, _on_view_attendance_pressed)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)
	Utils.SafeConnect(EventBus.attendance_updated, _on_attendance_updated)

#region Listeners
func _on_view_attendance_pressed() -> void:
	Widgets.CreateViewAttendance(attendance_today, masterlist, GetDateToday())
func _on_attendance_updated(new_record : Dictionary, date : Dictionary):
	if not (date == GetDateToday()): return
	attendance_today = new_record
	UpdateDisplayedAttendance()
	UpdateStateContainers()
	UpdateAttendanceCount()
func _on_masterlist_updated(new_masterlist : Dictionary) -> void:
	masterlist = new_masterlist
	UpdateAttendanceTodayStudents() 
	UpdateDisplayedAttendance()
	UpdateAttendanceCount()
func _on_record_attendance_pressed() -> void:
	if (masterlist.is_empty()):
		ToastCreator.show_toast("Please add students first!")
		return
	Widgets.CreateEditAttendance(attendance_today, masterlist, "", GetDateToday(), 
		func(new_record : Dictionary):
			EventBus.attendance_updated.emit(new_record, GetDateToday())
			)
#endregion

#region Global
func Init(attendance_history : Dictionary[Dictionary,Dictionary], masterlist : Dictionary[String,String]) -> void:
	self.masterlist = masterlist
	self.attendance_today = attendance_today
	UpdateStateContainers()
#endregion

#region Local
func UpdateAttendanceCount() -> void:
	if (attendance_today.is_empty()):
		total_label.text = "N/A"
		return
	
	var total_present : int = 0
	
	for is_present : bool in attendance_today.values():
		if (not is_present): continue
		total_present += 1
	
	total_label.text = "%d/%d" % [total_present, attendance_today.size()]
## If has attendance record today Show Attendance List else show no record container
func UpdateStateContainers() -> void:
	if (attendance_today.is_empty()):
		ToggleAttendanceContainer(false)
	else:
		ToggleAttendanceContainer(true)
		UpdateDisplayedAttendance()
## Adds students that is not in today_attenance NOTE: Only if today_attendance is not empty!
func UpdateAttendanceTodayStudents() -> void:
	if (attendance_today.is_empty()): return
	
	## Remove student in attendance that is not in masterlist.
	for student_id : String in attendance_today:
		if (masterlist.has(student_id)): continue
		attendance_today.erase(student_id)
	## Adds unregistered students in attendance.
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
	
	remark_label.text = "Present" if (attendance_today.get(student_id, false)) else "Absent"
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
