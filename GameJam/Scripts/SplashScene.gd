extends Sprite

func _ready():
	pass 


func _on_Timer_timeout():
	$SceneTransition.transition_to("res://Stages/StartScreen.tscn")
