extends Minigame
class_name CarouselMinigame

const MAX_MATCH_DISTANCE : float = 0.1

@onready var spin: AnimationPlayer = $Spin

var try_match : bool = false

func _ready() -> void:
	super()
	$ProxyPig/Pig.level = pig_level
	spin.play("spin")
	spin.seek(randf_range(0, spin.current_animation_length), true, true)

func minigame_process(_delta: float) -> void:
	if !try_match:
		return
	var dist : float = minf(spin.current_animation_position, spin.current_animation_length-spin.current_animation_position)
	spin.stop(true)
	if dist > MAX_MATCH_DISTANCE:
		do_lose()
		return
	spin.seek(0, true, true)
	do_win()

func action() -> void:
	try_match = true
