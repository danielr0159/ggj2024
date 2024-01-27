extends Node2D
class_name StartScreen

signal start

@export var pig_level: int = 0

@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if pig_level > 0:
		$Start1.visible = false
		$Start2.visible = true
	button.grab_focus()
	button.pressed.connect(self._action)

func _action() -> void:
	start.emit()
	queue_free()
