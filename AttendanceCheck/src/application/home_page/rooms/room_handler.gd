@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var room_panel: Panel
@export var list: VBoxContainer
@export var create_room: Button
@export var room_page: PageCanva

var rooms : Array[RoomResource]
func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.room_edited, _on_room_edited)
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
	Utils.SafeConnect(EventBus.userdata_loaded, _on_userdata_loaded)
	Utils.SafeConnect(create_room.pressed, _on_createroom_pressed)
#region Listeners
func _on_room_edited(room : RoomResource) -> void:
	UpdateDisplayedRooms()
	pass
func _on_room_open(room : RoomResource) -> void:
	EventBus.page_push_request.emit(room_page, {"room" : room})
	pass
func _on_rooms_updated(rooms : Array[RoomResource]) -> void:
	self.rooms = rooms
	UpdateDisplayedRooms()
func _on_createroom_pressed() -> void:
	Widgets.CreateEditRoom(RoomResource.new(), true, 
		func(room_draft : RoomResource):
			rooms.append(room_draft)
			EventBus.rooms_updated.emit(rooms)
			)
func _on_userdata_loaded(resource : UserdataResource) -> void:
	rooms = resource.rooms
	UpdateDisplayedRooms()
#endregion
#region Local
func UpdateDisplayedRooms() -> void:
	Utils.RemoveChildren(list, room_panel)
	_DisplayRooms()
#endregion

#region Utils
func _DisplayRooms() -> void:
	for room : RoomResource in rooms:
		_AddRoomPanel(room)
func _AddRoomPanel(room : RoomResource) -> void:
	var new_room_panel : Panel = room_panel.duplicate()
	var name_label : Label = new_room_panel.get_node("Margin/Contents/Info/Name")
	var students_label : Label = new_room_panel.get_node("Margin/Contents/Info/Students/Students")
	var open_button : BaseButton = new_room_panel.get_node("Margin/Contents/Open")
	Utils.SafeConnect(open_button.pressed, _on_room_open.bind(room))
	name_label.text = room.name
	students_label.text = str(room.masterlist.size())
	new_room_panel.visible = true
	list.add_child(new_room_panel)
#endregion
