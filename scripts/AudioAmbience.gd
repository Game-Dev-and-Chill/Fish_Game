extends AudioStreamPlayer

@export var timer : Timer
@export var max_time : float
@export var min_time : float
@onready var audio_ambient = [preload("res://audio/woosh1.mp3"), preload("res://audio/woosh2.mp3"), preload("res://audio/woosh3.mp3")]
var _randomized_interval : float


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    randomize()
    _randomized_interval = randf_range(min_time, max_time)
    assert(max_time > min_time)
    assert(max_time > 0)
    assert(min_time > 0)
    timer.wait_time = _randomized_interval
    timer.timeout.connect(_on_timer_timeout)
    timer.start()

func _on_timer_timeout() -> void:
    stream = audio_ambient.pick_random()
    _randomized_interval = randf_range(min_time, max_time)
    timer.wait_time = _randomized_interval
    play()
