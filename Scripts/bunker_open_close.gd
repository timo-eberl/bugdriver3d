extends Area3D

@onready var door : Node3D = $"../BunkerDoor"
@onready var door_2 : Node3D = $"../BunkerDoor2"

var target_x := 0.0

func _process(delta: float) -> void:
	door.position.x = move_toward(door.position.x, target_x, delta * 3.0)
	door_2.position.x = move_toward(door_2.position.x, -target_x, delta * 3.0)

func _on_body_entered(body: Node3D) -> void:
	if body is Bus:
		target_x = 5.0

func _on_body_exited(body: Node3D) -> void:
	if body is Bus:
		target_x = 0.0
