@icon("res://addons/at-icons/node/script.svg")
extends Node


@export_group("References")
@export var step_1: Node
@export var step_3: Node
@export var step_2_contents: VBoxContainer
@export var code_edit: LineEdit
@export var resend: RichTextLabel
@export var done: Button
@export var hint: Label
@export var back: Button

@export_group("Resend Cooldown")
@export var resend_cooldown_seconds: int = 30

var email : String = ""
var code : int = 0
var can_send : bool = true
var _cooldown_time_left : int = 0

func _enter_tree() -> void:
	Utils.SafeConnect(resend.meta_clicked, _on_meta_clicked)
	Utils.SafeConnect(done.pressed, _on_done_pressed)
	Utils.SafeConnect(back.pressed, _on_back_pressed)

#region Listeners
func _on_back_pressed() -> void:
	BackStep()
func _on_done_pressed() -> void:
	if (int(code_edit.text) == code):
		NextStep()
	else:
		_ShowHint("Invalid Code!", Color.RED)
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
func BackStep() -> void:
	email = ""
	step_2_contents.visible = false
	step_1.InitStep()
func SendCode(email : String) -> void:
	if (not can_send): return
	can_send = false
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

	_StartResendCooldown()
func NextStep() -> void:
	step_2_contents.visible = false
	Log.pr(email)
	step_3.InitStep(email)
#endregion

#region Utils
func _ShowHint(text : String, color : Color = Color.BLACK) -> void:
	hint.visible = true
	hint.text = text
	hint.add_theme_color_override("font_color", color)
	await get_tree().create_timer(5).timeout
	hint.visible = false

func _StartResendCooldown() -> void:
	_cooldown_time_left = resend_cooldown_seconds
	_UpdateResendLabel()

	while _cooldown_time_left > 0:
		await get_tree().create_timer(1.0).timeout
		_cooldown_time_left -= 1
		_UpdateResendLabel()

	can_send = true
	resend.text = "Didn't get the code? [url=\"resend\"][b]Resend[/b][/url]"

func _UpdateResendLabel() -> void:
	if _cooldown_time_left > 0:
		resend.text = "Didn't get the code? Resend (%ds)" % _cooldown_time_left
	else:
		resend.text = "Didn't get the code? [url=\"resend\"][b]Resend[/b][/url]"
#endregion
