extends Node2D
class_name Minigame

@export var difficulty : int = 0
@onready var button : Button = $Button
@onready var anim : AnimationPlayer = $AnimationPlayer
var state : int = 0
var sigdone : SigDone = SigDone.new()

signal lose
signal next

func _ready() -> void:
	button.grab_focus()
	button.pressed.connect(self._action)
	anim.play("enter")
	anim.seek(0, true, true)
	await anim.animation_finished
	state = 1
	minigame_start()

func _physics_process(delta: float) -> void:
	if state != 1:
		if state == 2:
			if prewin_process(delta):
				state = 3
				sigdone.done.emit()
		if state == 3:
			if win_process(delta):
				state = 4
				sigdone.done.emit()
		return
	minigame_process(delta)

func minigame_start() -> void:
	pass

func minigame_stop() -> void:
	pass

func minigame_process(_delta: float) -> void:
	pass

func prewin_process(_delta: float) -> bool:
	return true

func win_process(_delta: float) -> bool:
	return true

func _action() -> void:
	if state == 1:
		action()

func action() -> void:
	pass

func do_win() -> void:
	if state != 1:
		return
	state = 2
	minigame_stop()
	if state < 3:
		await sigdone.done
	anim.play("win")
	await anim.animation_finished
	if state < 4:
		await sigdone.done
	next.emit()
	anim.play("exit")
	await anim.animation_finished
	queue_free()

func do_lose() -> void:
	if state != 1:
		return
	state = 0
	minigame_stop()
	anim.play("lose")
	await anim.animation_finished
	lose.emit()
	queue_free()

class SigDone:
	signal done
