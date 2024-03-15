extends Area2D

func _physics_process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body.has_method("resupply"):
		body.resupply(60)
		queue_free()

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
