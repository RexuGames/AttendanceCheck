@icon("res://addons/at-icons/control/script.svg")
extends Node

func SafeConnect(event : Signal, callback : Callable):
	if (event.is_connected(callback)): return
	event.connect(callback) 
