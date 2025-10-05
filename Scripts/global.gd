extends Node

var fullscreen_enabled := false

var highscore := 0
var bug_count := 0


func _ready() -> void:
	load_highscore()


func save_highscore() -> void:
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	
	file.store_var(highscore)
	file.close()


func load_highscore() -> void:
	var score = null
	var file = null
	if FileAccess.file_exists("user://savegame.data"):
		file = FileAccess.open("user://savegame.data", FileAccess.READ)
	
		score = file.get_var()
	
	else:
		file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
		
		score = 0
	
	if score == null:
		highscore = 0
	else:
		highscore = score
	file.close()
