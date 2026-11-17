@icon("res://addons/at-icons/node/window.svg")
extends CanvasLayer
class_name PageCanva
## Behaves like page system in android
## Can be pushed and popped.

@export var destroy_on_popped : bool = false
@export_group("Page Animation")
@export var page_animation : AnimationPlayer
@export var page_pop_anim : String = "hide"
@export var page_push_anim : String = "show"

func _enter_tree() -> void:
	Utils.SafeConnect(EventBus.page_popped, _on_page_popped)
	Utils.SafeConnect(EventBus.page_pushed , _on_page_pushed)
	Utils.SafeConnect(EventBus.page_deactivated, _page_deactivated)
#region Listeners
func _on_page_popped(page : PageCanva) -> void:
	if (page != self): return
	if (destroy_on_popped): call_deferred("queue_free"); return
	
	await _play_page_animation(page_pop_anim)
	EventBus.page_request_deactivate.emit(self)
func _on_page_pushed(page : PageCanva, _passed_data : Dictionary) -> void:
	_page_activated()
	if (page == self):
		_play_page_animation(page_push_anim)
#endregion 
#region Overridables
## Page becomes active
func _page_activated() -> void: pass 
## Page becomes inactive.
func _page_deactivated() -> void: pass 
#endregion
#region Utils
func _play_page_animation(anim_name : String) -> void:
	if (page_animation != null):
		if (page_animation.has_animation(anim_name)):
			page_animation.play(anim_name)
			await page_animation.animation_finished
		else:
			Log.warn("Animation name is invalid!")
#endregion
