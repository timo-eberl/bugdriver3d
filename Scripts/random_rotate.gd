extends Node3D

@export var collision_box : GPUParticlesCollisionBox3D
@export var battery_particles : GPUParticles3D

@export var shake_animation: AnimationPlayer
@export var pulse_animation: AnimationPlayer

@export var battery: Node3D

@export var speed := 1.0

var filled_amount := 1.0

var draining := false

func _process(delta: float) -> void:
	get_child(0).rotate_y(delta * speed)
	
	if battery_particles:
		battery_particles.emitting = draining
	
	if shake_animation:
		if draining:
			shake_animation.play("shake")
			var collision_box_pos_y = 1.8 - (1.0 - filled_amount) * 3.0
			collision_box.position.y = collision_box_pos_y
			
		else:
			shake_animation.pause()
	
	if pulse_animation:
		if is_equal_approx(filled_amount, 1.0):
			pulse_animation.play("pulse")
		else:
			pulse_animation.pause()
