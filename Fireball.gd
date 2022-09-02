extends KinematicBody2D
class_name Fireball

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
const SPEED = 75
var has_hit_ground = false
var bounce_dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == Vector2.ZERO:
		direction.x = 1
		direction.y = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	if has_hit_ground:
		var new_angle = direction.angle()
		new_angle += 0.09 * bounce_dir
		direction = Vector2(cos(new_angle), sin(new_angle))

	
	if is_on_floor():
		has_hit_ground = true
		direction = Vector2.UP
		
	if is_on_wall():
		bounce_dir *= -1
		direction.x = -direction.x
	
	velocity = (direction * SPEED)
	velocity = move_and_slide(velocity, Vector2.UP)
	self.rotation = velocity.angle()
