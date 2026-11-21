@icon("res://addons/at-icons/control/script.svg")
extends Node


func GenerateUUID() -> String:
	var bytes = PackedByteArray()
	bytes.resize(16)
	
	for i in range(16):
		bytes[i] = randi() % 256
	
	# Set version (4) and variant bits per RFC 4122
	bytes[6] = (bytes[6] & 0x0F) | 0x40  # version 4
	bytes[8] = (bytes[8] & 0x3F) | 0x80  # variant 10

	var hex = ""
	for b in bytes:
		hex += "%02x" % b
	
	return "%s-%s-%s-%s-%s" % [
		hex.substr(0, 8),
		hex.substr(8, 4),
		hex.substr(12, 4),
		hex.substr(16, 4),
		hex.substr(20, 12)
	]
func SafeConnect(event : Signal, callback : Callable):
	if (event.is_connected(callback)): return
	event.connect(callback) 
func GetLocalUnixTime() -> int:
	return Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
func DateToKey(date : Dictionary) -> String:
	return "%04d-%02d-%02d" % [date["year"], date["month"], date["day"]]
## Frees all children.
func RemoveChildren(parent : Node, ...exceptions : Array):
	for node : Node in parent.get_children():
		if (exceptions.has(node)): continue
		node.queue_free()
