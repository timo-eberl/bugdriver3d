extends RigidBody3D
class_name Bug

@export var physics_material_in_car : PhysicsMaterial
var lerping := false
var m_bus : Bus

func collect(bus: Bus) -> void:
	self.custom_integrator = true
	m_bus = bus
	lerping = true
	self.add_collision_exception_with(bus)

func stop_collecting() -> void:
	lerping = false
	self.custom_integrator = false
	self.axis_lock_linear_x = false
	self.axis_lock_linear_y = false
	self.axis_lock_linear_z = false
	self.axis_lock_angular_x = false
	self.axis_lock_angular_y = false
	self.axis_lock_angular_z = false
	self.physics_material_override = physics_material_in_car
	self.remove_collision_exception_with(m_bus)

func _process(delta: float) -> void:
	if lerping:
		var cage_pos := self.m_bus.cage_area.global_position
		var target := cage_pos + 3.0 * (self.m_bus.global_position - self.global_position)
		self.global_position = lerp(self.global_position, target, delta * 1.8)
