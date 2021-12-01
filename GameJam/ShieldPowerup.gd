extends Area2D



func _on_ShieldPowerup_body_entered(body):
	if ("Player" in body.name):
		body.shield_powerup()
		queue_free()
