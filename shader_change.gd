extends Sprite2D

var zoom = 3.0
var center_x = 0.0
var center_y =  0.0
var aspect_ratio = 1080.0/1920.0
var num_iterations = 10000

var dragging = false
var drag_start = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	material.set_shader_parameter("zoom", zoom)
	material.set_shader_parameter("center_x", center_x)
	material.set_shader_parameter("center_y", center_y)
	material.set_shader_parameter("num_iterations", num_iterations)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				dragging = true
				drag_start = event.position
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom *= 0.9
				material.set_shader_parameter("zoom", zoom)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom *= 1.1
				material.set_shader_parameter("zoom", zoom)
		elif dragging:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		var drag_vector = (event.position - drag_start)
		print("Mouse position: ", event.position)
		print("Drag vector: ", drag_vector)
		center_x -= drag_vector.x / 1920.0 * zoom
		center_y += drag_vector.y / 1080.0 * zoom
		material.set_shader_parameter("center_x", center_x)
		material.set_shader_parameter("center_y", center_y)

