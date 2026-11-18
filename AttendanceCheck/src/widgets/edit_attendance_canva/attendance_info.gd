extends Node

@export_group("References")
@export var date_label: Label

func Init(date : Dictionary) -> void:
	date_label.text = GetFormattedDate(date)
	pass

func GetFormattedDate(date : Dictionary) -> String:
	
	var weekdays := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
				   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	
	var weekday_str : String = weekdays[date.weekday]
	var month_str : String = months[date.month - 1]
	
	return "%s, %s %d %d" % [weekday_str, month_str, date.day, date.year]
