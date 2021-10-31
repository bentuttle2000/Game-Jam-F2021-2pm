extends Sprite

func _ready():
	pass 

func _on_TextureButton_button_up():
	$SceneTransition.transition_to("res://Stages/SplashScene.tscn")
