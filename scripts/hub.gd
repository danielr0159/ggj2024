extends Node2D

const MINIGAMES : Array[PackedScene] = [
	preload("res://minigames/umbrella.tscn"),
	preload("res://minigames/drive.tscn"),
	preload("res://minigames/duel.tscn"),
]

var difficulty : int = 0
var unused_minigames : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in MINIGAMES.size():
		unused_minigames.push_back(i)
	_run_minigame()

func _next() -> void:
	difficulty += 1
	_run_minigame()
	
func _run_minigame() -> void:
	if unused_minigames.size() == 0:
		return
	var which : int = randi_range(0, unused_minigames.size()-1)
	var game : int = unused_minigames[which]
	unused_minigames.remove_at(which)
	var minigame : Minigame = MINIGAMES[game].instantiate()
	minigame.difficulty = difficulty
	minigame.next.connect(self._next)
	add_child(minigame)
