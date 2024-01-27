extends Minigame
class_name TrainMinigame

const MIN_TIME_TO_TRAIN : float = 1
const MAX_TIME_TO_TRAIN : float = 5

@onready var jump: AnimationPlayer = $Jump
@onready var collision: Area2D = $Pig/Collision
@onready var train_pass: AnimationPlayer = $TrainPass

var jumped : bool = false
var jumping : bool = false
var jump_finished : bool = false
var time_to_train : float = randf_range(MIN_TIME_TO_TRAIN, MAX_TIME_TO_TRAIN)

func minigame_process(delta: float) -> void:
	if !jumped && jumping:
		jumped = true
		jump.play("jump")
		await jump.animation_finished
		jump_finished = true
		return
	if jump_finished:
		do_lose()
		return
	if jumped:
		if collision.get_overlapping_areas().size() > 0:
			do_win()
			return
	if time_to_train > delta:
		time_to_train -= delta
	else:
		time_to_train = randf_range(MIN_TIME_TO_TRAIN, MAX_TIME_TO_TRAIN)
		train_pass.play("pass")

func action() -> void:
	jumping = true
