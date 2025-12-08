class_name Robot
extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.75

@onready var animationTree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("moveBackward", "moveForward", "null", "null")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walk()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		idle()
	handleTurn(delta)
	move_and_slide()

func handleTurn(_delta: float) -> void:	
	if Input.is_action_pressed("turnLeft") or Input.is_action_pressed("turnRight"):
		tipple()
	var input_dir := Input.get_vector("turnLeft", "turnRight", "null", "null")
	var rotationAmount = input_dir.x * _delta * -1 * TURN_SPEED
	if Input.is_action_pressed("turnLeft"):		
		rotate_y(rotationAmount)
	if Input.is_action_pressed("turnRight"):
		rotate_y(rotationAmount)

func tipple() -> void:
	animationTree["parameters/conditions/tipple"] = true
	animationTree["parameters/conditions/idle"] = false	
	animationTree["parameters/conditions/walk"] = false	
		
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/tipple"] = false	
	animationTree["parameters/conditions/walk"] = false	

func walk() -> void:
	animationTree["parameters/conditions/walk"] = true	
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = false		
