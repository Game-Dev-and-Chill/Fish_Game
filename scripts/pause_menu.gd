extends Control


var game_started: bool = false

@export var resume_button: Button
@export var quit_button: Button


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and game_started:
		visible = !visible
		get_tree().paused = !get_tree().paused


func _on_resume_button_pressed():
	visible = false
	get_tree().paused = false


func _on_quit_button_pressed():
	visible = false
	get_tree().paused = false
	
