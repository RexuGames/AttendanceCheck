extends PageCanva

@export_group("References")
@export var masterlist_handler: Node
@export var today_attendance: Node
@export var room_info: Node
@export var heatmap: Node


func _page_activated(passed_data : Dictionary) -> void:
	var room : RoomResource = passed_data["room"]
	InitHandlers(room)
#region Local
func InitHandlers(room : RoomResource) -> void:
	masterlist_handler.Init(room.masterlist)
	today_attendance.Init(room.attendance_history, room.masterlist)
	room_info.Init(room)
	heatmap.Init(room.attendance_history, room.masterlist)
#endregion
