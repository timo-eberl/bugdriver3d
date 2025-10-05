extends Node

@onready var cutscene_scene : PackedScene = preload("res://Scenes/cutscene.tscn")
@onready var ambient_audio_player: AudioStreamPlayer3D = $AmbientAudioPlayer
@onready var fullscreen_button: Button = $FullscreenButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_fullscreen") and Global.fullscreen_enabled:
		Global.fullscreen_enabled = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		fullscreen_button.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(cutscene_scene)


func _on_fullscreen_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Global.fullscreen_enabled = true
	fullscreen_button.visible = false
