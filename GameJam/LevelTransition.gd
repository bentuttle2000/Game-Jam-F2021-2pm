extends Area2D

export(String, FILE, "*.tscn") var target_stage
const PLAYER = ("Player.tscn")

func _ready():
	pass # Replace with function body.

func _on_LevelTransition_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene(target_stage)
