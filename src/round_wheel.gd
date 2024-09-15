extends RigidBody2D

var forces: Vector2
var GRIP_FRICTION: float = 50.0
var SLIP_FRICTION: float = 0.1
var SLIP_VELOCITY = 500
var RADIUS = 50
var SLIP_CHECK: bool = false
var tire_color: Color = Color.CHOCOLATE
var slip_check_prev: bool
var wheel_lv: float
var com_lv: float
var shear: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_angular_damp_mode(RigidBody2D.DAMP_MODE_REPLACE)
	angular_damp = 1
	physics_material_override.friction = GRIP_FRICTION
	

func _draw() -> void:
	if SLIP_CHECK:
		tire_color = Color.CHOCOLATE
	else:
		tire_color = Color.AQUA
	draw_circle(Vector2(0,0),RADIUS, Color.AQUA)
	draw_circle(Vector2(10,10),5, Color.RED)
	draw_circle(Vector2(0,0),RADIUS, tire_color, false, 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var gas = Input.get_action_strength("move_up")
	
	#if Input.is_action_just_pressed("tappy"):
		#print("angular_velocity: ", angular_velocity, "angular_damp: ", angular_damp)
	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	slip_check_prev = SLIP_CHECK
	wheel_lv  = angular_velocity*RADIUS
	com_lv = linear_velocity.x
	print(wheel_lv)
	shear = wheel_lv - com_lv
	if shear <= SLIP_VELOCITY:
		physics_material_override.friction = GRIP_FRICTION
		SLIP_CHECK = false
	
	if shear > SLIP_VELOCITY:		
		physics_material_override.friction = SLIP_FRICTION
		SLIP_CHECK = true
		
	if SLIP_CHECK != slip_check_prev:
		print("slip changed")
		queue_redraw()
	
	
