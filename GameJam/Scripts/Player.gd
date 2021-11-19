extends KinematicBody2D;

const SPEED = 250;

var velocity = Vector2();

enum DIR {NULL, LEFT, RIGHT, DOWN, UP}; #directional movements

var moveX = DIR.NULL;
var moveY = DIR.NULL;

const PROJECTILE = preload("res://Objects/Projectile.tscn");
const LIGHTPROJECTILE = preload("res://Objects/LightProjectile.tscn");

enum STATE {IDLE, MOVING, CHARGING, FIRING};

var curState = STATE.IDLE;

var goldCnt = 0;
var spellNum = 0;
var chargeAmount = 1.0;
const chargeRate = .025;
const chargeMax = 2.0;
var hp = 3;

var isDead = false
var vulnerable = true

func _process(delta):
	#aim wand at mouse
	if !isDead:
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
						dead(1);
						
	if hp == 1:
		$HealthBar.play("Health1")
	if hp == 2:
		$HealthBar.play("Health2")
	if hp == 3:
		$HealthBar.play("Health3")

#function called every pass that will move the player based on keyboard input
#written by Ben Tuttle
func _move():	
	#check if moving x direction
	if Input.is_action_pressed("ui_right"): 
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("IdleRight")
		moveX = DIR.RIGHT;
	elif Input.is_action_pressed("ui_left"): 
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("IdleRight")
		moveX = DIR.LEFT;
	else:
		moveX = DIR.NULL;

	#check if moving y direction
	if Input.is_action_pressed("ui_down"):
		$AnimatedSprite.play("IdleDown") 
		moveY = DIR.DOWN;
	elif Input.is_action_pressed("ui_up"): 
		$AnimatedSprite.play("IdleUp")
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
		if spellNum == 0:
			var inst = PROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst.set_direction(get_global_mouse_position() - global_position);
			inst.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;
		elif spellNum == 1:
			var inst = LIGHTPROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst.set_direction(get_global_mouse_position() - global_position);
			inst.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;
		elif spellNum == 2:
			var inst = PROJECTILE.instance();
			var inst1 = LIGHTPROJECTILE.instance();
			var inst2 = PROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst1.position = get_child(0).getWandPosition();
			get_parent().add_child(inst1);
			inst2.position = get_child(0).getWandPosition();
			get_parent().add_child(inst2);
			inst.set_direction((get_global_mouse_position() - global_position));
			inst.set_power(chargeAmount);
			inst1.set_direction((get_global_mouse_position() - global_position));
			inst1.set_power(chargeAmount);
			inst2.set_direction(get_global_mouse_position() - global_position);
			inst2.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;

func flashup_powerup():
	spellNum = 1

func multishot_powerup():
	spellNum = 2


func dead(damage):
	if vulnerable == true:
		hp = hp - damage
		vulnerable = false
		$DamageCooldown.start()
		if  hp <= 0:
			isDead = true
			hp = 0
			velocity = Vector2(0, 0)
			$AnimatedSprite.play("Dead")
			$HealthBar.play("Health0")
			$CollisionShape2D.set_deferred("disabled", true)
			$Timer.start()

#----Set active parameters for player physics which are rendered inactive upon entering dialogue----#
#-Nick Mineo-#
func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)


func _on_Timer_timeout():
	get_tree().change_scene("res://Stages/LoseScreen.tscn")


func _on_DamageCooldown_timeout():
	vulnerable = true
