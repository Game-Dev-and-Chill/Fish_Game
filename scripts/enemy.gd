extends CharacterBody2D


var Speed = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player

@onready var parent = get_parent()


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	if parent:
		if direction == 1:
			parent.position.x += clamp(1*Speed/150, 1, 100000)
			if parent.position.x > 940:
				get_tree().current_scene.fish_count -= 1
				parent.queue_free()
		else:
			parent.position.x -= clamp(1*Speed/150, 1, 100000)
			if parent.position.x < -940:
				get_tree().current_scene.fish_count -= 1
				parent.queue_free()
