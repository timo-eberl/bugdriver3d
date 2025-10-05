extends Node

@export var min_lifetime: float = 2.0
@export var max_lifetime: float = 5.0

func _ready():
	randomize()
	var random_lifetime: float = randf_range(min_lifetime, max_lifetime)
	await get_tree().create_timer(random_lifetime).timeout
	queue_free()
