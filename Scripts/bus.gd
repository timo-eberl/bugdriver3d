extends VehicleBody3D
class_name Bus

signal bug_collected

@onready var wheel: VehicleWheel3D = $Wheel
@onready var wheel_2: VehicleWheel3D = $Wheel2
@onready var backwheel_1: VehicleWheel3D = $Wheel3
@onready var backwheel_2: VehicleWheel3D = $Wheel4
@onready var drift_particles: GPUParticles3D = $DriftParticles
@onready var drift_particles_2: GPUParticles3D = $DriftParticles2
@onready var track_particles: GPUParticles3D = $TrackParticles
@onready var track_particles_2: GPUParticles3D = $TrackParticles2
@onready var track_particles_3: GPUParticles3D = $TrackParticles3
@onready var track_particles_4: GPUParticles3D = $TrackParticles4
@onready var cage_area: Area3D = $CageArea
@onready var boost_particles: GPUParticles3D = $BoostParticles
@onready var magnet_particles: GPUParticles3D = $MagnetParticles
@onready var magnet_force_bottom: Node3D = $MagnetForceBottom
@onready var magnet_force_top: Node3D = $MagnetForceTop

@onready var camera_controller : CameraController = $"../CameraBase"
@onready var bus_starting_pos: Marker3D = $"../BusStartingPos"

@export var engine_force_value := 40.0
@export var engine_force_braking_value := 100.0

@export var acceleration_max_speed : float = 6.0
@export var acceleration_curve : Curve
@export var steering_curve : Curve

@export var STEER_SPEED := 10
@export var STEER_LIMIT := 0.4
@export var BRAKE_STRENGTH := 2.0
@export var DRIFT_BRAKE_STRENGTH := 2.0

@export var MAX_SPEED := 5.0
@export var MUD_SPEED := 5.0
@export var MUD_DECELERATION := 5.0

@export var mushroom_bounce_strength := 500.0

@export_range(0.0, 1.0, 0.1) var drift_friction_slip := 0.7
@export_range(0.0, 1.0, 0.1) var backwheel_friction_slip := 1.0
@export_range(0.0, 5.0, 0.1) var drift_steer_mult := 1.5

@export var damping_factor := 0.7
var slowdown_timer := 3.0

@export var squished_mushroom_scale := Vector3(0.95, 0.95, 0.95)
var active_tweens : Array[Object]

var battery_charge := 1.0 
@export var boost_energy_cost := 0.02
@export var magnet_energy_cost := 0.04
@export var battery_charge_speed := 0.01

@onready var engine_sound: AudioStreamPlayer3D = $EngineSounds
@onready var boost_sound: AudioStreamPlayer3D = $BoostSounds
@onready var mud_sound: AudioStreamPlayer3D = $MudSounds
@onready var magnet_sound: AudioStreamPlayer3D = $MagnetSounds
var boost_sound_target:= -80
var mud_sound_target:= -80
var magnet_sound_target:= -80

@onready var boink_sound : AudioStream = preload("res://Sound/burn.wav")

var is_magnetizing := false

#@export var engine_force_curve : Curve
var status_effects := {
	StatusEffects.StatusEffect.MUD: []
}

var _steer_target := 0.0
var previous_speed := linear_velocity.length()
@export var drift_particle_bias := 0.1

@onready var mud_particles: GPUParticles3D = $MudParticles


func _ready() -> void:
	global_position = bus_starting_pos.global_position
	rotation = bus_starting_pos.rotation

