@icon("res://addons/at-icons/mesh/layers.svg")
extends CanvasLayer
class_name PageStack
## Handles
## - Page stack behavior on android.
## - Pushes page 'PageCanva' when _on_page_push_request is emitted.
## - Pops page 'PageCanva' when _on_page_pop_front_request is emitted.

@export var entry_page : PageCanva
@export var page_stack : Array[PageCanva]
@export_group("Debug")
@export var push_pages : Array[PageCanva] ## Last index is the front page. First index is the back page.
func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.page_pop_front_request, _on_page_pop_front_request)
	Utils.SafeConnect(EventBus.page_push_request, _on_page_push_request)
func _ready() -> void:
	PushPage(entry_page)
	AddDebugPages()
func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_down")): ## Simulate NOTIFICATION_WM_GO_BACK_REQUEST
		PopFrontPage()
func _notification(what: int) -> void:
	if (what == NOTIFICATION_WM_GO_BACK_REQUEST):
		PopFrontPage()
#region Listeners
func _on_page_pop_front_request():
	PopFrontPage()
func _on_page_push_request(page : PageCanva, passed_data : Dictionary):
	PushPage(page, passed_data)
#endregion
#endregion Global
## Makes page active and push the page in front.
func PushPage(page : PageCanva, passed_data : Dictionary = {}) -> void:
	page_stack.append(page)
	page.reparent(self)
	page.visible = true
	OrderLayerByIndex()
	EventBus.page_pushed.emit(page, passed_data)
	pass
## Pops the front page.
## If all pages are popped the application quits.
func PopFrontPage() -> void:
	if (page_stack.size() > 1):
		var page : PageCanva = page_stack.pop_back()
		EventBus.page_popped.emit(page)
	else: 
		get_tree().quit()
	pass
#endregion
#region Local
## Order the layer by index in 'page_stack'. the last_index in 'page_stack' is the front page.
func OrderLayerByIndex() -> void:
	var layer_num : int = 0
	for page : PageCanva in page_stack:
		page.layer = layer_num
		layer_num += 1
	pass
#endregion
#region Debug
func AddDebugPages() -> void:
	for page : PageCanva in push_pages:
		PushPage(page)
	pass
#endregion
