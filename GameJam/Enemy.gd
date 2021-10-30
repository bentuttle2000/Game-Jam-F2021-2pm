extends KinematicBody2D

var is_dead = false;

func dead():
	is_dead = true;
	$Timer.start();


func _on_Timer_timeout():
	queue_free();

