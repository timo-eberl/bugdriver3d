extends Node3D

@onready var ui : UI = $HUD/UI#TODO
@onready var ambient_audio_player: AudioStreamPlayer3D = $AmbientAudioPlayer

var bug_count := 0


func _ready() -> void:
	ambient_audio_player.play()


func _on_bus_bug_collected() -> void:
	bug_count += 1
	ui.update_bug_count(bug_count)


func _on_ui_round_over() -> void:
	ambient_audio_player.play()


func _on_ui_round_start() -> void:
	ambient_audio_player.stop() 
