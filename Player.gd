extends KinematicBody2D

export(int) var JUMP_FORCE = -275
export(int) var JUMP_RELEASE_FORCE = -80
export(int) var GRAVITY = 12
export(int) var FORCE_FALL_GRAVITY = 8
export(int) var FRICTION = 35
export(int) var HORIZONTAL_ACCELERATION = 25
export(int) var HORIZONTAL_MAX_SPEED = 165

var velocity = Vector2.ZERO
onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		if input.x > 0:
			animatedSprite.flip_h = true
		elif input.x <0:
			animatedSprite.flip_h = false
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			animatedSprite.animation = "Jump"
	else: 
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_RELEASE_FORCE:
			velocity.y = -JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += FORCE_FALL_GRAVITY
		animatedSprite.animation = "Falling"
		
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, HORIZONTAL_MAX_SPEED*amount, HORIZONTAL_ACCELERATION)
