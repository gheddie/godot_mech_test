class_name Robot
extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.5

@onready var animationTree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	"""
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		"""
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveBackward", "moveForward", "null", "null")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	handleTurn(delta)
	move_and_slide()

func handleTurn(_delta: float) -> void:
	if Input.is_action_pressed("turnLeft"):
		rotation.y += TURN_SPEED * _delta
		tipple()
	elif  Input.is_action_pressed("turnRight"):
		rotation.y -= TURN_SPEED * _delta
		tipple()
	else:
		idle()

func tipple() -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/tipple"] = false	
