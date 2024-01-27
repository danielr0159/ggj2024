extends Node2D
class_name StartScreen

signal start

@export var pig_level: int = 0

@onready var button: Button = $Button
@onready var bg: AnimatedSprite2D = $BG


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.frame = pig_level
	button.grab_focus()
	button.pressed.connect(self._action)

func _action() -> void:
	start.emit()
	queue_free()
