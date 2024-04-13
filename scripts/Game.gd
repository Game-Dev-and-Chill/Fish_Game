extends Node

@export var player_fish: PackedScene
@export var enemy_fish: PackedScene
@export var enemies_parent: Node2D
@export var score_label: Label
@export var highscore_label: Label
@export var main_menu: PanelContainer
@export var animiation_player: AnimationPlayer

const powerup: PackedScene = preload("res://scenes/Powerup.tscn")

signal game_started

var player
var body
var spawning = false
var fish_count = 0
var highscore = 0

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(value)
		highscore = 5
		highscore_label.text = str(highscore)

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	animiation_player.play("fade_in")
	score_label.text = str(0)

func _physics_process(_delta):
	if is_instance_valid(player):
		body = player.get_node("Body")
		
		if body.alive and not spawning:
			#add enemies
			_spawn_enemy_fish()
			spawning = true

func game_start():
	emit_signal("game_started")
	player = player_fish.instantiate()
	player.global_position = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height")) / 2
	add_child(player)
	
	spawn_powerup()

func _on_start_button_pressed():
	main_menu.hide()
	score_label.text = "0"
	game_start()

func _on_quit():
	get_tree().quit()

func _spawn_enemy_fish():
	if fish_count < 60:
		var spawn_enemy_fish = enemy_fish.instantiate()
		var enemy_body = spawn_enemy_fish.get_node("Body")
		var fish_size = randf_range(0.1, clamp(3 * body.size, 5, 20))
		enemy_body.scale = Vector2(fish_size, fish_size)
		
		var side = randi_range(1, 2)
		enemy_body.direction = side
		var rand_x = 0
		if side == 2:
			rand_x = randf_range(1300, 1400)
		else:
			rand_x = randf_range(-200, -100)
		
		spawn_enemy_fish.position = Vector2(rand_x, randf_range(20, 620))
		spawn_enemy_fish.scale.x *= sign(side - 1.5)
		enemies_parent.add_child(spawn_enemy_fish)
		
		var new_speed = 540 / (enemy_body.scale.x + 0.8)
		enemy_body.Speed = 5 if new_speed < 50 else new_speed
		
		var timer_duration = min(5 - (5 * Time.get_ticks_msec() / 7200000.0), 5.0)
		
		if fish_count < 40:
			timer_duration = 1
		
		await get_tree().create_timer(timer_duration).timeout
		
		spawning = false
		fish_count += 1

func spawn_powerup():
	var timer = Timer.new()
	add_child(timer)
	
	timer.start(randf_range(30, 100))
	
	timer.timeout.connect(func():
		var p = powerup.instantiate()
		p.position = Vector2(randf_range(0, 500), 0)
		add_child(p)
		timer.queue_free()
		spawn_powerup()	
	)
