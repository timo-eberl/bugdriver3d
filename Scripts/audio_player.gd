extends Node

func play_sound(pos : Vector3, sound : AudioStreamWAV, volume_db : float = 0.0, pitch_scale : float = 1.0) -> void:
	var audiostream = AudioStreamPlayer3D.new()
	add_child(audiostream)
	audiostream.global_position = pos
	
	audiostream.stream = sound
	audiostream.volume_db = volume_db
	audiostream.pitch_scale = pitch_scale
	audiostream.play()
	
	await  audiostream.finished
	audiostream.queue_free()
	
