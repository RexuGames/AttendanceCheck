extends PageCanva

@export_group("References")
@export var masterlist_handler: Node


func _page_activated(passed_data : Dictionary) -> void:
	var room : RoomResource = RoomResource.new()
	InitHandlers(room)
#region Local
func InitHandlers(room : RoomResource) -> void:
	masterlist_handler.Init(room.masterlist)
#endregion
