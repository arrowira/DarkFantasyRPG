extends CharacterBody3D

var PlayerSpeed = 0.8

var Jump = false
var JumpVelocity = 2
var JumpSlowMod = 0.5

var Gravity = 0
var Grounded = false
var Friction = 0.9

var SprintMod = 1.4
var Sprint = 1

var MouseSense = 0.005
var CamPitch = 0
var DefCameraHeight = 0
@onready var Camera = $Camera3D

var Crouched = false
var CrouchedFallMod = 1.5
var CrouchedSpeedMod = 0.5

@onready var StepSound = $StepSound
@onready var StepSound2 = $StepSound2
@onready var WalkTimer = $WalkTimer
var WTimeSet = false

var SelectedHBSlot = -1
var HBSlotModel

#Player moves slow when crouced, when crouched in the air the player doesnt move at all but fall faster 
#When sprinting the player moves faster on ground but not in the air. The player cannot spring while crouched

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	#Should be the Cameras local poisiton
	DefCameraHeight = Camera.position.y

func _physics_process(delta: float) -> void:
	var InputDir = Input.get_vector("Left","Right", "Forward", "Backward")
	var Dir = (transform.basis * Vector3(InputDir.x, 0, InputDir.y)).normalized()
	
	#This is not very well coded
	if(Dir != Vector3.ZERO && Grounded == true):
		if(WTimeSet == false):
			StepSound.play()
			WalkTimer.stop()
			WalkTimer.wait_time = 1.8-(PlayerSpeed * Sprint * CrouchedSpeedMod)*2
			WalkTimer.start()
			WTimeSet = true
	else:
		WalkTimer.stop()
		if(Dir == Vector3.ZERO or Grounded == false):
			WTimeSet = false
		
	if(Grounded == true):
		velocity+=Dir*(PlayerSpeed * Sprint * CrouchedSpeedMod)
	elif Crouched != true:
		velocity+=Dir*(PlayerSpeed*JumpSlowMod)
	velocity.x*=Friction
	velocity.z*=Friction
	
	if(Input.is_action_pressed("Sprint") && Grounded == true && Crouched == false):
		Sprint = SprintMod
	else:
		Sprint = 1
	
	if(Input.is_action_pressed("Jump") && Jump == true):
		velocity.y+=JumpVelocity
		Jump = false
	
	#Make crouch modify hitbox
	if(Input.is_action_pressed("Crouch")):
		Crouched = true
		Camera.position.y = DefCameraHeight-1
	else:
		Crouched = false
		Camera.position.y = DefCameraHeight
		
	#Make a custom function later, will detect if on top of enemies or something else as is on floor as well
	if(!is_on_floor()):
		if(Crouched == false):
			velocity.y-=(Gravity*0.01)
		else:
			velocity.y-=(Gravity*0.01)*CrouchedFallMod
		Jump = false
		Grounded = false
	else:
		Jump = true
		Grounded = true
		
	var PSS = SelectedHBSlot
	#probably better way to do this
	if(Input.is_key_pressed(KEY_1)):
		if(SelectedHBSlot == 1):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 1
	if(Input.is_key_pressed(KEY_2)):
		if(SelectedHBSlot == 2):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 2
	if(Input.is_key_pressed(KEY_3)):
		if(SelectedHBSlot == 3):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 3
	if(Input.is_key_pressed(KEY_4)):
		if(SelectedHBSlot == 4):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 4
	if(Input.is_key_pressed(KEY_5)):
		if(SelectedHBSlot == 5):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 5
	if(Input.is_key_pressed(KEY_6)):
		if(SelectedHBSlot == 6):
			SelectedHBSlot = -1
		else:
			SelectedHBSlot = 6
	#If something changed redraw what the player is holding
	#DrawHBItem()
	move_and_slide()
	
#No idea how this functions works. I just copied it.
func _input(event):
	if(event is InputEventMouseMotion && get_node("/root/Node3D/Canvas/InventoryRenderer").Open == false):
		rotate_y(-event.relative.x * MouseSense)
		CamPitch -= event.relative.y * MouseSense
		CamPitch = clamp(CamPitch, deg_to_rad(-90), deg_to_rad(90))
		Camera.rotation.x = CamPitch
		
func _on_walk_timer_timeout() -> void:
	var R = randi_range(0, 2)
	if(R == 1):
		StepSound.volume_db = randf_range(0.5, 1.5) 
		StepSound.pitch_scale = randf_range(0.9, 1.1) 
		StepSound.play()
	else:
		StepSound2.volume_db = randf_range(0.5, 1.5) 
		StepSound2.pitch_scale = randf_range(0.9, 1.1) 
		StepSound2.play()
	WTimeSet = false
	
#func DrawHBItem():
	#if($InventoryManager.Inv[$InventoryManager.InvSize+SelectedHBSlot].Name != "Empty"):
		#var PS = load($InventoryManager.Inv[$InventoryManager.InvSize+SelectedHBSlot].ScenePath)
		#HBSlotModel = PS.instantiate()
		#HBSlotModel.position = $Arm/HandPoint
		#add_child(HBSlotModel)
