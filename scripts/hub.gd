extends Node2D

var difficulty : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var minigame : Minigame = preload("res://minigames/umbrella.tscn").instantiate()
	minigame.next.connect(self._next)
	add_child(minigame)


func _next() -> void:
	difficulty += 1
	var minigame : Minigame = preload("res://minigames/umbrella.tscn").instantiate()
	minigame.difficulty = difficulty
	minigame.next.connect(self._next)
	add_child(minigame)
