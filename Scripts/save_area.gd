extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Bug:
		var bug := body as Bug
		bug.save(self)
