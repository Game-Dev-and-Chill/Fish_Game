extends Node

var fullscreen: bool = false


func _unhandled_input(_event: InputEvent) -> void:
    # handle fullscreen anywhere
    if Input.is_action_just_pressed("f11") and fullscreen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        fullscreen = false
        
    elif Input.is_action_just_pressed("f11") and !fullscreen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        fullscreen = true
