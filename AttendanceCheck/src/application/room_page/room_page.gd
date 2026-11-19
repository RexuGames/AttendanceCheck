extends PageCanva

@export_group("References")
@export var masterlist_handler: Node
@export var today_attendance: Node
@export var room_info: Node


func _page_activated(passed_data : Dictionary) -> void:
	var room : RoomResource = passed_data["room"]
	InitHandlers(room)
#region Local
func InitHandlers(room : RoomResource) -> void:
	masterlist_handler.Init(room.masterlist)
	today_attendance.Init(room.attendance_history, room.masterlist)
	room_info.Init(room)
#endregion
