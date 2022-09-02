extends Node2D

const PlayerScene = preload("res://Player/Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var shakeCamera := $ShakeCamera
onready var player := $Player
onready var timer := $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.black)
	player.connectCamera(shakeCamera)
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("hit_checkpoint", self, "_on_hit_checkpoint")
	player_spawn_location = player.global_position
	
func _on_player_died():
	timer.start(1.0)
	yield(timer, "timeout")
	var player = PlayerScene.instance()
	player.position = player_spawn_location
	add_child(player)
	player.connectCamera(shakeCamera)
	
func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
