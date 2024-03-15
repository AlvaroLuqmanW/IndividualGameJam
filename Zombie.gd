extends KinematicBody2D

const MOVE_SPEED = 200

export var type = "Zombie"

var player = null
var health = 100
var zombie_texture : Texture = load("res://assets/zombie.png")
var hurt_texture : Texture = load("res://assets/zombie_hurt.png")
var isTouching = false

func _ready():
	add_to_group("zombies")

func _physics_process(delta):
	if player == null:
		return
	
	if global_position.distance_to(player.global_position) > 500:
		return
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if isTouching:
		deal_damage(player, 50, delta)
	
	
func deal_damage(target, damage, delta):
	if target.has_method("take_damage") and target.type == "Player":
		target.take_damage(damage, delta)
	
func take_damage(damage):
	health -= damage
	$Sprite.texture = hurt_texture
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.texture = zombie_texture
	if health <= 0:
		kill()
		
func kill():
	queue_free()

func set_player(p):
	player = p


func _on_Area2D_body_entered(body):
	if body.name == "TileMap":
		return
	if body.type == "Player":
		isTouching = true
				
func _on_Area2D_body_exited(body):
	if body.name == "TileMap":
		return
	if body.type == "Player":
		isTouching = false
	
