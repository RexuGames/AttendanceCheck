@icon("res://addons/at-icons/node/grid_fine.svg")
extends Node

const MAIN_COLOR : Color = Color("3C3939")
const START_MONTH : int = 9
const START_DAY : int = 1
const SECONDS_PERDAY : int = 86400

@export_group("References")
@export var row_container: HBoxContainer
@export var week_container: VBoxContainer
@export var day_button: Button
@export var scroll: ScrollContainer


var masterlist : Dictionary
var attendance_history : Dictionary
var day_buttons : Dictionary[String, Button]

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.attendance_updated, _on_attendance_updated)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)

#region Listeners
func _on_masterlist_updated(masterlist : Dictionary) -> void:
	UpdateHeatmapData()
	pass
func _on_attendance_updated(attendance_record : Dictionary, date : Dictionary) -> void:
	UpdateHeatmapData()
	pass
#endregion
#region Global
func Init(attendance_history : Dictionary, masterlist : Dictionary):
	self.masterlist = masterlist
	self.attendance_history = attendance_history
	InitHeatmap()
	UpdateHeatmapData()
#endregion
#region Local
func UpdateHeatmapData() -> void:
	_ScrollToMax()
	for date_key : String in attendance_history:
		var record : Dictionary = attendance_history[date_key]
		var alpha : float = maxf(0.5, (_GetTotalPresent(record) / record.size()))
		day_buttons[date_key].modulate = Color(MAIN_COLOR.r, MAIN_COLOR.g, MAIN_COLOR.b, alpha)
		Log.pr(_GetTotalPresent(record) / record.size())
func InitHeatmap() -> void:
	var start_date_unix = _DateToUnix(_GetStartDate())
	var today_unix : int = Time.get_unix_time_from_system()
	
	var current_unix : int = start_date_unix
	
	while current_unix <= today_unix:
		var current_week_container : VBoxContainer = _CreateWeekContainer()
		for weekday : int in range(0, 7):
			var date_key = Utils.DateToKey(Time.get_date_dict_from_unix_time(current_unix))
			var date_button : Button = _CreateDayButton(date_key, current_week_container)
			current_unix += SECONDS_PERDAY
			if (current_unix > today_unix):
				break
#endregion

#region Utils
func _ScrollToMax() -> void:
	await get_tree().process_frame
	var h_scroll_bar: HScrollBar = scroll.get_h_scroll_bar()
	h_scroll_bar.value = h_scroll_bar.max_value
func _GetTotalPresent(attendance_record : Dictionary) -> float:
	var total_present : int = 0
	for is_present : bool in attendance_record.values():
		if (is_present):
			total_present += 1
	return total_present
func _CreateWeekContainer() -> VBoxContainer:
	var new_container = week_container.duplicate()
	row_container.add_child(new_container)
	new_container.visible = true
	return new_container
func _CreateDayButton(date_key : String, week_container : VBoxContainer) -> Button:
	var new_button = day_button.duplicate()
	week_container.add_child(new_button)
	new_button.visible = true
	new_button.name = date_key
	day_buttons[date_key] = new_button
	return new_button
func _GetStartDate() -> Dictionary:
	var start_date: Dictionary = {
		"year" : Time.get_datetime_dict_from_system()["year"],
		"month" : START_MONTH,
		"day" : START_DAY,
		"hour" : 0, "minute" : 0, "second" : 0
	}

	var start_unix: int = int(Time.get_unix_time_from_datetime_dict(start_date))
	var weekday: int = Time.get_datetime_dict_from_unix_time(start_unix)["weekday"]

	# weekday: 0 = Sunday, 1 = Monday, ..., 6 = Saturday
	var days_until_monday: int = (8 - weekday) % 7  # days to ADD to reach next Monday

	start_unix += days_until_monday * 86400

	return Time.get_datetime_dict_from_unix_time(start_unix)
func _DateToUnix(date : Dictionary) -> float:
	return Time.get_unix_time_from_datetime_dict(date)
#endregion
