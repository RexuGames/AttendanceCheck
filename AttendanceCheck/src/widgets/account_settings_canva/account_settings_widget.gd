extends WidgetCanva

@export_group("References")
@export var name_label: Label
@export var uid: Label
@export var edit: Button
@export var email: Label
@export var logout: Button

var userdata : UserdataResource

func _enter_tree() -> void:
	super()
	Utils.SafeConnect(logout.pressed, _on_logout_pressed)

func InitWidget(passed_data : Dictionary) -> void:
	super(passed_data)
	userdata = Userdata.resource
	DisplayInfo()

#region Listeners
func _on_logout_pressed() -> void:
	EventBus.logout.emit()
	CloseWidget()
#endregion

#region Local
func DisplayInfo() -> void:
	name_label.text = userdata.account_username
	uid.text = "UID: " + userdata.account_uuid
	email.text = userdata.account_email
	pass
#endregion
