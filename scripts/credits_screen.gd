extends Control

@export var credits_back_button: Button
@export var score_label: HBoxContainer
@export var highscore_label: MarginContainer

func _ready() -> void:
	credits_back_button.pressed.connect(_on_back_button_pressed)


func _on_back_button_pressed():
	hide()
	highscore_label.show()
	score_label.show()
