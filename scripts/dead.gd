extends Node
class_name DeadScreen

signal complete

@export var last_died : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("dead")
	await animation_player.animation_finished
	complete.emit()
	queue_free()
