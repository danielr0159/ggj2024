extends Minigame
class_name UmbrellaMinigame

const PIG_SPEED : float = 150.0
const PIG_WALK_TIME : float = 0.1
const CAT_MIN_SPEED : float = 10.0
const CAT_MAX_SPEED : float = 100.0
const CAT_MAX_ACCEL : float = 200.0
const CAT_FINISH : float = 972.0
const UMBRELLA_SIZE : Array[float] = [
	120.0,
	110.0,
	100.0,
	90.0,
	80.0,
	70.0,
	65.0,
	60.0,
	55.0,
	50.0,
	45.0,
	40.0,
	35.0,
]

@onready var pig : Node2D = $Pig
@onready var cat : Node2D = $Cat
@onready var umbrella_scale : Node2D = $Pig/Umbrella/Scale
var pig_walktime : float = 0
var cat_speed : float = randf_range(CAT_MIN_SPEED, CAT_MAX_SPEED)
var cat_accel : Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var cat_accel_index : int = 0
var umbrella_size : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	umbrella_size = UMBRELLA_SIZE[difficulty]
	umbrella_scale.scale = Vector2(umbrella_size/UMBRELLA_SIZE[0], 1)
	for i in cat_accel.size():
		cat_accel[i] = randf_range(-CAT_MAX_ACCEL, CAT_MAX_ACCEL)

func win_process(delta: float) -> bool:
	pig.position.x += PIG_SPEED*delta
	if pig.position.x > CAT_FINISH:
		pig.position.x = CAT_FINISH
		return true
	return false

func minigame_process(delta: float) -> void:
	if pig_walktime > 0:
		pig_walktime = max(0, pig_walktime-delta)
		pig.position.x = min(pig.position.x+PIG_SPEED*delta, CAT_FINISH)
	cat.position.x += cat_speed*delta
	cat_accel[cat_accel_index] = randf_range(-CAT_MAX_ACCEL, CAT_MAX_ACCEL)
	cat_accel_index += 1
	cat_accel_index %= cat_accel.size()
	var cat_accel_sum : float = 0
	for a in cat_accel:
		cat_accel_sum += a
	cat_speed = clampf(cat_speed+cat_accel_sum*delta/cat_accel.size(), CAT_MIN_SPEED, CAT_MAX_SPEED)
	if cat.position.x > CAT_FINISH:
		cat.position.x = CAT_FINISH
		do_win()
		return
	if abs(cat.position.x-pig.position.x) > umbrella_size:
		do_lose()
		return

func action() -> void:
	pig_walktime = PIG_WALK_TIME
