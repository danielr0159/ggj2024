extends Node2D
class_name BadgeScreen

signal complete

@export var pig_level : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boom: AnimatedSprite2D = $Boom
@onready var bg: AnimatedSprite2D = $BG


func _ready() -> void:
	bg.frame = pig_level
	$Frame/Progress.visible = false
	$Pig.level = pig_level
	animation_player.play("badge_receive")
	await animation_player.animation_finished
	if pig_level >= 3:
		return
	complete.emit()
	animation_player.play("exit")
	await animation_player.animation_finished
	queue_free()
