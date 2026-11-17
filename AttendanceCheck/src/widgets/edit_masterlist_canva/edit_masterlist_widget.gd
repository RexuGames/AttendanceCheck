extends WidgetCanva

@export_group("References")
@export var confirm: Button
@export var list: VBoxContainer
@export var student_panel: Panel


var draft_masterlist : Dictionary[String, String]

func _enter_tree() -> void:
	super()
	Utils.SafeConnect(confirm.pressed, _on_confirm_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	CreateMasterlistDraft(passed_data)
	UpdateDisplayedMasterlist()

#region Listeners
func _on_confirm_pressed() -> void:
	edit_confirmed.emit(draft_masterlist)
	CloseWidget()
func _on_remove_student_pressed(student_id : String) -> void:
	if (not draft_masterlist.has(student_id)): return
	draft_masterlist.erase(student_id)
	UpdateDisplayedMasterlist()
	pass
#endregion

#region Local
func UpdateDisplayedMasterlist() -> void:
	Utils.RemoveChildren(list, student_panel)
	_DisplayStudents()
	pass
func CreateMasterlistDraft(passed_data : Dictionary) -> void:
	draft_masterlist = passed_data["masterlist"].duplicate()
#endregion

#region Listeners
func _DisplayStudents() -> void:
	for student_id : String in draft_masterlist:
		_AddStudentPanel(student_id)
func _AddStudentPanel(student_id : String) -> void:
	var new_student_panel : Panel = student_panel.duplicate()
	var name_label : Label = new_student_panel.get_node("Margin/Contents/Name")
	var remove_button : BaseButton  = new_student_panel.get_node("Margin/Contents/Remove")
	
	Utils.SafeConnect(remove_button.pressed, _on_remove_student_pressed.bind(student_id))
	name_label.text = draft_masterlist.get(student_id, "NULL")
	new_student_panel.visible = true

	list.add_child(new_student_panel)
#endregion
