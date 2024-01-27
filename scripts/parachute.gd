extends Minigame
class_name ParachuteMinigame

const HORIZONTAL_SPEED : float = 200
const VERTICAL_SPEED : float = 200
const MIN_HEIGHT : float = 150
const MAX_HEIGHT : float = 600
const WIN_POSITION : float = 900
const MAX_POSITION : float = 1000
const TARGET_HEIGHT : float = 400
const FINAL_SPEED : float = 100
const DANGER_MIN : float = 300
const DANGER_MAX : float = 852
const MAX_CART_SHIFT : float = 3.0

@onready var pig: Node2D = $Pig
@onready var collision: Area2D = $Pig/Collision


var going_down : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func minigame_process(delta: float) -> void:
	pig.position.x += HORIZONTAL_SPEED*delta
	if pig.position.x > WIN_POSITION:
		do_win()
		return
	if going_down:
		if pig.position.y + VERTICAL_SPEED*delta > MAX_HEIGHT:
			going_down = !going_down
			pig.position.y -= VERTICAL_SPEED*delta
		else:
			pig.position.y += VERTICAL_SPEED*delta
	else:
		if pig.position.y - VERTICAL_SPEED*delta < MIN_HEIGHT:
			going_down = !going_down
			pig.position.y -= VERTICAL_SPEED*delta
		else:
			pig.position.y -= VERTICAL_SPEED*delta
	if pig.position.x > DANGER_MIN && pig.position.y < DANGER_MAX:
		if collision.get_overlapping_areas().size() > 0:
			do_lose()

func prewin_process(delta: float) -> bool:
	if pig.position.x >= MAX_POSITION:
		pig.position.y = TARGET_HEIGHT
		return true
	pig.position.y += (TARGET_HEIGHT-pig.position.y)*(FINAL_SPEED*delta)/(MAX_POSITION - pig.position.x)
	pig.position.x += FINAL_SPEED*delta
	return false

func action() -> void:
	going_down = !going_down
