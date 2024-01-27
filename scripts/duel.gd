extends Minigame
class_name DuelMinigame

const MIN_TIMING = 1
const MAX_TIMING = 10
const HIT_WINDOW = 0.5

@onready var indicator_animation: AnimationPlayer = $IndicatorAnimation
var hit_timing : float = 0.0
var hit_window : float = HIT_WINDOW
var resolution : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Pig/Pig.level = pig_level
	$ProxyPig/Pig.level = pig_level
	hit_timing = randf_range(MIN_TIMING, MAX_TIMING)

func minigame_start() -> void:
	anim.play("duel")
	indicator_animation.play("notyet")

func minigame_stop() -> void:
	indicator_animation.play("RESET")

func minigame_process(delta: float) -> void:
	if resolution == 1:
		do_lose("draw")
		return
	if resolution == 2:
		do_win()
		return
	if hit_timing > 0:
		if hit_timing > delta:
			hit_timing -= delta
		else:
			hit_timing = 0
			anim.stop(true)
			indicator_animation.play("doit")
	elif hit_window > delta:
		hit_window -= delta
	else:
		do_lose()

func action() -> void:
	if hit_timing > 0:
		resolution = 1
	else:
		resolution = 2
