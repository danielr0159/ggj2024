extends Node2D
class_name BadgeScreen

signal complete

@export var badge : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("badge_receive")
	await animation_player.animation_finished
	complete.emit()
