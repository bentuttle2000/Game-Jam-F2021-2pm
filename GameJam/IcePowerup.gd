extends Area2D

func _on_IcePowerup_body_entered(body):
	if ("Player" in body.name):
		body.ice_powerup()
		queue_free()
