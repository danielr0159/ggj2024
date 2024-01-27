extends Node2D
class_name ParachuteMinigameCart

const MIN_SWING_TIME = 1.0
const MAX_SWING_TIME = 5.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swinger: AnimationPlayer = $Swinger

@export var start_time : float = 0.0
@export var reverse : bool = false

var swing_time : float = randf_range(MIN_SWING_TIME, MAX_SWING_TIME)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("reverse" if reverse else "move")
	animation_player.seek(start_time, true, true)

func _physics_process(delta: float) -> void:
	if swing_time > delta:
		swing_time -= delta
	else:
		swing_time = randf_range(MIN_SWING_TIME, MAX_SWING_TIME)
		swinger.play("swing")
