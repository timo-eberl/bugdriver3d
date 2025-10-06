extends Control
class_name ScoreParticle

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func emit() -> void:
	randomize()
	var random = randi_range(0, 2)
	
	animation_player.play(str("emit_" + str(random)))
	
	await animation_player.animation_finished
	
	queue_free()
