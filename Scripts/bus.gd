extends VehicleBody3D

@export var engine_force_value := 40.0

@export var STEER_SPEED := 10
@export var STEER_LIMIT := 0.4
@export var BRAKE_STRENGTH := 2.0

var previous_speed := linear_velocity.length()
var _steer_target := 0.0


func _physics_process(delta: float) -> void:
	_steer_target = Input.get_axis("turn_right", "turn_left")
	_steer_target *= STEER_LIMIT

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
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH
		
	
	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)

	previous_speed = linear_velocity.length()
