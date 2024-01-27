extends Node2D

const WINS_UNTIL_RETRY : int = 2

const MINIGAMES : Array[PackedScene] = [
	preload("res://minigames/umbrella.tscn"),
	preload("res://minigames/drive.tscn"),
	preload("res://minigames/duel.tscn"),
	preload("res://minigames/parachute.tscn"),
	preload("res://minigames/train.tscn"),
]

var difficulty : int = 0
var pig_level : int = 0
var unused_minigames : Array[int] = []
var last_played  : int = -1
var last_died  : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_restart()

func _restart() -> void:
	last_played = -1
	difficulty = 0
	unused_minigames = []
	for i in MINIGAMES.size():
		if i != last_died:
			unused_minigames.push_back(i)
	var screen : StartScreen = preload("res://screens/start.tscn").instantiate()
	screen.pig_level = pig_level
	add_child(screen)
	await screen.start
	var minigame : Minigame = preload("res://minigames/carousel.tscn").instantiate()
	minigame.lose.connect(self._deadscreen)
	minigame.next.connect(self._run_minigame)
	add_child(minigame)

func _next() -> void:
	difficulty += 1
	@warning_ignore("integer_division")
	var new_level : int = min(difficulty/5, 4)
	if pig_level < new_level:
		var screen : BadgeScreen = preload("res://screens/badge.tscn").instantiate()
		screen.pig_level = pig_level
		pig_level = new_level
		add_child(screen)
		await screen.complete
	if difficulty >= 30:
		_restart()
	_run_minigame()
	
func _run_minigame() -> void:
	var game : int = last_died
	if game < 0 || difficulty != WINS_UNTIL_RETRY:
		if unused_minigames.size() == 0:
			for i in MINIGAMES.size():
				unused_minigames.push_back(i)
		var which : int = randi_range(0, unused_minigames.size()-1)
		game = unused_minigames[which]
		unused_minigames.remove_at(which)
	last_played = game
	var minigame : Minigame = MINIGAMES[game].instantiate()
	minigame.difficulty = difficulty
	minigame.pig_level = pig_level
	minigame.lose.connect(self._deadscreen)
	minigame.next.connect(self._next)
	add_child(minigame)

func _deadscreen() -> void:
	last_died = last_played
	var screen : DeadScreen = preload("res://screens/dead.tscn").instantiate()
	screen.last_died = last_died
	add_child(screen)
	await screen.complete
	_restart()
