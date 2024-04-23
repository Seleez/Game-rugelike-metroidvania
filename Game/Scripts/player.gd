extends CharacterBody2D

var input
@export var speed = 100.0
@export var gravity = 10

@export var jump_force = 500
var jump_count = 0
@export var max_jump = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement(delta)
func movement(delta):
	input = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	if input !=0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x =clamp(speed, 100.0,speed)
			$Sprite2D.flip_h = false
			#TODO ANIMATIONS
		elif input < 0:
			velocity.x -= speed * delta
			velocity.x =clamp(-speed, 100.0,-speed)
			$Sprite2D.flip_h = true
	elif input == 0:
		velocity.x = 0
	#TODO Jump Animation
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		velocity.y -= jump_force
		velocity.x = input
		jump_count += 1
	if Input.is_action_just_pressed("ui_accept") && !is_on_floor() && jump_count < max_jump:
		velocity.y -= jump_force
		velocity.x = input
		jump_count += 1
	if Input.is_action_just_released("ui_accept") && !is_on_floor() && jump_count < max_jump:
		velocity.y = gravity
		jump_count += 1
	gravity_force()
	move_and_slide()

	


func gravity_force():
	velocity.y += gravity
