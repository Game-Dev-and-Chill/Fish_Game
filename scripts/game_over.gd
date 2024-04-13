extends Control

@export var animation_player: AnimationPlayer

func _ready() -> void:
	animation_player.play("blink_text")
