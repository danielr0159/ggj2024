extends Node2D

signal lose
signal next

const PIG_SPEED : float = 150.0
const PIG_WALK_TIME : float = 0.1
const CAT_MIN_SPEED : float = 10.0
const CAT_MAX_SPEED : float = 100.0
const CAT_MAX_ACCEL : float = 200.0
const CAT_FINISH : float = 800.0
const UMBRELLA_SIZE : Array[float] = [
	120.0
]

@export var difficulty : int = 0
@onready var button : Button = $Button
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var pig : Node2D = $Pig
@onready var cat : Node2D = $Cat
var pig_walktime : float = 0
var cat_speed : float = randf_range(CAT_MIN_SPEED, CAT_MAX_SPEED)
var cat_accel : Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var cat_accel_index : int = 0
var state : int = 0
var umbrella_size : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.grab_focus()
	button.pressed.connect(self._action)
	umbrella_size = UMBRELLA_SIZE[difficulty]
	for i in cat_accel.size():
		cat_accel[i] = randf_range(-CAT_MAX_ACCEL, CAT_MAX_ACCEL)
	anim.play("enter")
	await anim.animation_finished
	state = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if state != 1:
		if state == 2:
			pig.position.x = min(pig.position.x+PIG_SPEED*delta, CAT_FINISH)
		return
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
		state = 2
		next.emit()
		anim.play("exit")
		await anim.animation_finished
		queue_free()
	if abs(cat.position.x-pig.position.x) > umbrella_size:
		state = 0
		anim.play("lose")
		await anim.animation_finished
		lose.emit()
		queue_free()

func _action() -> void:
	pig_walktime = PIG_WALK_TIME
