extends Node2D

@export var level : int:
	set(value):
		$Root/Top/PigTopL1.visible = (value == 0)
		$Root/Top/PigTopL2.visible = (value == 1)
		$Root/Top/PigTopL3.visible = (value == 2)
		$Root/Top/PigTopL4.visible = (value == 3)
		$Root/Top/PigTopL5.visible = (value == 4)
	get:
		if $Root/Top/PigTopL5.visible:
			return 4
		if $Root/Top/PigTopL4.visible:
			return 3
		if $Root/Top/PigTopL3.visible:
			return 2
		if $Root/Top/PigTopL2.visible:
			return 1
		return 0

@export var animation : String:
	set(value):
		$AnimationPlayer.play(value)

func level_up():
	level = level + 1
