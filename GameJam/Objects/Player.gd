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
	
func _fire():
		var inst = PROJECTILE.instance()
		inst.position = $Position2D.global_position
		get_parent().add_child(inst)
		inst.set_direction(get_global_mouse_position() - global_position);

#----Set active parameters for player physics which are rendered inactive upon entering dialogue----#
#-Nick Mineo-#
func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)

