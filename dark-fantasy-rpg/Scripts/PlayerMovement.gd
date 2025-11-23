extends CharacterBody3D

var PlayerSpeed = 1
var Jump = false
var JumpVelocity = 2
var Gravity = 0
var Grounded = false
var Friction = 0.9

var MouseSense = 0.005
var CamPitch = 0
@onready var Camera = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	var InputDir = Input.get_vector("Left","Right", "Forward", "Backward")
	var Dir = (transform.basis * Vector3(InputDir.x, 0, InputDir.y)).normalized()
	if(Grounded == true):
		velocity+=Dir*PlayerSpeed
	else:
		velocity+=Dir*(PlayerSpeed*0.6)
	velocity.x*=Friction
	velocity.z*=Friction
	
	if(Input.is_action_pressed("Jump") && Jump == true):
		velocity.y+=JumpVelocity
		Jump = false
		
	#Make a custom function later, will detect if on top of enemies or something else as is on floor as well
	if(!is_on_floor()):
		velocity.y-=(Gravity*0.01)
		Jump = false
		Grounded = false
	else:
		Jump = true
		Grounded = true
	
	move_and_slide()
	
#No idea how this functions works. I just copied it.
func _input(event):
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * MouseSense)
		CamPitch -= event.relative.y * MouseSense
		CamPitch = clamp(CamPitch, deg_to_rad(-90), deg_to_rad(90))
		Camera.rotation.x = CamPitch
