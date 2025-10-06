@tool
extends WorldEnvironment
class_name DayNight

@export var color_shift_material : ShaderMaterial

@export_range(0.0, 1.0) var progress := 0.0
@export_category("day")
@export_color_no_alpha var fog_color_day : Color
@export_range(0.0, 1.0) var fog_density_day := 0.0
@export_range(0.0, 3.0) var adjustment_brightness_day := 1.0
@export_range(0.0, 3.0) var adjustment_saturation_day := 1.0
@export_color_no_alpha var ambient_light_color_day : Color
@export_range(0.0, 5.0) var ambient_light_energy_day := 1.0
@export_color_no_alpha var color_shift_day : Color
@export_category("night")
@export_color_no_alpha var fog_color_night : Color
@export_range(0.0, 1.0) var fog_density_night := 0.0
@export_range(0.0, 3.0) var adjustment_brightness_night := 1.0
@export_range(0.0, 3.0) var adjustment_saturation_night := 1.0
@export_color_no_alpha var ambient_light_color_night : Color
@export_range(0.0, 5.0) var ambient_light_energy_night := 1.0
@export_color_no_alpha var color_shift_night : Color

func _process(_delta: float) -> void:
	self.environment.fog_light_color = lerp(fog_color_day, fog_color_night, progress)
	self.environment.fog_density = lerp(fog_density_day, fog_density_night, progress)
	self.environment.adjustment_brightness = lerpf(adjustment_brightness_day, adjustment_brightness_night, progress)
	self.environment.adjustment_saturation = lerpf(adjustment_saturation_day, adjustment_saturation_night, progress)
	self.environment.ambient_light_color = lerp(ambient_light_color_day, ambient_light_color_night, progress)
	self.environment.ambient_light_energy = lerpf(ambient_light_energy_day, ambient_light_energy_night, progress)
	color_shift_material.set_shader_parameter("color_tint", lerp(color_shift_day, color_shift_night, progress))
