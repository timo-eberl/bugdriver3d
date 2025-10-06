extends MeshInstance3D

@export_range(0.0, 1.0, 0.01) var charge_amount := 1.0

@onready var sound : AudioStreamWAV = preload("res://Sound/collect_battery.wav")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Bus:
		var bus = body as Bus
		bus.recharge_battery(charge_amount)
		
		AudioPlayer.play_sound(global_position, sound, -12.0, randf_range(0.9, 1.1))
		
		queue_free()
