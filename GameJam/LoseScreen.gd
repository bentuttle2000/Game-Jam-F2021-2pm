extends Node



func _ready():
	Music.changeSong("res://Music/LizardDeathJingle.mp3")
	$MarginContainer/VBoxContainer/VBoxContainer/Respawn.grab_focus()


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Respawn.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Respawn.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/MainMenu.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/MainMenu.grab_focus()
	

func _on_Respawn_pressed():
	get_tree().change_scene("res://Stages/StageOne.tscn")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Stages/StartScreen.tscn")
