extends CharacterBody2D

@export var Speed = 300.0
@export var JUMP_VELOCITY = -400.0
@export var direction = 1
@export var gravity = 980

@onready var death_effect = preload("res://scenes/blood_effect.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var parent = get_parent()

func _physics_process(_delta):
	if parent:
		parent.position.x += -sign(direction - 1.5) * clamp(1 * Speed / 150, 1, 100000)
		
		if parent.position.x > 940 or parent.position.x < -940:
			get_tree().current_scene.fish_count -= 1
			parent.queue_free()

func spawn_death_effect():
	var _death_effect = death_effect.instantiate()
	get_parent().get_parent().add_child(_death_effect)
	_death_effect.emitting = true
	_death_effect.global_position = get_parent().global_position
