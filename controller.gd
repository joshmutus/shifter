# Godot 3.x version of a Godot 4 script written by anthonyec at:
# 	https://gist.github.com/anthonyec/5342fce79b2b7b22ada748df0ad7f7c0
# This Godot 3.x version available at:
#	https://gist.github.com/belzecue/025d8829f69dead512e58f44e990ce30/edit
# Attach script to a Control node.

@tool
extends Control

export var device: int = 0

func _process(delta: float) -> void:
	update()

const JOY_AXIS_TRIGGER_LEFT := JOY_AXIS_6
const JOY_AXIS_TRIGGER_RIGHT := JOY_AXIS_7
const JOY_BUTTON_LEFT_SHOULDER := JOY_L
const JOY_BUTTON_RIGHT_SHOULDER := JOY_R
const JOY_BUTTON_DPAD_LEFT := JOY_DPAD_LEFT
const JOY_BUTTON_DPAD_RIGHT := JOY_DPAD_RIGHT
const JOY_BUTTON_DPAD_UP := JOY_DPAD_UP
const JOY_BUTTON_DPAD_DOWN := JOY_DPAD_DOWN
const JOY_AXIS_LEFT_X := JOY_AXIS_0
const JOY_AXIS_RIGHT_X := JOY_AXIS_2
const JOY_AXIS_LEFT_Y := JOY_AXIS_1
const JOY_AXIS_RIGHT_Y := JOY_AXIS_3
const JOY_BUTTON_LEFT_STICK := JOY_L3
const JOY_BUTTON_RIGHT_STICK := JOY_R3
const JOY_BUTTON_X := JOY_XBOX_X
const JOY_BUTTON_Y := JOY_XBOX_Y
const JOY_BUTTON_A := JOY_XBOX_A
const JOY_BUTTON_B := JOY_XBOX_B
const JOY_BUTTON_BACK := JOY_SELECT
const JOY_BUTTON_START := JOY_START

func _draw() -> void:
	# Set the size, the layout isn't dynamic and based on something I sketched!
	var size = Vector2(81, 69)
	
	# Draw the background
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.15, 0.15, 0.15, 0.45))
	
	draw_trigger(Vector2(5, 5), Input.get_joy_axis(device, JOY_AXIS_TRIGGER_LEFT))
	draw_bumper(Vector2(5, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_LEFT_SHOULDER))

	draw_trigger(Vector2(52, 5), Input.get_joy_axis(device, JOY_AXIS_TRIGGER_RIGHT))
	draw_bumper(Vector2(52, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_RIGHT_SHOULDER))
		
	var dpad_position = Vector2(4, 26)

	# Draw dpad going from left, top, right and bottom
	draw_dpad_arrow(dpad_position + Vector2(1, 8),  deg2rad(-90.0), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_LEFT))
	draw_dpad_arrow(dpad_position + Vector2(8, 1), deg2rad(0.0), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_UP))
	draw_dpad_arrow(dpad_position + Vector2(15, 8), deg2rad(90.0), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_RIGHT))
	draw_dpad_arrow(dpad_position + Vector2(8, 15), deg2rad(180.0), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_DOWN))
	
	draw_joystick(Vector2(30, 56), Input.get_joy_axis(device, JOY_AXIS_LEFT_X), Input.get_joy_axis(device, JOY_AXIS_LEFT_Y), Input.is_joy_button_pressed(device, JOY_BUTTON_LEFT_STICK))
	draw_joystick(Vector2(49, 56), Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y), Input.is_joy_button_pressed(device, JOY_BUTTON_RIGHT_STICK))
	
	var face_buttons_position = Vector2(49, 25)
	
	# Draw face buttons going from left, top, right and bottom
	draw_face_button(face_buttons_position + Vector2(1, 9), Input.is_joy_button_pressed(device, JOY_BUTTON_X))
	draw_face_button(face_buttons_position + Vector2(9, 1), Input.is_joy_button_pressed(device, JOY_BUTTON_Y))
	draw_face_button(face_buttons_position + Vector2(17, 9), Input.is_joy_button_pressed(device, JOY_BUTTON_B))
	draw_face_button(face_buttons_position + Vector2(9, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_A))
	
	draw_option_button(Vector2(33, 27), Input.is_joy_button_pressed(device, JOY_BUTTON_BACK))
	draw_option_button(Vector2(42, 27), Input.is_joy_button_pressed(device, JOY_BUTTON_START))

func draw_option_button(position: Vector2, is_pressed: bool) -> void:
	var width = 6
	var height = 5
	var color = Color.red if is_pressed else Color.white
	
	draw_rect(Rect2(position.x, position.y, width, height), Color.black)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), color)

func draw_dpad_arrow(position: Vector2, angle: float, is_pressed: bool) -> void:
	var width = 9
	var height = 9
	var color = Color.red if is_pressed else Color.white
	
	# Points are for an arrow facing downwards
	var points: Array = [
		# Top left corner
		Vector2.ZERO, 
		# Top right corner
		Vector2.ZERO + Vector2(width, 0),
		# Right edge
		Vector2.ZERO + Vector2(width, height / 2),
		# Arrow point
		Vector2.ZERO + Vector2(width / 2, height),
		# Left edge
		Vector2.ZERO + Vector2(0, height / 2),
		# Top left corner again
		Vector2.ZERO,
	]
	
	var bounds = Rect2(position, Vector2.ZERO)
	
	# Rotate all the points and create a bounding box that contains them
	for index in points.size():
		var point = points[index]
		
		points[index] = point.rotated(angle)
		bounds = bounds.expand(points[index])
	
	# Re-align all the points so that the pivot point is always in the top left
	for index in points.size():
		var point = points[index]
		
		points[index] = position + (point - bounds.position)
		
	draw_polygon(points, [color])
	draw_polyline(points, Color.black)

func draw_face_button(position: Vector2, is_pressed: bool) -> void:
	var radius = 5
	var color = Color.red if is_pressed else Color.white
	
	# Add the radius so that the pivot point is in the top left
	draw_circle(position + Vector2(radius, radius), radius, Color.black)
	draw_circle(position + Vector2(radius, radius), radius - 1, color)

func draw_bumper(position: Vector2, is_pressed: bool) -> void:
	var width = 24
	var height = 6
	var color = Color.red if is_pressed else Color.white
	
	draw_rect(Rect2(position.x, position.y, width, height), Color.black)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), color)
	
func draw_trigger(position: Vector2, axis: float) -> void:
	var width = 24
	var height = 10
	
	# Draw background
	draw_rect(Rect2(position.x, position.y, width, height), Color.black)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), Color.white)
	
	# Draw fill that fills up like a nice filling fill
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, (height - 2) * axis), Color.red)

func draw_joystick(position: Vector2, axis_x: float, axis_y: float, is_pressed: bool) -> void:
	var radius = 8
	var max_distance = 4
	var color = Color.red if is_pressed else Color.white
	
	# Draw stick container
	draw_circle(position, radius, Color.black)
	draw_circle(position, radius - 1, Color.gray)

	# Draw the actual stick that moves around
	draw_circle(position + Vector2(axis_x, axis_y) * max_distance, radius - 2, Color.black)
	draw_circle(position + Vector2(axis_x, axis_y) * max_distance, radius - 3, color)
