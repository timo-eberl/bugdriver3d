extends RigidBody3D
class_name Bug

@export var physics_material_initial : PhysicsMaterial
@export var physics_material_in_car : PhysicsMaterial
@export var physics_material_saved : PhysicsMaterial
@export var splatter_scene : PackedScene
@export var type : BugType

enum BugType { LADYBUG, BEETMAN }

var m_bus : Bus
var save_location : Node3D

var actually_in_cage := false

# state
var idle := true
var lerping := false
var in_car := false
var save_lerping := false
var saved_idle := false

func collect(bus: Bus) -> void:
	if idle:
		self.custom_integrator = true
		m_bus = bus
		lerping = true
		idle = false
		self.add_collision_exception_with(bus)

func stop_collecting() -> void:
	if lerping:
		lerping = false
		in_car = true
		self.custom_integrator = false
		self.axis_lock_linear_x = false
		self.axis_lock_linear_y = false
		self.axis_lock_linear_z = false
		self.axis_lock_angular_x = false
		self.axis_lock_angular_y = false
		self.axis_lock_angular_z = false
		self.physics_material_override = physics_material_in_car
		self.remove_collision_exception_with(m_bus)

func save(target: Node3D):
	if in_car:
		in_car = false
		save_lerping = true
		self.custom_integrator = true
		self.add_collision_exception_with(m_bus)
		save_location = target

func save_idle():
	if save_lerping:
		save_lerping = false
		saved_idle = true
		self.custom_integrator = false
		self.axis_lock_angular_x = true
		self.axis_lock_angular_y = false
		self.axis_lock_angular_z = true
		self.physics_material_override = physics_material_saved
		self.linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
		self.angular_damp_mode = RigidBody3D.DAMP_MODE_COMBINE
		self.linear_damp = 0.0
		self.angular_damp = 0.0

func _ready() -> void:
	self.physics_material_override = physics_material_initial

func _process(delta: float) -> void:
	if lerping:
		var cage_pos := self.m_bus.cage_area.global_position
		var target := cage_pos + 3.0 * (self.m_bus.global_position - self.global_position)
		var t := inverse_lerp(0.0, 20.0, m_bus.linear_velocity.length())
		t = pow(t, 1.5)
		var lerp_speed := lerpf(1.0, 3.5, t)
		self.global_position = lerp(self.global_position, target, delta * lerp_speed)
	if save_lerping:
		var target := save_location.global_position
		self.global_position = lerp(self.global_position, target, delta * 2.0)
		var target_rotation := save_location.global_rotation
		target_rotation.y = self.global_rotation.y
		self.global_rotation = lerp(self.global_rotation, target_rotation, delta * 4.0)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if in_car and m_bus.is_magnetizing:
		var magnet_center := m_bus.magnet_force_bottom.global_position if actually_in_cage \
			else m_bus.magnet_force_top.global_position
		var dir := (magnet_center - self.global_position).normalized()
		var dist := magnet_center.distance_to(self.global_position)
		state.apply_central_force(dir * 20.0 * maxf(1.0, dist))

func _on_body_entered(body: PhysicsBody3D) -> void:
	var is_ground := body.get_collision_layer_value(1)
	if is_ground and in_car:
		var splatter : Node3D = splatter_scene.instantiate()
		get_tree().root.add_child(splatter)
		splatter.global_position = self.global_position
		queue_free()
