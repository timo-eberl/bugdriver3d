extends RigidBody3D
class_name Bug

@export var physics_material_in_car : PhysicsMaterial
@export var splatter_scene : PackedScene

var m_bus : Bus

# state
var idle := true
var lerping := false
var in_car := false

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

func _process(delta: float) -> void:
	if lerping:
		var cage_pos := self.m_bus.cage_area.global_position
		var target := cage_pos + 4.0 * (self.m_bus.global_position - self.global_position)
		self.global_position = lerp(self.global_position, target, delta * 2.0)

func _on_body_entered(body: PhysicsBody3D) -> void:
	var is_ground := body.get_collision_layer_value(1)
	if is_ground and in_car:
		var splatter : Node3D = splatter_scene.instantiate()
		get_tree().root.add_child(splatter)
		splatter.global_position = self.global_position
		queue_free()
