@icon("res://addons/at-icons/node/script.svg")
extends Node

@export_group("References")
@export var step_2_contents: VBoxContainer
@export var code_edit: LineEdit
@export var resend: RichTextLabel
@export var done: Button
@export var hint: Label

var email : String = ""
var code : int = 0

func _enter_tree() -> void:
	Utils.SafeConnect(resend.meta_clicked, _on_meta_clicked)
	Utils.SafeConnect(done.pressed, _on_done_pressed)

#region Listeners
func _on_done_pressed() -> void:
	if (int(code_edit.text) == code):
		Log.succ("Move to step 3!")
func _on_meta_clicked(meta : String) -> void:
	if (meta == "resend"):
		SendCode(email)
#endregion

#region Global
func InitStep(email : String) -> void:
	self.email = email
	step_2_contents.visible = true
	SendCode(email)
#endregion

#region Local
func SendCode(email : String) -> void:
	self.email = email
	code = randi_range(100000, 999999)

	var url := "https://api.resend.com/emails"
	var headers := [
		"Authorization: Bearer re_WHgabRiQ_ue77FPcoKzpwg4tATePb2Ayh",
		"Content-Type: application/json"
	]
	var body := JSON.stringify({
		"from": "Attendance Checker <onboarding@resend.dev>",
		"to": [email],
		"subject": "Your verification code",
		"html": "<p>Your code is: <strong>%s</strong></p>" % code
	})

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(result, response_code, resp_headers, resp_body):
		if response_code >= 200 and response_code < 300:
			_ShowHint("Code sent to %s" % email)
			Log.succ("Code sent to %s" % email)
		else:
			_ShowHint("Failed to send code.", Color.RED)
			Log.err("Failed to send code: ", resp_body.get_string_from_utf8())
		http.queue_free()
	)
	http.request(url, headers, HTTPClient.METHOD_POST, body)
#endregion

#region Utils
func _ShowHint(text : String, color : Color = Color.BLACK) -> void:
	hint.text = text
	hint.add_theme_color_override("font_color", color)
	await get_tree().create_timer(2).timeout
	hint.text = ""
#endregion
