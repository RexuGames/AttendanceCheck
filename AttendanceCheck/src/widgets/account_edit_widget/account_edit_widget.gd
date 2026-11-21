extends WidgetCanva

@export_group("References")
@export var name_edit: LineEdit
@export var done: Button
@export var hint: Label


func _enter_tree() -> void:
	super()
	Utils.SafeConnect(done.pressed, _on_done_pressed)
	

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	name_edit.text = passed_data["username"]

#region Listeners
func _on_done_pressed() -> void:
	if (not IsEditValid()): return
	edit_confirmed.emit(name_edit.text)
	CloseWidget()
#endregion

#region Local
func IsEditValid() -> bool:
	if (name_edit.text.strip_edges().is_empty()):
		_ShowError("Invalid Name!")
		return false 
	return true
func _ShowError(text : String) -> void:
	name_edit.text = text
	await get_tree().create_timer(2.0).timeout
	name_edit.text = ""
#endregion
