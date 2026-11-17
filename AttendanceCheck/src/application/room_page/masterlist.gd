@icon("res://addons/at-icons/node/list_ordered.svg")
extends Node
## Displays Masterlist Students

@export_group("References")
@export var student_panel: Panel
@export var list: VBoxContainer
@export var edit: TextureButton


var masterlist : Dictionary[String, String]

func _enter_tree() -> void:
	Utils.SafeConnect(edit.pressed, _on_edit_pressed)

#region Listeners
func _on_edit_pressed() -> void:
	Widgets.CreateEditMasterlist(masterlist, 
		func(new_masterlist : Dictionary):
			UpdateMasterlistData(new_masterlist)
			UpdateDisplayedMasterlist()
	)
#endregion

#region Global
func Init(masterlist : Dictionary[String, String]) -> void:
	self.masterlist = masterlist
	UpdateDisplayedMasterlist()
#endregion

#region Local
func UpdateMasterlistData(new_masterlist : Dictionary[String,String]) -> void:
	masterlist = new_masterlist
	EventBus.masterlist_updated.emit(masterlist)
	
## Updates displayed masterlist students 
func UpdateDisplayedMasterlist() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
	pass
#endregion

#region Utils
func _DisplayStudents() -> void:
	var n : int = 0
	for student_id : String in masterlist:
		n += 1
		_AddStudentPanel(student_id, n)
func _AddStudentPanel(student_id : String, num : int) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	var number_label : Label = new_student_panel.get_node("Margin/Contents/Number")
	
	name_label.text = masterlist.get(student_id, "NULL")
	number_label.text = str(num)
	new_student_panel.visible = true
	list.add_child(new_student_panel)
#endregion
