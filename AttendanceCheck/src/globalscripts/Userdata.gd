@icon("res://addons/at-icons/node/floppy_disk.svg")
extends Node


const FILE_PATH : String = "user://saved_data.tres"
var resource : UserdataResource

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.signed_in, _on_signed_in)
	Utils.SafeConnect(EventBus.logged_in, _on_logged_in)
	Utils.SafeConnect(EventBus.attendance_updated, _on_attendance_updated)
	Utils.SafeConnect(EventBus.room_edited, _on_room_edited)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
func _ready() -> void:
	LoadResource()
#region Listeners
func _on_signed_in(account_uuid : String, username : String) -> void:
	resource.account_uuid = account_uuid
	resource.account_username = username
	Log.pr("Hello " + username)
	SaveResource()
	pass
func _on_logged_in(uuid : String) -> void:
	resource.account_uuid = uuid
	Supabase.RequestLoadResource(uuid, FILE_PATH, 
		func(data : Dictionary):
			if (not data.has("error")):
				Log.succ("Files loaded from database!")
				LoadResource()
			else:
				if (data["error"] == "uuid_not_found"):
					Log.warn("UUID does not exist!")
					Log.warn("Removing resource.account_uuid")
					Userdata.resource.account_uuid = ""
					SaveResource()
			)
	SaveResource()
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
	Log.succ("Data saved localy!")
	ResourceSaver.save(resource, FILE_PATH)
	SaveToDB()
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

#region Utils
func SaveToDB() -> void:
	if (resource.account_uuid.is_empty()): return
	Supabase.RequestSaveResource(FILE_PATH, resource.account_uuid, 
		func(data : Dictionary):
			if (data.has("data")):
				Log.succ("Saved to database!")
			)
#endregion
