extends CharacterBody3D

var PlayerSpeed = 1

func _physics_process(delta: float) -> void:
	var InputDir = Input.get_vector("Left","Right", "Forward", "Backward")
	var Dir = (transform.basis * Vector3(InputDir.x, 0, InputDir.y)).normalized()
	velocity+=Dir*PlayerSpeed
	velocity*=0.9
	move_and_slide()
