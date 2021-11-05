extends Area2D

#Created by Nick "Goro Majima" Mineo

func _ready():
	pass
func _on_FlashPowerup_body_entered(body):
	if "Player" in body.name:
		body.flashup_powerup()
		queue_free()
