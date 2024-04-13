extends CharacterBody2D

@export var JUMP_VELOCITY = -400.0
@export var gravity = 980
@export var Speed = 300.0
@export var sprite: Sprite2D

@onready var collision_polygon_2d: CollisionPolygon2D = $Area/CollisionPolygon2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var main_game: Node = get_node("../..")
@onready var player: Node2D = main_game.get_node("Player")
@onready var enemy_parent: Node2D = main_game.get_node("Enemies")
@onready var score_label: Label = main_game.get_node("Score/Value")
@onready var main_menu: PanelContainer = main_game.get_node("Main Menu")
@export var audio_eat : AudioStreamPlayer

var alive = true
var size = scale.x
var evolutions = {1.5: false, 2.5: false, 3.5: false}

func _ready():
	var area = get_node("Area") as Area2D
	area.connect("body_entered", _on_Body_area_entered)

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x > 0:
		if not sprite.flip_h:
			collision_polygon_2d.scale *= -1
		sprite.flip_h = true
	elif direction.x < 0:
		if sprite.flip_h:
			collision_polygon_2d.scale *= -1
		sprite.flip_h = false
	
	if direction.length_squared() > 0:
		direction = direction.normalized()
		velocity = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.y = move_toward(velocity.y, 0, Speed)
	
	move_and_slide()
	
	global_position.x = clampf(global_position.x, 10, get_viewport_rect().size.x - 10)
	global_position.y = clampf(global_position.y, 10, get_viewport_rect().size.y - 10)

func _on_Body_area_entered(body):
	#eat
	if body.scale.x < size:
		randomize()
		audio_eat.pitch_scale = randf_range(0.85, 1.25)
		audio_eat.play()
		size *= (1 + body.scale.x / 100)
		
		var new_speed = 540 / (size + 0.8)
		Speed = 5 if new_speed < 5 else new_speed
		
		score_label.text = str(int((size - 1) * 1000))
		scale = Vector2(size, size)
		
		evolve_fish()
		body.spawn_death_effect()
		body.get_parent().queue_free()
		get_tree().current_scene.fish_count -= 1
		print(get_tree().current_scene.fish_count)
	else: #die
		main_menu.show()
		player.queue_free()
		
		for enemy in enemy_parent.get_children():
			enemy.queue_free()

func evolve_fish():
	for new_scale in evolutions.keys():
		if scale.x > new_scale and not evolutions[new_scale]:
			animation_player.play(str(new_scale))
			evolutions[new_scale] = true
			break
