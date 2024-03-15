extends Area2D

var rescued_survivors = 0

func _physics_process(delta):
	if rescued_survivors == 5:
		get_tree().change_scene("res://Site2.tscn")
		get_tree().call_group("player", "set_total_survivor", 7)

func _on_Area2D6_body_entered(body):
	if body.name == "TileMap":
		return
	if body.type == "Survivor":
		rescued_survivors += 1
		body.isExtracted = true
	else:
		return
