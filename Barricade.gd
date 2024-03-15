extends StaticBody2D

var health = 60

export var type = "Object"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
