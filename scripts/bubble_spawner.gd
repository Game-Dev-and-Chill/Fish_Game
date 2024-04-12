extends Node2D

@export var bubble_scene : PackedScene

@onready var bubble_spawn_timer: Timer = $Timer

func _ready() -> void:
	bubble_spawn_timer.timeout.connect(spawn_bubble)

func spawn_bubble():
	var bubble_instance = bubble_scene.instantiate() as Node2D
	add_child(bubble_instance)
	var random_scale = randf_range(.1, .5)
	bubble_instance.scale = Vector2(random_scale, random_scale)
	bubble_instance.global_position = Vector2(randi_range(0, 1900), randi_range(0, 1100))
