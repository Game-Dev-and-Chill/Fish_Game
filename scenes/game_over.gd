extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed and not event.is_released():
			get_parent().back_to_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
