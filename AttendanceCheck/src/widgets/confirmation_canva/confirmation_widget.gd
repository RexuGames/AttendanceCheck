extends WidgetCanva

@export_group("References")
@export var info: Label
@export var yes: Button


func _enter_tree() -> void:
	super()
	Utils.SafeConnect(yes.pressed, _on_yes_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	info.text = passed_data["info"]

#region Listeners
func _on_yes_pressed() -> void:
	edit_confirmed.emit(true)
	CloseWidget()
#endregion
