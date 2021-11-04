extends KinematicBody2D;

const SPEED = 50;

var velocity = Vector2();

enum DIR {NULL, LEFT, RIGHT, DOWN, UP}; #directional movements

var moveX = DIR.NULL;
var moveY = DIR.NULL;

const PROJECTILE = preload("res://Objects/Projectile.tscn");

enum STATE {IDLE, MOVING, CHARGING, FIRING};

var curState = STATE.IDLE;

var chargeAmount = 1.0;
const chargeRate = .025;
const chargeMax = 2.0;

func _process(delta):
	#aim wand at mouse
	get_child(0).look_at(get_global_mouse_position());
	
	#if holding attack button, charge. fire on release
	if Input.is_action_pressed("left_click"):
		_charge();
	elif curState == STATE.CHARGING:
		_fire();
	
	if (curState != STATE.CHARGING && curState != STATE.FIRING):
		_move();
	
	if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead();

#function called every pass that will move the player based on keyboard input
#written by Ben Tuttle
func _move():	
	#check if moving x direction
	if Input.is_action_pressed("ui_right"): 
		moveX = DIR.RIGHT;
	elif Input.is_action_pressed("ui_left"): 
		moveX = DIR.LEFT;
	else:
		moveX = DIR.NULL;

	#check if moving y direction
	if Input.is_action_pressed("ui_down"): 
		moveY = DIR.DOWN;
	elif Input.is_action_pressed("ui_up"): 
		moveY = DIR.UP;
	else:
		moveY = DIR.NULL;
	
	#if moving in both x and y (diagonal) cut speed in both directions in half to make consistant speed
	var curSpeed = SPEED;
	if (moveX != DIR.NULL && moveY != DIR.NULL):
		curSpeed /= 2.0;
	
	#set the players current velocity based on directions
	velocity = Vector2(0, 0);
	if moveX == DIR.RIGHT:
		velocity.x = curSpeed;
	if moveX == DIR.LEFT:
		velocity.x = -curSpeed;
	if moveY == DIR.DOWN:
		velocity.y = curSpeed;
	if moveY == DIR.UP:
		velocity.y = -curSpeed;
	
	#update state
	if (velocity == Vector2(0, 0)): #not moving
		curState = STATE.IDLE;
	else:
		curState = STATE.MOVING;
	
	#move
	move_and_slide(velocity);

#funciton while player holds the attack to charge a shot
#written by Ben Tuttle
func _charge():
	curState = STATE.CHARGING;
	chargeAmount += chargeRate;
	if chargeAmount > chargeMax:
		chargeAmount = chargeMax;
	

#function to fire the projectile when chargeing is released
#written by Ben Tuttle
func _fire():
		curState = STATE.FIRING;
		var inst = PROJECTILE.instance();
		inst.position = get_child(0).getWandPosition();
		get_parent().add_child(inst);
		inst.set_direction(get_global_mouse_position() - global_position);
		inst.set_power(chargeAmount);
		chargeAmount = 1;
		curState = STATE.IDLE;


func dead():
	get_tree().change_scene("res://Stages/LoseScreen.tscn")

#----Set active parameters for player physics which are rendered inactive upon entering dialogue----#
#-Nick Mineo-#
func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
