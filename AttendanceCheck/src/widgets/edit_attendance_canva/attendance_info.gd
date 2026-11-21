extends Node

@export_group("References")
@export var date_label: Label

func Init(date_key : String) -> void:
	date_label.text = date_key
