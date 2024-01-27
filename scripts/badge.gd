extends Node2D
class_name BadgeScreen

signal complete

@export var pig_level : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$Pig.level = pig_level
	animation_player.play("badge_receive")
	await animation_player.animation_finished
	complete.emit()
	animation_player.play("exit")
	await animation_player.animation_finished
	queue_free()
