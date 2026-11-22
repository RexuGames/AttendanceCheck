@icon("res://addons/at-icons/node2d/database.svg")
extends HTTPRequest

const SUPABASE_ANON_KEY : String = "sb_publishable_UR2-_1LWpvc0oEZbWxqvCg_45E8Fmi_"
const SUPABASE_URL : String = "https://oxkhlzgtqisloniivhcc.supabase.co"

var queued_requests : Array[Dictionary] = []
var is_busy : bool = false
var current_listener : Callable

func _enter_tree() -> void:
	Utils.SafeConnect(request_completed, _on_request_completed)

#region Listeners
func _on_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	var data : Dictionary

	if (response_code < 200 or response_code >= 500):
		Log.err("HTTP Request Failed; code: ", response_code)
		_CompleteRequest({"ok": false, "status": response_code, "error": "Internal Server Error"})
		return

	var body_text := body.get_string_from_utf8()

	if (body_text.is_empty()):
		Log.err("Something went wrong: empty response body")
		_CompleteRequest({"ok": false, "error": "empty_response"})
		return

	var parsed = JSON.parse_string(body_text)
	if (parsed == null or not (parsed is Dictionary)):
		Log.err("Failed to parse JSON: ", body_text)
		_CompleteRequest({"ok": false, "error": "invalid_json"})
		return

	data = parsed
	data["ok"] = true
	Log.succ("Request Completed!")
	_CompleteRequest(data)

func CallListener(body : Dictionary) -> void:
	if (current_listener.is_valid()):
		current_listener.call(body)

# Call the CURRENT listener first, THEN advance the queue — order matters
func _CompleteRequest(data : Dictionary) -> void:
	CallListener(data)
	_process_next()
#endregion


#region Global
func QueueRequest(starter: Callable, listener: Callable) -> void:
	queued_requests.append({"starter": starter, "listener": listener})

	if is_busy:
		return  # already processing; this one will run when its turn comes

	_process_next()

func _process_next() -> void:
	if queued_requests.is_empty():
		is_busy = false
		return

	is_busy = true
	var next: Dictionary = queued_requests.pop_front()
	current_listener = next["listener"]
	next["starter"].call()
	# _on_request_completed fires the real HTTP signal and calls _process_next() via _CompleteRequest


func RequestLoadResource(account_uuid: String, local_save_path: String, listener: Callable) -> void:
	var starter := func():
		_CreateRequest("load-data", {"account_uuid": account_uuid})

	QueueRequest(starter, func(result: Dictionary):
		if result.ok and result.has("file_base64"):
			var file_bytes: PackedByteArray = Marshalls.base64_to_raw(result["file_base64"])
			var file := FileAccess.open(local_save_path, FileAccess.WRITE)
			file.store_buffer(file_bytes)
			file.close()
			listener.call({"ok": true, "local_path": local_save_path})
		else:
			listener.call(result)
	)


func RequestSaveResource(local_path: String, account_uuid: String, listener: Callable) -> void:
	var starter := func():
		var file := FileAccess.open(local_path, FileAccess.READ)
		if file == null:
			# No network request is happening, so complete it manually
			# instead of letting the queue wait forever for a signal that will never fire
			_CompleteRequest({"error": "local_file_not_found"})
			return

		var file_bytes: PackedByteArray = file.get_buffer(file.get_length())
		file.close()

		var file_base64 := Marshalls.raw_to_base64(file_bytes)

		_CreateRequest("save-data", {
			"account_uuid": account_uuid,
			"file_base64": file_base64
		})

	QueueRequest(starter, listener)


func RequestLoginAccount(email : String, password : String, listener : Callable) -> void:
	var starter : Callable = func():
		_CreateRequest("login-account", {
			"email" : email,
			"password" : password
		})
	QueueRequest(starter, listener)


func RequestCreateAccount(email : String, password : String, listener : Callable) -> void:
	var starter : Callable = func():
		_CreateRequest("create-account", {
			"email" : email,
			"password" : password
		})
	QueueRequest(starter, listener)


func RequestFindEmail(email : String, listener : Callable) -> void:
	var starter : Callable = func():
		_CreateRequest("find-email", 
		{"email" : email})
	QueueRequest(starter, listener)


func RequestChangePassword(email : String, new_password : String, listener : Callable) -> void:
	var starter : Callable = func():
		_CreateRequest("change-password",
		{"email" : email,
		"new_password" : new_password})
	QueueRequest(starter, listener)
#endregion

#region Utils
func _CreateRequest(edge_name : String, data : Dictionary) -> void:
	var URL : String = SUPABASE_URL + "/functions/v1/" + edge_name
	var HEADERS := [
		"apikey: " + SUPABASE_ANON_KEY,
		"Authorization: Bearer " + SUPABASE_ANON_KEY,
		"Content-Type: application/json"
	]
	var body : String = JSON.stringify(data)
	var err : Error = request(URL, HEADERS, HTTPClient.METHOD_POST, body)

	if (err != OK):
		Log.pr("Something went wrong!")
		_CompleteRequest({"ok": false, "error": "request_failed_to_start"})
#endregion
