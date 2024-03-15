extends Node2D

func _ready():
	get_tree().call_group("player", "set_total_survivor", 7)

func _physics_process(delta):
	get_tree().call_group("player", "set_total_survivor", 7)


