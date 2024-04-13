extends CharacterBody2D

@export var Speed = 300.0
@export var JUMP_VELOCITY = -400.0
@export var direction = 0
@export var gravity = 980

@onready var death_effect = preload("res://scenes/blood_effect.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var parent = get_parent()
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(_delta):
	if parent:
		parent.position.x += -sign(direction - 0.5) * clamp(1 * Speed / 150, 1, 100000)

		if parent.position.x > 1400 or parent.position.x < -200:
			get_tree().current_scene.fish_count -= 1
			parent.queue_free()

	if is_instance_valid(player):

		var color := Color.WHITE

		if (scale.x < player.size && get_tree().current_scene.show_comparison_cheat) || player.has_powerup:
			color = Color.GREEN

		sprite_2d.material.set("shader_parameter/color", color)


func spawn_death_effect():
	var _death_effect = death_effect.instantiate()

	get_parent().add_sibling(_death_effect)

	_death_effect.emitting = true
	_death_effect.global_position = get_parent().global_position
