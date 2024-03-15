extends KinematicBody2D

var MOVE_SPEED = 150

export var type = "Survivor"
export var isExtracted = false

var player = null
var health = 100
var isMoving = false
var isRescued = false

func _ready():
	add_to_group("survivors")

func _physics_process(delta):
	if not isExtracted:
		if isRescued:
			if isMoving:
				follow(player, delta)
	else:
		MOVE_SPEED = 0
		isMoving = false
		$CollisionShape2D.disabled = true
		
func follow(player, delta):
	if player == null:
		return
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)


func toggleFollow(command):
	if not isRescued:
		return
	if command == "stop":
		MOVE_SPEED = 0
		isMoving = false
	else:
		MOVE_SPEED = 150
		isMoving = true
	
func kill():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "TileMap":
		return
	if body.type == "Player":
		if isRescued:
			return
		else:
			player = body
			isRescued = true
			isMoving = true
			get_tree().call_group("player", "rescue")
		
	
