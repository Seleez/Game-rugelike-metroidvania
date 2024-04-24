extends CharacterBody2D

var input
@export var speed = 100.0
@export var gravity = 10

#JUMPING
@export var jump_force = 500
var jump_count = 0
@export var max_jump = 2

#STATE MACHINE
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD}



# Called when the node enters the scene tree for the first time.
func _ready():
	$Sword/SwordColider.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match  current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
func movement(delta):
	input = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	
	if input !=0:
		if input > 0:
			$AnimationPlayer.play("Stand")
			velocity.x += speed * delta
			velocity.x =clamp(speed, 100.0,speed)
			$Sprite2D.scale.x = 0.25
			$Sword.position.x = 25
			
			#TODO ANIMATIONS
		elif input < 0:
			$AnimationPlayer.play("Stand")
			velocity.x -= speed * delta
			velocity.x =clamp(-speed, 100.0,-speed)
			$Sprite2D.scale.x = -0.25
			$Sword.position.x = -50
			#$Sprite2D.position.x = 0
	elif input == 0:
		velocity.x = 0
	#TODO Jump Animation
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		
		$AnimationPlayer.play("Stand")
		velocity.y -= jump_force
		velocity.x = input
		jump_count += 1
	if Input.is_action_just_pressed("ui_accept") && !is_on_floor() && jump_count < max_jump:
		$AnimationPlayer.play("Stand")
		velocity.y -= jump_force
		velocity.x = input
		jump_count += 1
	if Input.is_action_just_released("ui_accept") && !is_on_floor() && jump_count < max_jump:
		velocity.y = gravity
	print(jump_count)
	gravity_force()
	move_and_slide()
	if Input.is_action_just_pressed("ui_sword"):
		current_state = player_states.SWORD

	


func gravity_force():
	velocity.y += gravity
	
func sword(delta):
	$AnimationPlayer.play("Attack")
	input_movement(delta)

	
func input_movement(delta):
	input = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	
	if input !=0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x =clamp(speed, 100.0,speed)
		elif input < 0:
			velocity.x -= speed * delta
			velocity.x =clamp(-speed, 100.0,-speed)
	elif input == 0:
		velocity.x = 0

	move_and_slide()

func reset_states():
	current_state = player_states.MOVE
