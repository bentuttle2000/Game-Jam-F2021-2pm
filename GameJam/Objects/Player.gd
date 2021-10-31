extends KinematicBody2D

const SPEED = 50;

var velocity = Vector2();

var mouseDir = Vector2();

const PROJECTILE = preload("res://Objects/Projectile.tscn")

func _process(delta):
	look_at(get_global_mouse_position());
	
	if Input.is_action_pressed("ui_right"): 
		velocity.x = SPEED;
	elif Input.is_action_pressed("ui_left"): 
		velocity.x = -SPEED;
	else:
		velocity.x = 0;

	if Input.is_action_pressed("ui_down"): 
		velocity.y = SPEED;
	elif Input.is_action_pressed("ui_up"): 
		velocity.y = -SPEED;
	else:
		velocity.y = 0;
		
	if Input.is_action_just_pressed("ui_accept"):
		_fire();
	
	move_and_slide(velocity);
	
	if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead();
	
	
func _fire():
		var inst = PROJECTILE.instance()
		inst.position = $Position2D.global_position
		get_parent().add_child(inst)
		inst.set_direction(get_global_mouse_position() - global_position);

func dead():
	queue_free();


