extends KinematicBody2D;

const SPEED = 250;

var velocity = Vector2();

enum DIR {NULL, LEFT, RIGHT, DOWN, UP}; #directional movements

var moveX = DIR.NULL;
var moveY = DIR.NULL;

const PROJECTILE = preload("res://Objects/Projectile.tscn");
const LIGHTPROJECTILE = preload("res://Objects/LightProjectile.tscn");
const ICEBALL = preload("res://Objects/IceBall.tscn");

enum STATE {IDLE, MOVING, CHARGING, FIRING};

var curState = STATE.IDLE;

var goldCnt = 0;
var spellNum = Globalvars.spellNum;
var chargeAmount = 1.0;
const chargeRate = .025;
const chargeMax = 2.0;
var hp = Globalvars.hp;
var light_proj = 0;

var isDead = false
var vulnerable = true
var active_shield = false
var ice_powerup = Globalvars.ice_powerup

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
			
			
		if (Input.is_action_just_pressed("right_click")) && (Globalvars.ice_powerup == true):
			_ice_fire()
	
		if get_slide_count() > 0:
				for i in range(get_slide_count()):
					if "Enemy" in get_slide_collision(i).collider.name:
						dead(1);
						
	if Globalvars.hp == 1:
		$HealthBar.play("Health1")
	if Globalvars.hp == 2:
		$HealthBar.play("Health2")
	if Globalvars.hp == 3:
		$HealthBar.play("Health3")
		
	if active_shield == false:
		$ShieldCollision.set_deferred("disabled", true)
		$Shield.visible = false
	if active_shield == true:
		$ShieldCollision.set_deferred("disabled", false)
		$Shield.visible = true

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
		if Globalvars.spellNum == 0:
			var inst = PROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst.set_direction(get_global_mouse_position() - global_position);
			inst.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;
		elif light_proj == 1:
			var inst = LIGHTPROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst.set_direction(get_global_mouse_position() - global_position);
			inst.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;
		elif Globalvars.spellNum == 2:
			var inst = PROJECTILE.instance();
			var inst1 = PROJECTILE.instance();
			var inst2 = PROJECTILE.instance();
			inst.position = get_child(0).getWandPosition();
			get_parent().add_child(inst);
			inst1.position = get_child(0).getWandPosition();
			get_parent().add_child(inst1);
			inst2.position = get_child(0).getWandPosition();
			get_parent().add_child(inst2);
			var t = Timer.new()
			t.set_wait_time(.1)
			t.set_one_shot(true)
			self.add_child(t)
			inst.set_direction((get_global_mouse_position() - global_position));
			inst.set_power(chargeAmount);
			t.start()
			yield(t, "timeout")
			inst1.set_direction((get_global_mouse_position() - global_position));
			inst1.set_power(chargeAmount);
			t.start()
			yield(t, "timeout")
			inst2.set_direction(get_global_mouse_position() - global_position);
			inst2.set_power(chargeAmount);
			chargeAmount = 1;
			curState = STATE.IDLE;

func flashup_powerup():
	light_proj = 1

func multishot_powerup():
	Globalvars.spellNum = 2


func dead(damage):
	if vulnerable == false:
		return
	
	if vulnerable == true:
		Globalvars.hp = Globalvars.hp - damage
		vulnerable = false
		$DamageCooldown.start()
		if  Globalvars.hp <= 0:
			isDead = true
			Globalvars.hp = 0
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
	Globalvars.reset_vars()

func _on_DamageCooldown_timeout():
	vulnerable = true
	
func health_pickup():
	if Globalvars.hp < 3 && Globalvars.hp != 0:
		Globalvars.hp = Globalvars.hp + 1
	else:
		Globalvars.hp = Globalvars.hp + 0

func shield_powerup():
	$ShieldTimer.start()
	active_shield = true
	vulnerable = false
	
func ice_powerup():
	Globalvars.ice_powerup = true
	
func _on_ShieldTimer_timeout():
	active_shield = false
	vulnerable = true

func _ice_fire():
	var iceball = ICEBALL.instance()
	iceball.set_direction(get_global_mouse_position() - global_position);
	get_parent().add_child(iceball);
	iceball.position = get_child(0).getWandPosition();
	
