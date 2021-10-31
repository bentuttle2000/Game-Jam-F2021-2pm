#Source code acquried from https://www.gdquest.com/tutorial/godot/2d/scene-transition-rect/ on 10/30/2021
#Example on how to use the transtition would follow as
#func _on_StartButton_pressed() -> void:
#	$SceneTransition.transition_to("res://path/to/Play.tscn")
extends ColorRect

export(String, FILE, ".tscn") var next_scene_path

onready var _anim_player := $AnimationPlayer

func _ready():
	#Causes the Fade animation to be played backwards
	_anim_player.play_backwards("Fade")

func transition_to(_next_scene := next_scene_path) -> void:
	#Plays the Fade animation
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	#Changes the scene
	get_tree().change_scene(_next_scene)
