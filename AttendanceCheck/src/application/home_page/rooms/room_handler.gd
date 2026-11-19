@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var room_button: BaseButton
@export var list: VBoxContainer
@export var create_room: Button
@export var room_page: PageCanva
@export var edit_rooms: Button
@export var room_edit_actions: HBoxContainer
@export var edit_cancel: Button
@export var edit_delete: Button

var rooms : Array[RoomResource]

# EDITING STUFFS
var is_editing : bool = false

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.room_edited, _on_room_edited)
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)
	Utils.SafeConnect(EventBus.userdata_loaded, _on_userdata_loaded)
	Utils.SafeConnect(edit_rooms.pressed, _on_editrooms_pressed)
	Utils.SafeConnect(create_room.pressed, _on_createroom_pressed)
	Utils.SafeConnect(edit_cancel.pressed, _on_editcancel_pressed)
	Utils.SafeConnect(edit_delete.pressed, _on_editdelete_pressed)
#region Listeners
func _on_editdelete_pressed() -> void:
	var selected_rooms : Array[RoomResource] = _GetSelectedRooms()
	if (selected_rooms.is_empty()): 
		ToastCreator.show_toast("Please select a room!")
		return
	
	Widgets.CreateConfirmation("Deleting %d rooms." % _GetSelectedRooms().size(), 
		func(_d):
			RemoveRooms(selected_rooms)
			ToggleEditMode(false)
			Log.prn(Userdata.resource.rooms)
			)
func _on_editcancel_pressed() -> void:
	ToggleEditMode(false)
func _on_editrooms_pressed() -> void:
	if (rooms.is_empty()):
		ToastCreator.show_toast("No rooms to edit.")
		return
	ToggleEditMode(false if is_editing else true)
	pass
func _on_room_pressed(room : RoomResource) -> void:
	if (is_editing):
		ToggleSelectRoom(room)
	else:
		EventBus.page_push_request.emit(room_page, {"room" : room})
func _on_masterlist_updated(_masterlist : Dictionary) -> void:
	UpdateDisplayedRooms()
func _on_room_edited(room : RoomResource) -> void:
	UpdateDisplayedRooms()
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
	Utils.RemoveChildren(list, room_button)
	_DisplayRooms()
func ToggleEditMode(toggle_mode : bool) -> void:
	is_editing = toggle_mode
	_ToggleRoomsEditBox()
	room_edit_actions.visible = is_editing
func ToggleSelectRoom(room : RoomResource) -> void:
	var checkbox : CheckBox = _FindRoomButton(room).get_node("Margin/Contents/Actions/CheckBox")
	checkbox.button_pressed = false if checkbox.button_pressed else true
func RemoveRooms(target_rooms : Array[RoomResource]) -> void:
	for selected_room : RoomResource in target_rooms:
		rooms.erase(selected_room)
	EventBus.rooms_updated.emit(rooms)
#endregion

#region Utils
func _DisplayRooms() -> void:
	for room : RoomResource in rooms:
		_AddRoomPanel(room)
func _AddRoomPanel(room : RoomResource) -> void:
	var new_room_button : BaseButton = room_button.duplicate()
	var name_label : Label = new_room_button.get_node("Margin/Contents/Info/Name")
	var students_label : Label = new_room_button.get_node("Margin/Contents/Info/Students/Students")
	var open_button : BaseButton = new_room_button.get_node("Margin/Contents/Actions/Open")
	new_room_button.set_meta("room", room)
	Utils.SafeConnect(open_button.pressed, _on_room_pressed.bind(room))
	Utils.SafeConnect(new_room_button.pressed, _on_room_pressed.bind(room))
	name_label.text = room.name
	students_label.text = "%d Students" % room.masterlist.size()
	new_room_button.visible = true
	list.add_child(new_room_button)
#region Editing Stuffs
func _GetSelectedRooms() -> Array[RoomResource]:
	var selected_rooms : Array[RoomResource]
	for node : Node in list.get_children():
		if not (node.has_meta("room")): continue
		
		var checkbox : CheckBox = node.get_node("Margin/Contents/Actions/CheckBox")
		if (checkbox.button_pressed):
			selected_rooms.append(node.get_meta("room"))
	return selected_rooms
func _ToggleRoomsEditBox() -> void:
	for node : Node in list.get_children():
		var checkbox : CheckBox = node.get_node("Margin/Contents/Actions/CheckBox")
		checkbox.button_pressed = false
		checkbox.visible = is_editing
func _FindRoomButton(room : RoomResource) -> Button:
	for node : Node in list.get_children():
		if (node.has_meta("room")):
			if (node.get_meta("room") != room): continue
			return node
	return null
#endregion
#endregion
