extends MeshInstance3D

@export var audio_stream: AudioStreamPlayer3D
@export var sound_list: Array[AudioStream] = []
@export var giblet_scene: PackedScene
@export_range(1, 20, 1) var giblet_count: int = 8
@export var launch_speed_min: float = 3.0
@export var launch_speed_max: float = 7.0

func _ready():
	await get_tree().process_frame
	spawn_giblets()

	var random_index: int = randi_range(0, sound_list.size() - 1)
	var selected_stream: AudioStream = sound_list[random_index]
	
	audio_stream.stream = selected_stream
	
	var random_pitch: float = randf_range(0.9, 1.1)
	audio_stream.pitch_scale = random_pitch
	
	audio_stream.play()
	
	$ParticlesUp.emitting = true
	$ParticlesSide.emitting = true

func spawn_giblets():
	var root_node: Node = get_tree().get_root()
	for i in range(giblet_count):
		var giblet: RigidBody3D = giblet_scene.instantiate()
		giblet.global_transform = global_transform
		root_node.add_child(giblet)
		
		var random_scale: float = randf_range(0.6, 1.0)
		giblet.scale = Vector3(random_scale, random_scale, random_scale)
		
		var upward_speed: float = randf_range(launch_speed_min, launch_speed_max)
		
		var horizontal_spread: float = randf_range(0.5, 10.0)
		var angle: float = randf() * TAU
		var horizontal_velocity: Vector3 = Vector3(cos(angle), 0, sin(angle)) * horizontal_spread
		
		var launch_velocity: Vector3 = Vector3(horizontal_velocity.x, upward_speed, horizontal_velocity.z)
		
		giblet.linear_velocity = launch_velocity
		giblet.angular_velocity = Vector3(randf_range(-15.0, 15.0), randf_range(-15.0, 15.0), randf_range(-15.0, 15.0))
