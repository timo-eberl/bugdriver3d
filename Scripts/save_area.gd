extends Area3D

signal bug_saved

func _on_body_entered(body: Node3D) -> void:
	if body is Bug:
		emit_signal("bug_saved")
		var bug := body as Bug
		bug.save(self)
