extends KinematicBody2D

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello universe")

func _physics_process(delta):
	velocity.y += 8
	if Input.is_action_pressed("ui_right"):
		velocity.x = 75
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -75
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -175
	velocity = move_and_slide(velocity)
