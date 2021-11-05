extends Area2D

#Original Projectile code writted by Ben Tuttle
#Edited By Nick Mineo
const SPEED = 50;

var direction = Vector2();
var velocity = Vector2();
var power = 1;

func set_direction(dir):
	direction = dir;

func set_power(p):
	power = p;

func _physics_process(delta):
	$Light2D.energy = power / 2;
	$Sprite.scale.x = power;
	$Sprite.scale.y = power;
	velocity.x = SPEED * power * delta * direction.normalized().x;
	velocity.y = SPEED * power * delta * direction.normalized().y;
	translate(velocity);


func _on_LightProjectile_body_entered(body):
	if "Enemy" in body.name:
		body.dead();
	queue_free();


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
