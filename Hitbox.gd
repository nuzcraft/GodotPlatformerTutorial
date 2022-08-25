extends Area2D

func _on_Hitbox_body_entered(body):
	if body is Player:
		body.get_node("ShakeCamera").add_shake(0.25)
		body.player_die()
