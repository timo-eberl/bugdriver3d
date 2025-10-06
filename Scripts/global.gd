extends Node

var fullscreen_enabled := false

var highscore := 0
var score := 0


func _ready() -> void:
	load_highscore()


func save_highscore() -> void:
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	file.store_var(highscore)
	file.close()


func load_highscore() -> void:
	var lscore = null
	var file = null
	if FileAccess.file_exists("user://savegame.save"):
		file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
		lscore = file.get_var()
		
		highscore = lscore
		file.close()	
	else:
		save_highscore()
		
		lscore = 0
	
