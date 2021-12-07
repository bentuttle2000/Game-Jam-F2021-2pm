extends Area2D

const SPEED = 60
var velocity = Vector2()
var direction = 1

func set_direction(dir):
	direction = dir
	
func _physics_process(delta):
	velocity.x = SPEED * delta * direction.normalized().x;
	velocity.y = SPEED * delta * direction.normalized().y;
	translate(velocity);
	
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
	




func _on_IceBall_body_entered(body):
	if "Enemy" in body.name:
		body.frozen()
		queue_free()
