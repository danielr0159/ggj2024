extends Node2D
class_name StartScreen

signal start

@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.grab_focus()
	button.pressed.connect(self._action)

func _action() -> void:
	start.emit()
	queue_free()
