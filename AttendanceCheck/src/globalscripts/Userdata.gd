@icon("res://addons/at-icons/node/floppy_disk.svg")
extends Node


const FILE_PATH : String = "user://saved_data.tres"
var resource : UserdataResource

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.attendance_updated, _on_attendance_updated)
	Utils.SafeConnect(EventBus.room_edited, _on_room_edited)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
func _ready() -> void:
	LoadResource()
#region Listeners
func _on_attendance_updated(_new_record : Dictionary, _date : Dictionary) -> void:
	SaveResource.call_deferred()
func _on_room_edited(_room : RoomResource) -> void:
	SaveResource.call_deferred()
func _on_masterlist_updated(_masterlist : Dictionary) -> void:
	SaveResource.call_deferred()
func _on_rooms_updated(rooms : Array[RoomResource]) -> void:
	SaveResource.call_deferred()
#endregion
#region Local
func SaveResource() -> void:
	Log.pr("Data saved!")
	ResourceSaver.save(resource, FILE_PATH)
func LoadResource() -> void:
	if (not FileAccess.file_exists(FILE_PATH)):
		CreateNewData()
		EventBus.userdata_loaded.emit(resource)
		return
	resource = ResourceLoader.load(FILE_PATH)
	EventBus.userdata_loaded.emit(resource)
func CreateNewData() -> void:
	resource = UserdataResource.new()
	SaveResource()
	Log.warn("Creating a new data!")
#endregion
