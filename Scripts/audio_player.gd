extends Node

func play_sound(sound : AudioStreamWAV, pos : Vector3) -> void:
	var audiostream = AudioStreamPlayer3D.new()
	add_child(audiostream)
	audiostream.global_position = pos
	
	audiostream.stream = sound
	audiostream.play()
	
	await  audiostream.finished
	audiostream.queue_free()
	
