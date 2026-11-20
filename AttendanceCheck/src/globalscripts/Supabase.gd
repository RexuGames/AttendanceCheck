@icon("res://addons/at-icons/node2d/database.svg")
extends HTTPRequest

const SUPABASE_ANON_KEY : String = "sb_publishable_UR2-_1LWpvc0oEZbWxqvCg_45E8Fmi_"
const SUPABASE_URL : String = "https://oxkhlzgtqisloniivhcc.supabase.co"


func _enter_tree() -> void:
	Utils.SafeConnect(request_completed, _on_request_completed)

#region Listeners
func _on_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	var data : Dictionary
	
	if (response_code < 200 and response_code >= 300):
		Log.err("HTTP Request Failed; code: ", response_code)
		CallListener(data)
		return
	
	var body_text = body.get_string_from_utf8()
	
	if (body_text.is_empty()):
		Log.err("Something went wrong: ", data)
		CallListener({"error" : "Something went wrong :("})
		return
	
	var parsed : Dictionary = JSON.parse_string(body_text)
	data = parsed
	Log.pr(data)
	CallListener(data)
#endregion

#region Global
func RequestLoginAccount(email : String, password : String, listener : Callable) -> void:
	_CreateRequest(
		"login-account", 
		{
			"email" : email,
			"password" : password
		}, 
		listener)
func RequestCreateAccount(email : String, password : String, listener : Callable) -> void:
	_CreateRequest(
		"create-account", 
		{
			"email" : email,
			"password" : password
		}, 
		listener)
#endregion

#region Utils
func _CreateRequest(edge_name : String, data : Dictionary, listener : Callable) -> void:
	var URL : String = SUPABASE_URL + "/functions/v1/" + edge_name
	const HEADERS := [
		"apikey: " + SUPABASE_ANON_KEY,
		"Authorization: Bearer " + SUPABASE_ANON_KEY,  
		"Content-Type: application/json" 
	]
	var body : String = JSON.stringify(data)
	var err : Error = request(URL, HEADERS, HTTPClient.METHOD_POST, body)
	
	if (err == OK):
		set_meta("listener", listener)
	else:
		Log.pr("Something went wrong!")
func CallListener(body : Dictionary):
	var listener : Callable = get_meta("listener", Callable())
	if (listener.is_valid()):
		listener.call(body)
#endregion
