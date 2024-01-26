extends Node2D
class_name Finger

const FINGER_WIDTH : float = 40
const MAX_HEIGHT : float = 650

@export var move_speeds : Array[float] = [10]
@export var move_speeds_times : Array[float] = [1]
@export var retreat_speed : float = 10
@export var retreat_time : float = 1
var current_move : int = 0
var current_move_time : float = 0
var retreating : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent) -> void:
	if retreating > 0:
		return
	var mouse_event := event as InputEventScreenTouch
	if mouse_event != null && mouse_event.pressed:
		if mouse_event.position.x < position.x || mouse_event.position.x > position.x + FINGER_WIDTH:
			return
		if mouse_event.position.y < position.y:
			return
		retreating = retreat_time

func _physics_process(delta: float) -> void:
	if retreating > 0:
		retreating = maxf(0, retreating-delta)
		position.y += retreat_speed*delta
	else:
		current_move_time += delta
		while current_move_time > move_speeds_times[current_move]:
			current_move_time -= move_speeds_times[current_move]
			current_move += 1
			current_move %= move_speeds_times.size()
		position.y -= move_speeds[current_move]*delta
	position.y = clampf(position.y, 0, MAX_HEIGHT)
