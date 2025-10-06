extends Control
class_name ScoreParticle

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func emit() -> void:
	animation_player.play("emit")
	
	await animation_player.animation_finished
	
	queue_free()
