extends KinematicBody2D

var travelled_distance = 0
const SPEED = 1500
const RANGE = 1200

func _physics_process(delta):
	#var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()

func _on_Area2D_body_entered(body):
	queue_free()
	if body.name == "TileMap":
		return
	if body.type == "Zombie" or body.type == "Object":
		if body.has_method("take_damage"):
			body.take_damage(25)
		
	


