extends Area2D

var rescued_survivors = 0

func _physics_process(delta):
	if rescued_survivors == 7:
		get_tree().change_scene("res://Finish.tscn")

func _on_Area2D10_body_entered(body):
	if body.name == "TileMap":
		return
	if body.type == "Survivor":
		rescued_survivors += 1
		body.isExtracted = true
	else:
		return
