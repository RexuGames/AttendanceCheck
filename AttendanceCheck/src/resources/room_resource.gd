extends Resource
class_name RoomResource


@export var name : String
## Key : student_id, Value: student_name
@export var masterlist : Dictionary[String, String]
## Key : Unix, Value: {student_id : is_present}
@export var attendance_history : Dictionary[String,Dictionary]
