extends VehicleBody3D

signal bug_collected

@onready var backwheel_1: VehicleWheel3D = $Wheel3
@onready var backwheel_2: VehicleWheel3D = $Wheel4

@export var engine_force_value := 40.0

@export var STEER_SPEED := 10
@export var STEER_LIMIT := 0.4
@export var BRAKE_STRENGTH := 2.0

@export var MAX_SPEED := 5.0

@export_range(0.0, 1.0, 0.1) var drift_friction_slip := 0.7
@export_range(0.0, 1.0, 0.1) var backwheel_friction_slip := 1.0
@export_range(0.0, 1.0, 0.1) var drift_steer_mult := 1.5

@export var damping_factor := 0.7
var slowdown_timer := 0.0

@export var engine_force_curve : Curve

#var previous_speed := linear_velocity.length()
var _steer_target := 0.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("accelerate"):
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = engine_force_value
	else: 
		engine_force = 0.0
	
	if Input.is_action_pressed("reverse"):
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 10.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH

	
	_steer_target = Input.get_axis("turn_right", "turn_left")
	_steer_target *= STEER_LIMIT
	
	if Input.is_action_just_pressed("brake"):
		backwheel_1.wheel_friction_slip = drift_friction_slip
		backwheel_2.wheel_friction_slip = drift_friction_slip
		
	if Input.is_action_pressed("brake"):
		_steer_target *= drift_steer_mult;
		
	if Input.is_action_just_released("brake"):
		backwheel_1.wheel_friction_slip = backwheel_friction_slip
		backwheel_2.wheel_friction_slip = backwheel_friction_slip
	
	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)
	
	if 	Input.is_action_pressed("accelerate") or \
		Input.is_action_pressed("reverse"):
			slowdown_timer = linear_velocity.length()
	elif slowdown_timer > 0.0:
		engine_force = 0.0
		slowdown_timer -= delta * damping_factor
	else:
		engine_force = 0.0
		set_linear_velocity(Vector3.ZERO)


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	linear_velocity = linear_velocity.limit_length(MAX_SPEED)


#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#if previous_speed > state.linear_velocity.length() and state.linear_velocity.length() <= 0.5: 
		#state.set_linear_velocity(Vector3.ZERO)
		##print("happens")
#
	#previous_speed = state.linear_velocity.length()


func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is Bug:
		emit_signal("bug_collected")
		var bug = body as Bug
		bug.on_collection()
