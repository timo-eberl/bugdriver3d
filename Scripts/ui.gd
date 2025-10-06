extends Control
class_name UI

signal round_start
signal round_over

@onready var round_timer: Label = $RoundTimer
#@onready var restart_round_button: Button = $RestartRoundButton
@onready var round_over_ui: Control = $RoundOverUI
@onready var score_label: Label = $RoundOverUI/RestartLabel/VBoxContainer/ScoreLabel
@onready var highscore_label: Label = $RoundOverUI/RestartLabel/VBoxContainer/HighscoreLabel

@onready var fullscreen_button: Button = $FullscreenButton

@onready var bug_counter: Label = $BugCounter
@onready var level_music_player: AudioStreamPlayer3D = $"../../LevelMusicPlayer"

@onready var battery_mesh : MeshInstance3D = $LeftSubViewportContainer/SubViewport/HUD3DLeft/Rotation/battery/Cylinder2
@onready var battery_material : ShaderMaterial = battery_mesh.get_active_material(0)

@export var round_duration := 60.0

var timer_progress := 0.0
var running := false

func _ready() -> void:
	round_timer.text = str(int(round_duration))
	_start_round()
	
	if Global.fullscreen_enabled: fullscreen_button.visible = false


func _process(delta: float) -> void:
	if running:
		if timer_progress >= round_duration:
			_end_round()
		else:
			timer_progress += delta
			round_timer.text = str(int(round_duration - timer_progress))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart") and not running:
		get_tree().reload_current_scene()
		Global.score = 0
	if event.is_action_pressed("exit_fullscreen") and Global.fullscreen_enabled:
		Global.fullscreen_enabled = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		fullscreen_button.visible = true


func _start_round() -> void:
	round_over_ui.visible = false
	round_timer.text = str(int(round_duration))
	timer_progress = 0.0
	
	level_music_player.play()
	
	running = true

	emit_signal("round_start")


func _end_round() -> void:
	round_over_ui.visible = true
	running = false
	
	level_music_player.stop()
	
	score_label.text = str("Score: ", Global.score)
	
	if Global.highscore < Global.score:
		Global.highscore = Global.score
		Global.save_highscore()
	
	highscore_label.text = str("Highscore: ", Global.highscore)
	
	emit_signal("round_over")


func update_bug_count() -> void:
	bug_counter.text = str(Global.score)


func _on_fullscreen_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Global.fullscreen_enabled = true
	fullscreen_button.visible = false


func _on_small_save_area_bug_saved(type: Bug.BugType) -> void:
	match type:
		Bug.BugType.LADYBUG:
			Global.score += 50
		Bug.BugType.BEETMAN:
			Global.score += 200
	update_bug_count()


func update_battery_charge(new_charge : float) -> void:
	battery_material.set_shader_parameter("fill", new_charge)
