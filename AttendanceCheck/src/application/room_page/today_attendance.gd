@icon("res://addons/at-icons/node/calendar.svg")
extends Node

@export_group("References")
@export var list: VBoxContainer
@export var attendance_container: VBoxContainer
@export var no_record_container: VBoxContainer

func Init(attendance : Dictionary[Dictionary,Dictionary]) -> void:
	if (attendance.has(GetDateToday())):
		ToggleAttendanceContainer(true)
	else:
		ToggleAttendanceContainer(false)

#region Utils
func ToggleAttendanceContainer(is_toggled : bool) -> void:
	attendance_container.visible = is_toggled
	no_record_container.visible = not is_toggled
	pass
func GetDateToday() -> Dictionary:
	return Time.get_date_dict_from_system()
#endregion
