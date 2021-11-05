extends Area2D


#For Stage 4 Puzzle. Probably going unused.
#Created By Nick "Goro Majima" Mineo

func _on_Gold_body_entered(body):
	if body.name == "Player":
		body.goldCnt += 1
		queue_free()
		print(body.goldCnt)

