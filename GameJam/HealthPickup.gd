extends Area2D



func _on_HealthPickup_body_entered(body):
	if ("Player" in body.name):
		body.health_pickup()
		queue_free()