func _physics_process(delta: float) -> void:
	var speed := linear_velocity.length()
	engine_sound.pitch_scale = clampf(speed / 5.0, 0.4, 3.0)
	boost_sound.volume_db = lerpf(boost_sound.volume_db, boost_sound_target, delta * 50)
	magnet_sound.volume_db = lerpf(magnet_sound.volume_db, magnet_sound_target, delta * 50)
	mud_sound.volume_db = lerpf(mud_sound.volume_db, mud_sound_target, delta * 10)
	if Input.is_action_pressed("accelerate"):
		@warning_ignore("confusable_local_declaration")
		var t = speed / acceleration_max_speed
		var acceleration_multiplier = acceleration_curve.sample(t)
		engine_force = engine_force_value * acceleration_multiplier
	else: 
		engine_force = 0.0
		
	
	if Input.is_action_pressed("reverse"):
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_braking_value * BRAKE_STRENGTH * 10.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_braking_value * BRAKE_STRENGTH

	
	_steer_target = Input.get_axis("turn_right", "turn_left")
	var t = speed / acceleration_max_speed
	var steering_multiplier = steering_curve.sample(t)
	_steer_target *= STEER_LIMIT * steering_multiplier
	
	drift_particles.global_position = backwheel_1.global_position
	drift_particles_2.global_position = backwheel_2.global_position
	
	track_particles.global_position = wheel.global_position
	track_particles_2.global_position = wheel_2.global_position
	track_particles_3.global_position = backwheel_1.global_position
	track_particles_4.global_position = backwheel_2.global_position
	
	if Input.is_action_just_pressed("brake"):
		backwheel_1.wheel_friction_slip = drift_friction_slip
		backwheel_2.wheel_friction_slip = drift_friction_slip
		drift_particles.emitting = true
		drift_particles_2.emitting = true
		
	#if Input.is_action_pressed("brake"):
	#	engine_force = max(-engine_force_braking_value * BRAKE_STRENGTH, 0.0)
	
	if  abs(linear_velocity.length() - previous_speed) > drift_particle_bias or \
		speed < 5.0 and not is_zero_approx(speed):
		_steer_target *= drift_steer_mult;
		
		track_particles.emitting = true
		track_particles_2.emitting = true
		track_particles_3.emitting = true
		track_particles_4.emitting = true
	else:
		track_particles.emitting = false
		track_particles_2.emitting = false
		track_particles_3.emitting = false
		track_particles_4.emitting = false
		
	if Input.is_action_just_released("brake"):
		backwheel_1.wheel_friction_slip = backwheel_friction_slip
		backwheel_2.wheel_friction_slip = backwheel_friction_slip
		drift_particles.emitting = false
		drift_particles_2.emitting = false
	
	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)
	
	if 	Input.is_action_pressed("accelerate") or \
		Input.is_action_pressed("reverse") or \
		Input.is_action_pressed("boost") or \
		linear_velocity.length() > 3.0:
			slowdown_timer = linear_velocity.length()
	else:
		engine_force = 0.0
		slowdown_timer = max(-1.0, slowdown_timer - delta * damping_factor)

	previous_speed = linear_velocity.length()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	boost_sound_target = -80
	if Input.is_action_pressed("boost") && battery_charge > boost_energy_cost * get_process_delta_time():
		boost_sound_target = -30
		if not status_effects[StatusEffects.StatusEffect.MUD].is_empty():
			state.apply_central_force((self.global_basis * -Vector3.FORWARD) * 1000.0)
		else:
			state.apply_central_force((self.global_basis * -Vector3.FORWARD) * 2000.0)
		
		battery_charge = max(0.0, battery_charge - boost_energy_cost * get_process_delta_time())
	
	state.linear_velocity = linear_velocity.limit_length(MAX_SPEED)
	if slowdown_timer < 0.0 and linear_velocity.length() < 1.0:
		state.linear_velocity = Vector3.ZERO

	if not status_effects[StatusEffects.StatusEffect.MUD].is_empty():
		state.linear_velocity = linear_velocity.move_toward(linear_velocity.limit_length(MUD_SPEED), state.step * MUD_DECELERATION)
	
	var contact_count = state.get_contact_count()
	for contact in contact_count:
		var colliding_body = state.get_contact_collider_object(contact)
		if colliding_body and colliding_body.is_in_group("Mushroom"):
			AudioPlayer.play_sound(global_position, boink_sound, -13, randf_range(0.9, 1.3), 70)
			var hit_direction = global_position - colliding_body.global_position
			hit_direction.y = 0.0
			hit_direction = hit_direction.normalized()
			state.apply_impulse(hit_direction * mushroom_bounce_strength * linear_velocity.length(), Vector3(0.0, -0.2, 0.0))
			
			if active_tweens.has(colliding_body): break
			
			active_tweens.append(colliding_body)
			
			var tween : Tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_OUT)
			
			var mushroom_scale = colliding_body.get_parent().scale
			
			tween.tween_property(colliding_body.get_parent(), "scale", mushroom_scale * squished_mushroom_scale, 0.075)
			tween.chain().tween_property(colliding_body.get_parent(), "scale", mushroom_scale, 0.075)
			
			await tween.finished
			
			active_tweens.erase(colliding_body)
			
			break


func _process(delta: float) -> void:
	if global_position.y <= -10.0:
		global_position = bus_starting_pos.global_position
		rotation = bus_starting_pos.rotation
	var speed := linear_velocity.length()
	var target_t := minf(1.0, inverse_lerp(0, MAX_SPEED, speed * 1.5))
	var previous := camera_controller.distance_interpolator
	camera_controller.distance_interpolator = lerp(previous, target_t, delta)
	
	boost_particles.emitting = Input.is_action_pressed("boost") && battery_charge > boost_energy_cost * delta
	mud_particles.emitting = !status_effects[StatusEffects.StatusEffect.MUD].is_empty() && speed > 1.0
	
	if  !status_effects[StatusEffects.StatusEffect.MUD].is_empty() && speed > 1.0:
		mud_sound_target = -16
	else: 
		mud_sound_target = -80
	
	is_magnetizing = Input.is_action_pressed("magnet") && battery_charge > magnet_energy_cost * delta
	if is_magnetizing:
		magnet_sound_target = -20
	else:
		magnet_sound_target = -80
		
	magnet_particles.emitting = is_magnetizing
	if is_magnetizing:
		battery_charge = max(0.0, battery_charge - magnet_energy_cost * delta)
	
	if not Input.is_action_pressed("boost") and not is_magnetizing:
		battery_charge = min(1.0, battery_charge + battery_charge_speed * delta)
	
	%UI.update_battery_charge(battery_charge)

func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is Bug:
		emit_signal("bug_collected")
		var bug := body as Bug
		bug.collect(self)

func _on_cage_area_body_entered(body: Node3D) -> void:
	if body is Bug:
		var bug := body as Bug
		bug.stop_collecting()


#func _apply_status_effects() -> void:
	#for effect in status_effects.values():
		#match effect:
			#StatusEffects.StatusEffect.MUD: 
				#linear_velocity = linear_velocity.move_toward(linear_velocity.limit_length(MUD_SPEED), get_process_delta_time())


func add_status_effect(new_effect : StatusEffects.StatusEffect, body : String) -> void: 
	status_effects[new_effect].append(body)
	
func remove_status_effect(effect : StatusEffects.StatusEffect, body : String) -> void: 
	var effect_id = status_effects[effect].find(body)
	status_effects[effect].pop_at(effect_id)
	
func recharge_battery(amount : float) -> void:
	battery_charge = min(1.0, battery_charge + amount)


func _on_actual_cage_area_body_entered(body: Node3D) -> void:
	if body is Bug:
		body.actually_in_cage = true

func _on_actual_cage_area_body_exited(body: Node3D) -> void:
	if body is Bug:
		body.actually_in_cage = false
