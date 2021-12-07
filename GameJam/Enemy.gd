extends KinematicBody2D

export var HP = 1
export var isBoss = false;
export var BossNumber = 0;
var is_dead = false;
export(int) var SPEED = 75;
const BOSSONEPOWER = preload("res://Objects/MultiShotPowerUp.tscn");
var PlayerPosition = Vector2();
var CurrentPosition = Vector2();
var velocity = Vector2();

func _process(delta):
	if !is_dead:
		if !isBoss:
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("BossIdle")
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

		if get_slide_count() > 0:
			for i in range (get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.dead(1)

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
	
func frozen():
	$IceTimer.start()
	SPEED = 0
	
func _on_IceTimer_timeout():
	SPEED = 75
