extends Resource
class_name RoomResource

## Key : student_id, Value: student_name
@export var masterlist : Dictionary[String, String]
## Key : date, Value: {student_id : is_present}
@export var attendance : Dictionary[Dictionary,Dictionary]
