extends KinematicBody2D

var is_dead = false;
const SPEED = 50;
var PlayerPosition = Vector2();
var CurrentPosition = Vector2();
var velocity = Vector2();

func _process(delta):
	if !is_dead:
		$AnimatedSprite.play("Idle")
		if get_owner() != null:
			PlayerPosition = get_tree().current_scene.get_node("Player").get_position();
		CurrentPosition = get_position();
		if PlayerPosition.x > CurrentPosition.x:
			velocity.x = SPEED;
		elif PlayerPosition.x < CurrentPosition.x:
			velocity.x = -SPEED;
		else:
			velocity.x = 0;
		if PlayerPosition.y > CurrentPosition.y:
			velocity.y = SPEED;
		elif PlayerPosition.y < CurrentPosition.y:
			velocity.y = -SPEED;
		else:
			velocity.y = 0;
		move_and_slide(velocity);



func dead():
	$AnimatedSprite.play("Dead")
	is_dead = true;
	$Timer.start();


func _on_Timer_timeout():
	queue_free();

