extends Node

var last_rescue_timer = 0.0

var last_blip_timer = 0.0

func _process(delta: float) -> void:
	if last_rescue_timer > 0:
		last_rescue_timer -= delta
	if last_blip_timer > 0:
		last_blip_timer -= delta

func play_sound(pos : Vector3, sound : AudioStreamWAV, volume_db : float = 0.0, pitch_scale : float = 1.0, unit_size: float = 70) -> void:
	var audiostream = AudioStreamPlayer3D.new()
	add_child(audiostream)
	audiostream.global_position = pos
	
	audiostream.stream = sound
	audiostream.volume_db = volume_db
	audiostream.pitch_scale = pitch_scale
	audiostream.unit_size = unit_size
	audiostream.play()

	
	await  audiostream.finished
	audiostream.queue_free()
	

func play_sound_global(sound : AudioStreamWAV, volume_db : float = 0.0, pitch_scale : float = 1.0) -> void:
	var audiostream = AudioStreamPlayer.new()
	add_child(audiostream)
	
	audiostream.stream = sound
	audiostream.volume_db = volume_db
	audiostream.pitch_scale = pitch_scale
	audiostream.play()

	
	await  audiostream.finished
	audiostream.queue_free()

func play_rescue_sound(sound : AudioStreamWAV) -> void:
	if last_rescue_timer <= 0:
		last_rescue_timer = 2.0
		var audiostream = AudioStreamPlayer3D.new()
		add_child(audiostream)
		audiostream.global_position = Vector3(-40, 1, 40)
		
		audiostream.stream = sound
		audiostream.volume_db = -15
		audiostream.pitch_scale = randf_range(1.1, 1.5)
		audiostream.unit_size = 50
		audiostream.play()

		
		await  audiostream.finished
		audiostream.queue_free()

func play_blip_sound(sound : AudioStreamWAV, volume_db : float = 0.0, pitch_scale : float = 1.0) -> void:
	if last_blip_timer <= 0:
		last_blip_timer = 2.0
		play_sound_global(sound, volume_db, pitch_scale)
