extends Camera3D

@export var BulgeCamera: Camera3D
@export var AssCamera: Camera3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("camera_swap"):
		if (BulgeCamera.current):
			AssCamera.make_current()
		else:
			BulgeCamera.make_current()
		
