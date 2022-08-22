extends KinematicBody2D
class_name Player

enum {
	MOVE,
	CLIMB,
}

export(Resource) var moveData = preload("res://DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity = Vector2.ZERO
var state = MOVE
var double_jump = moveData.DOUBLE_JUMP_COUNT

onready var animatedSprite = $AnimatedSprite
onready var ladderCheck = $LadderCheck

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)
		
func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	apply_gravity()
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input.x > 0
	
	if is_on_floor():
		double_jump = moveData.DOUBLE_JUMP_COUNT
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = moveData.JUMP_FORCE
			animatedSprite.animation = "Jump"
	else: 
		if Input.is_action_just_released("ui_up") and velocity.y < -moveData.JUMP_RELEASE_FORCE:
			velocity.y = -moveData.JUMP_RELEASE_FORCE
			
		if Input.is_action_just_pressed("ui_up") && double_jump>0:
			velocity.y = moveData.JUMP_FORCE
			double_jump -= 1
			
		if velocity.y > 0:
			velocity.y += moveData.FORCE_FALL_GRAVITY
			animatedSprite.animation = "Falling"
		else:
			animatedSprite.animation = "Jump"
			animatedSprite.frame = 1
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
func climb_state(input):
	if not is_on_ladder():
		state = MOVE
	if input.length() != 0:
		animatedSprite.animation = "Idle"
	else:
		animatedSprite.animation = "Falling"
		
	velocity = input * moveData.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
	
func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, moveData.MAX_GRAVITY)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.HORIZONTAL_MAX_SPEED*amount, moveData.HORIZONTAL_ACCELERATION)
