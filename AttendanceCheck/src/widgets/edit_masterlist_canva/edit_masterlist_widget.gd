extends WidgetCanva

@export_group("References")
@export var list: VBoxContainer
@export var student_panel: Panel


var draft_masterlist : Dictionary[String, String]

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	CreateMasterlistDraft(passed_data)
	UpdateDisplayedMasterlist()

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
	
	name_label.text = draft_masterlist.get(student_id, "NULL")
	new_student_panel.visible = true
	list.add_child(new_student_panel)
#endregion
