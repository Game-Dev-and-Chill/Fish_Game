class_name Player extends CharacterBody2D

@export var JUMP_VELOCITY = -400.0
@export var gravity = 980
@export var Speed = 300.0

@export var sprite: Sprite2D
@export var normal_sprite: Texture2D

@export var powerup_sprite: Texture2D
@export var powerup_timer_limit: float = 3.0

@export var audio_eat : AudioStreamPlayer

@onready var collision_polygon_2d: CollisionPolygon2D = $Area/CollisionPolygon2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var main_game: Node = get_node("../..")
@onready var player: Node2D = main_game.get_node("Player")
@onready var enemy_parent: Node2D = main_game.get_node("Enemies")
@onready var score_label: Label = main_game.get_node("Score/Value")
@onready var highscore_label: Label = main_game.get_node("Highscore/HBoxContainer/HighscoreValue")
@onready var main_menu: PanelContainer = main_game.get_node("Main Menu")
@onready var game_over: Control = main_game.get_node("game_over")

var alive = true
var size = scale.x
var evolutions = {1.5: false, 2.5: false, 3.5: false}
var old_shader: Color

var has_powerup: bool = false
var powerup_timer: Timer = Timer.new()
var direction : Vector2 = Vector2.ZERO


func _ready():
	var area = get_node("Area") as Area2D
	area.connect("body_entered", _on_body_area_entered)
	area.connect("area_entered", _on_area_area_entered)

	powerup_timer.one_shot = true
	add_child(powerup_timer)
	powerup_timer.timeout.connect(_powerup_timer_timeout)


func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")

	if direction.length() > 0:
		rotation = lerp_angle(rotation, direction.angle(), 0.3)
		if direction.x <= 0:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	

	if direction.length_squared() > 0:
		direction = direction.normalized()
		velocity = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.y = move_toward(velocity.y, 0, Speed)

	move_and_slide()

	global_position.x = clampf(global_position.x, 10, get_viewport_rect().size.x - 10)
	global_position.y = clampf(global_position.y, 10, get_viewport_rect().size.y - 10)


func _powerup_collected():
	powerup_timer.start(powerup_timer_limit)

	if has_powerup:
		return

	has_powerup = true
	sprite.texture = powerup_sprite
	old_shader = sprite.material.get("shader_parameter/color")
	sprite.material.set("shader_parameter/color", Color.WHITE)



func _on_area_area_entered(area):
	if area is Powerup:
		_powerup_collected()


# ...calling timer.start() will already do this...
#func _reset_powerup_timer():
	#print("Powerup timer restarted")

	#if (powerup_timer.time_left > 0):
		#powerup_timer.stop()
		#powerup_timer.start(powerup_timer_limit)

	#else:
	#powerup_timer.start(powerup_timer_limit)


func _powerup_timer_timeout():
	#print("Powerup timer ended")
	has_powerup = false
	sprite.texture = normal_sprite
	sprite.material.set("shader_parameter/color", old_shader)


func _on_body_area_entered(body):
	if (body.is_in_group("powerup")): return

	if body.scale.x < size or has_powerup:
		randomize()
		audio_eat.pitch_scale = randf_range(0.85, 1.25)
		audio_eat.play()

		size *= (1 + ((body.scale.x/ 100)*main_game.game_difficulty_multiplier))

		var new_speed = 540 / (size + 0.8)
		Speed = 5 if new_speed < 5 else new_speed

		score_label.text = str(int((size - 1) * 1000))
		highscore_label.text = str(max(int(highscore_label.text), int(score_label.text)))
		scale = Vector2(size, size)

		evolve_fish()

		body.spawn_death_effect()
		body.get_parent().queue_free()

		get_tree().current_scene.fish_count -= 1

	else:
		get_tree().paused = true
		game_over.show()


func evolve_fish():
	if powerup_timer.time_left:
		await powerup_timer.timeout

	for new_scale in evolutions.keys():
		if scale.x > new_scale and not evolutions[new_scale]:
			animation_player.play(str(new_scale))
			evolutions[new_scale] = true
			break


func back_to_main_menu():
	game_over.hide()
	main_menu.show()

	player.queue_free()

	for child in main_game.powerup_timer.get_children():
		child.queue_free()

	for enemy in enemy_parent.get_children():
		enemy.queue_free()

	if main_game.has_node("Powerup"):
		main_game.get_node("Powerup").queue_free()

	get_tree().paused = false

