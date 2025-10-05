extends MeshInstance3D

@export var area : Area3D


func _ready() -> void:
	area.connect("body_entered", _on_mud_entered)
	area.connect("body_exited", _on_mud_exited)
	

func _on_mud_entered(body : Node3D) -> void:
	if body is Bus:
		body.add_status_effect(StatusEffects.StatusEffect.MUD, self.name)


func _on_mud_exited(body : Node3D) -> void:
	if body is Bus:
		body.remove_status_effect(StatusEffects.StatusEffect.MUD, self.name)
