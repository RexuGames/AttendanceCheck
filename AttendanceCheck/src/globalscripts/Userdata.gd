@icon("res://addons/at-icons/node/floppy_disk.svg")
extends Node


const FILE_PATH : String = "user://saved_data.tres"
var resource : UserdataResource

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
func _ready() -> void:
	LoadResource()
#region Listeners
func _on_rooms_updated(rooms : Array[RoomResource]) -> void:
	SaveResource.call_deferred()
#endregion
#region Local
func SaveResource() -> void:
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
