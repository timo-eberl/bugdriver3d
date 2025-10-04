extends Control
class_name UI

signal round_start
signal round_over

@onready var round_timer: Label = $RoundTimer
@onready var start_round_button: Button = $StartRoundButton
@onready var bug_counter: Label = $BugCounter
@onready var level_music_player: AudioStreamPlayer3D = $"../../LevelMusicPlayer"

@export var round_duration := 60.0

var timer_progress := 0.0
var running := false

func _ready() -> void:
	round_timer.text = str(int(round_duration))


func _process(delta: float) -> void:
	if running:
		if timer_progress >= round_duration:
			_end_round()
		else:
			timer_progress += delta
			round_timer.text = str(int(round_duration - timer_progress))


func _start_round() -> void:
	start_round_button.visible = false
	round_timer.text = str(int(round_duration))
	timer_progress = 0.0
	
	level_music_player.play()
	
	running = true

	emit_signal("round_start")


func _end_round() -> void:
	start_round_button.visible = true
	running = false
	
	level_music_player.stop()
	
	emit_signal("round_over")


func update_bug_count(new_count : int) -> void:
	bug_counter.text = str(new_count)


func _on_start_round_button_pressed() -> void:
	_start_round()


func _on_fullscreen_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
