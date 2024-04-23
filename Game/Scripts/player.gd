extends CharacterBody2D

var input
@export var speed = 100.0
@export var gravity = 10


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
	gravity_force()
	
	move_and_slide()
	
func gravity_force():
	velocity.y += gravity
