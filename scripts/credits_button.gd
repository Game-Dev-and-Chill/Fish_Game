extends Button

@export var credits_screen: Control
@export var score_label: HBoxContainer
@export var highscore_label: MarginContainer

func _ready() -> void:
	pressed.connect(_on_credits_button_pressed)


func _on_credits_button_pressed():
	credits_screen.show()
	highscore_label.hide()
	score_label.hide()
