extends Node



func _ready():
	Music.changeSong("res://Music/LizardTitle.mp3")
	$VBoxContainer/StartButton.grab_focus()


func _physics_process(delta):
	if $VBoxContainer/StartButton.is_hovered() == true:
		$VBoxContainer/StartButton.grab_focus()
	if $VBoxContainer/ExitButton.is_hovered() == true:
		$VBoxContainer/ExitButton.grab_focus()
	

func _on_StartButton_pressed():
	get_tree().change_scene("res://Stages/StageOne.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()




func _on_Instructions_pressed():
	get_tree().change_scene("res://Stages/Instructions.tscn")
