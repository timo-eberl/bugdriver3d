extends AnimationPlayer

@onready var level_scene : PackedScene = preload("res://Scenes/main.tscn")
@onready var compile_materials : CompileMaterials = $"../CanvasLayer2/CompileMaterials"
@onready var intro_music : AudioStreamPlayer = $"../IntroMusic"
@onready var narration : AudioStreamPlayer = $"../Narration"

var skip_timer = 2.0

func _ready():
	animation_finished.connect(_on_animation_finished)
	compile_materials.finished.connect(start)

func start():
	intro_music.playing = true
	narration.playing = true

func _process(delta: float) -> void:
	skip_timer -= delta
	if skip_timer <= 0:
		if Input.is_action_pressed("boost") or Input.is_action_pressed("magnet"):
			_on_animation_finished("lol")

func _on_animation_finished(animation_name):
	get_tree().change_scene_to_packed(level_scene)
