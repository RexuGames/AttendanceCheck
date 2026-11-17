extends Node

#region Global
func CreateEditMasterlist(masterlist : Dictionary[String,String], _on_confirmed : Callable) -> void:
	_CreateWidget(
		{
			"masterlist": masterlist
		}, 
		load("res://src/widgets/edit_masterlist_canva/EditMasterlistWidget.tscn"),
		 _on_confirmed)
func CreateEditStudent(name : String, is_adding : bool, _on_confirmed : Callable) -> void:
	_CreateWidget(
		{
			"name" : name,
			"is_adding": is_adding
		},
		load("uid://bibkb4ckjgf16"),
		_on_confirmed)
#endregion

#region Utils
func _CreateWidget(passed_data : Dictionary, widget_packed : PackedScene, _on_edit_confirmed : Callable = Callable()) -> void:
	var new_widget : WidgetCanva = widget_packed.instantiate()
	Utils.SafeConnect(new_widget.edit_confirmed, _on_edit_confirmed)
	add_child(new_widget)
	new_widget.InitWidget(passed_data)
#endregion
