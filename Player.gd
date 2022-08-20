extends KinematicBody2D
class_name Player

export(Resource) var moveData

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
		animatedSprite.flip_h = input.x > 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = moveData.JUMP_FORCE
			animatedSprite.animation = "Jump"
	else: 
		if Input.is_action_just_released("ui_up") and velocity.y < -moveData.JUMP_RELEASE_FORCE:
			velocity.y = -moveData.JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += moveData.FORCE_FALL_GRAVITY
			animatedSprite.animation = "Falling"
		else:
			animatedSprite.animation = "Jump"
			animatedSprite.frame = 1
		
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, moveData.MAX_GRAVITY)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.HORIZONTAL_MAX_SPEED*amount, moveData.HORIZONTAL_ACCELERATION)
