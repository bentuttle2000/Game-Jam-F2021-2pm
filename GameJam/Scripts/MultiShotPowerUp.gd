extends Area2D

func _ready():
	pass



func _on_MultiShotPickUp_body_entered(body):
	if "Player" in body.name:
		body.multishot_powerup()
		queue_free()
