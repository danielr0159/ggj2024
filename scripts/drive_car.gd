extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func impact() -> void:
	animation_player.play("impact")
