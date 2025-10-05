extends Control

@onready var level_scene : PackedScene = preload("res://Scenes/main.tscn")
@onready var fullscreen_button: Button = $FullscreenButton


func _ready() -> void:
	if Global.fullscreen_enabled: fullscreen_button.visible = false


func _enter_tree() -> void:
	await get_tree().create_timer(3.0).timeout
	
	get_tree().change_scene_to_packed(level_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_fullscreen") and Global.fullscreen_enabled:
		Global.fullscreen_enabled = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		fullscreen_button.visible = true

func _on_fullscreen_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Global.fullscreen_enabled = true
	fullscreen_button.visible = false
