extends Area3D

signal bug_saved(type: Bug.BugType)

func _on_body_entered(body: Node3D) -> void:
	if body is Bug:
		var bug := body as Bug
		if !bug.saved_idle:
			emit_signal("bug_saved", bug.type)
		bug.save_idle()
