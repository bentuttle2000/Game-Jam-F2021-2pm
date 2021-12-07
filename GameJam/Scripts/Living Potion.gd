extends KinematicBody2D


export var HP = 1
export var isBoss = false;
export var BossNumber = 0;
var is_dead = false;
export var SPEED = 100;
const BOSSONEPOWER = preload("res://Objects/MultiShotPowerUp.tscn");
var PlayerPosition = Vector2();
var CurrentPosition = Vector2();
var velocity = Vector2();
var player = null;
var stun = false;

func _process(delta):
	if !is_dead:
		if !isBoss:
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("BossIdle")
	if stun == false:
		if player:
			velocity = position.direction_to(player.position) * SPEED
		velocity = move_and_slide(velocity)
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "TileMap" in get_slide_collision(i).collider.name:
					bonk()

func bonk():
	stun = true;
	dead()
	$StunTimer.start()



func dead():
	HP -= 1
	if HP <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		if !isBoss:
			$AnimatedSprite.play("Dead")
		else:
			$AnimatedSprite.play("BossDead")
			if BossNumber == 1:
				var inst = BOSSONEPOWER.instance();
				inst.position = global_position;
				get_parent().add_child(inst);
		is_dead = true;
		$Timer.start();


func _on_Timer_timeout():
	queue_free();


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		player = body


func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		player = null


func _on_StunTimer_timeout():
	stun = false
