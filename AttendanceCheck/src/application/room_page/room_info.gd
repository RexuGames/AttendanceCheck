@icon("res://addons/at-icons/node/info.svg")
extends Node

@export_group("References")
@export var name_label: Label
@export var students: Label
@export var edit: Button


var room : RoomResource 

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.rooms_updated, _on_rooms_updated)
	Utils.SafeConnect(EventBus.masterlist_updated, _on_masterlist_updated)
	Utils.SafeConnect(edit.pressed, _on_edit_pressed)
func Init(room : RoomResource) -> void:
	self.room = room
	UpdateData(room)

#region Listeners
func _on_edit_pressed() -> void:
	Widgets.CreateEditRoom(room, false, 
		func(draft_room : RoomResource):
			room.name = draft_room.name
			UpdateData(room)
			EventBus.room_edited.emit(room)
			)

func _on_masterlist_updated(_masterlist) -> void:
	UpdateData(room)
func _on_rooms_updated(_rooms) -> void:
	UpdateData(room)
#endregion
#region Local
func UpdateData(room : RoomResource) -> void:
	if (room == null): return
	name_label.text = room.name
	students.text = "%d Students" % room.masterlist.size()
#endregion
