extends Node3D

@onready var ui : UI = $UI#TODO

var bug_count := 0


func _on_bus_bug_collected() -> void:
	bug_count += 1
	ui.update_bug_count(bug_count)
