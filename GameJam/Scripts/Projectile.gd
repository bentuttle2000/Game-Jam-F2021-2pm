extends Area2D

const SPEED = 100;

var direction = Vector2();
var velocity = Vector2();
var power = 1;

func set_direction(dir):
	direction = dir;

func set_power(p):
	power = p;

func _physics_process(delta):
	$Sprite.scale.x = power;
	$Sprite.scale.y = power;
	velocity.x = SPEED * delta * direction.normalized().x;
	velocity.y = SPEED * delta * direction.normalized().y;
	translate(velocity);

func _on_Projectile_body_entered(body):
	if "Enemy" in body.name:
		body.dead();
		#Allows for projectile to penetrate targets when charged
		power = power - 0.2;
		if power <= 1.2:
			queue_free();


func _on_VisibilityNotifier2D_screen_exited():
	queue_free();
