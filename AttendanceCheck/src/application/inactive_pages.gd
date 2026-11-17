@icon("res://addons/at-icons/animation/layers.svg")
extends Node
class_name InactivePages
## Handles:
## - Hide pages when deactivated.

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.page_request_deactivate, _on_page_request_deactivate)
func _ready() -> void:
	HidePages()
#region Listeners
func _on_page_request_deactivate(page : PageCanva) -> void:
	DeactivatePage(page)
#endregion
#region Local
## Reparents page to self and hides it.
func DeactivatePage(page : PageCanva) -> void:
	if (page.get_parent() != self):
		page.reparent(self)
		page.visible = false
	pass
## Make all 'PageCanva' type children hidden.
func HidePages() -> void:
	for child_node : Node in get_children():
		if (child_node is PageCanva):
			child_node.visible = false
	pass
#endregion
