extends RigidBody2D


@export var selected_gear: int = 0 
@export var curr_rotation: float = 10
@export var clutch_curve: Curve


var wheel_speed: float 
var wheel_torque: float = 0
var IDLE_ANGLE: float = 10.0
var TORQUE_SCALE: float = 0.5
var WHEEL_DAMP: float = 10
var ENGINE_DAMP: float = 10
var GAS: float = 150
var ENGINE_POWER = 100
var ENGINE_LOAD_FUDGE = 20
var rpm_angle: float # distance from idle
var GEARS = [0, 2, 1, 0.5, 0.3, -1]
var gear_ratio: float
var engine_load: float
var analog_gas: float
var analog_clutch: float
var truck_speed: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$engine/rpm_pin.set_angular_damp(ENGINE_DAMP)
	$engine/rpm_pin.set_rotation_degrees(IDLE_ANGLE)
	$front_wheel.set_angular_damp(WHEEL_DAMP)
	$rear_wheel.set_angular_damp(WHEEL_DAMP)

func change_gear(idx):
	selected_gear += idx
	
	if selected_gear > len(GEARS) - 1:
		selected_gear = len(GEARS) - 1 
	if selected_gear < 0:
		selected_gear = 0 
	gear_ratio = GEARS[selected_gear]
	print("selected gear: ", selected_gear)
#	compute engine load due to wheels
	#engine_load = gear_ratio*(curr_rotation - $front_wheel.get_angular_velocity())
	#print("changed gear to: ", gear_ratio ," engine load: ", engine_load)
#
	#$engine/rpm_pin.apply_torque_impulse(-engine_load*ENGINE_LOAD_FUDGE)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curr_rotation = $engine/rpm_pin.get_rotation_degrees()
	rpm_angle = (IDLE_ANGLE - curr_rotation) * TORQUE_SCALE
	$engine/rpm_pin.apply_torque_impulse(rpm_angle)
	truck_speed = $body.linear_velocity.x
	
	if Input.is_action_just_pressed("ui_up"):
		change_gear(1) 
	if Input.is_action_just_pressed("ui_down"):
		change_gear(-1)
	if Input.is_action_pressed("ui_accept"):
		$engine/rpm_pin.apply_torque_impulse(GAS)
		
	analog_gas = Input.get_action_strength("gas")
	$engine/rpm_pin.apply_torque_impulse(analog_gas*GAS)
	
	analog_clutch = clutch_curve.sample(Input.get_action_strength("clutch"))
	
	if Input.is_action_pressed("move_left"):
		$front_wheel.set_angular_damp(WHEEL_DAMP*5)
	if Input.is_action_just_released("move_left"):
		$front_wheel.set_angular_damp(WHEEL_DAMP)
	wheel_torque = gear_ratio * curr_rotation * ENGINE_POWER
	$front_wheel.apply_torque_impulse(wheel_torque)
	wheel_speed = $front_wheel.get_angular_velocity()
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#pass
	if selected_gear != 0:
		$front_wheel.angular_velocity = 1/gear_ratio * $engine/rpm_pin.rotation 
		#$engine/rpm_pin.set_rotation_degrees($front_wheel.angular_velocity / selected_gear)
	#if curr_rotation < 0:
		#print("stalled")
		#$engine/rpm_pin.rotation = 0
	#pass
	
