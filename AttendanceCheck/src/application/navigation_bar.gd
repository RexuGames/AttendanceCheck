extends Panel

const ACTIVE_COLOR : Color = Color("3C3939")
const INACTIVE_COLOR : Color = Color("838383")
@export_group("References")
@export var rooms_button: Button
@export var settings_button: Button
@export var rooms_page: Control
@export var settings_page: Control

func _ready() -> void:
	Utils.SafeConnect(rooms_button.pressed, _on_rooms_button_pressed)
	Utils.SafeConnect(settings_button.pressed, _on_settings_button_pressed)

#region Listeners
func _on_settings_button_pressed() -> void:
	SwitchToSettings()
func _on_rooms_button_pressed() -> void:
	SwitchToRooms()
#endregion
#region Local
func SwitchToRooms() -> void:
	rooms_button.modulate = ACTIVE_COLOR
	settings_button.modulate = INACTIVE_COLOR
	rooms_page.visible = true
	settings_page.visible = false
func SwitchToSettings() -> void:
	rooms_button.modulate = INACTIVE_COLOR
	settings_button.modulate = ACTIVE_COLOR
	rooms_page.visible = false
	settings_page.visible = true
#endregion
