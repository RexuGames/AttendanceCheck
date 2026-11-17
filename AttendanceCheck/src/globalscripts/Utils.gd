@icon("res://addons/at-icons/control/script.svg")
extends Node

func SafeConnect(event : Signal, callback : Callable):
	if (event.is_connected(callback)): return
	event.connect(callback) 

## Frees all children.
func RemoveChildren(parent : Node, ...exceptions : Array):
	for node : Node in parent.get_children():
		if (exceptions.has(node)): continue
		node.queue_free()
