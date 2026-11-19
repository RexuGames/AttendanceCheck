@icon("res://addons/at-icons/node3d/script.svg")
extends Node


#region Data
@warning_ignore("unused_signal") signal room_edited(room : RoomResource)
@warning_ignore("unused_signal") signal rooms_updated(rooms : Array[RoomResource])
@warning_ignore("unused_signal") signal userdata_loaded(resource : UserdataResource)
@warning_ignore("unused_signal") signal attendance_updated(new_record : Dictionary, date : Dictionary)
@warning_ignore("unused_signal") signal masterlist_updated(new_masterlist : Dictionary)
#endregion

#endregion
#region Page System
## Emitted when page is pushed in Page Stack
@warning_ignore("unused_signal") signal page_pushed(page : PageCanva, passed_data : Dictionary)  
## Emitted when page popped from Page Stack.
@warning_ignore("unused_signal") signal page_popped(page : PageCanva) 
## Emitted when page become inactive.
@warning_ignore("unused_signal") signal page_deactivated(page : PageCanva) 
## Make 'page' inactive. Handled by inactive_pages.gd.
## Emitted by PageCanva.gd when PageCanva hide animation finished.  
@warning_ignore("unused_signal") signal page_request_deactivate(page : PageCanva) 
## Make 'page' active. Handled by page_stack.gd
@warning_ignore("unused_signal") signal page_push_request(page : PageCanva, passed_data : Dictionary) 
## Pops front page in Page Stack. Handled by page_stack.gd
@warning_ignore("unused_signal") signal page_pop_front_request() 
#endregion
