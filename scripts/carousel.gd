extends Minigame
class_name CarouselMinigame

const MAX_MATCH_DISTANCE : float = 0.1

@onready var spin: AnimationPlayer = $Spin

@export var spin_match_time : float = 0.0

var try_match : bool = false

func _ready() -> void:
	super()
	spin.play("spin")
	spin.seek(randf_range(0, spin.current_animation_length), true, true)

func minigame_process(_delta: float) -> void:
	if !try_match:
		return
	var dist : float = minf(abs(spin_match_time-spin.current_animation_position), spin.current_animation_length-abs(spin_match_time-spin.current_animation_position))
	spin.stop(true)
	if dist > MAX_MATCH_DISTANCE:
		do_lose()
		return
	spin.seek(spin_match_time, true, true)
	do_win()

func action() -> void:
	try_match = true
