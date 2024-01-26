extends Minigame
class_name DriveMinigame

const SURVIVE_TIME : Array[float] = [
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20
]
const CAR_DRIVE_DIST : float = 1400
const CAR_DRIVE_SPEED : Array[float] = [
	500,
	600,
	700,
	800,
	900,
	1000,
	1200,
	1400,
	1600,
	1800,
	2000
]
const LANE_SIZE : float = 100
const MIN_TIME_SAME_LANE : float = 0.6
const MAX_TIME_SAME_LANE : float = 2
const MIN_TIME_OTHER_LANE : float = 1.5
const MAX_TIME_OTHER_LANE : float = 2

@onready var lane_change: AnimationPlayer = $LaneChange
@onready var collision: Area2D = $YSort/Pig/Collision
@onready var traffic: Node2D = $YSort/Traffic
var current_lane : int = 1
var target_lane : int = 1
var animating : bool = false
var survive_time : float = 0
var next_car : float = 0
var next_car_lane : int = randi_range(0, 2)
var car_drive_speed : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	survive_time = SURVIVE_TIME[difficulty]
	car_drive_speed = CAR_DRIVE_SPEED[difficulty]

func minigame_process(delta: float) -> void:
	if survive_time > delta:
		survive_time -= delta
		if next_car > delta:
			next_car -= delta
		else:
			var car : Node2D = preload("res://entities/drive_car.tscn").instantiate()
			car.position.x = CAR_DRIVE_DIST
			car.position.y = next_car_lane * LANE_SIZE
			traffic.add_child(car)
			var next_lane : int = randi_range(0, 2)
			if next_lane == next_car_lane:
				next_car = randf_range(MIN_TIME_SAME_LANE, MAX_TIME_SAME_LANE)
			else:
				next_car = randf_range(MIN_TIME_OTHER_LANE, MAX_TIME_OTHER_LANE)
			next_car_lane = next_lane
	elif traffic.get_child_count() == 0:
		do_win()
	if target_lane != current_lane && !animating:
		_lane_change()
	for car in traffic.get_children():
		car.position.x -= delta * car_drive_speed
		if car.position.x < 0:
			car.queue_free()
	if collision.get_overlapping_areas().size() > 0:
		for collider in collision.get_overlapping_areas():
			collider.impact()
		do_lose()

func prewin_process(delta: float) -> bool:
	if animating:
		return false
	match current_lane:
		0:
			target_lane = 1
			_lane_change()
			return false
		2:
			target_lane = 3
			_lane_change()
			return false
	return true

func action() -> void:
	target_lane = current_lane + 1
	target_lane &= 3

func _lane_change() -> void:
	animating = true
	current_lane = target_lane
	match target_lane:
		0:
			lane_change.play("1_to_0")
		1:
			lane_change.play("0_to_1")
		2:
			lane_change.play("1_to_2")
		3:
			lane_change.play("2_to_1")
	await lane_change.animation_finished
	animating = false
