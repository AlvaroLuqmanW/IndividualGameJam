extends Node2D

func _ready():
	pass # Replace with function body.

func _on_Play_pressed():
	get_tree().change_scene("res://Site1.tscn")
	

func _on_Quit_pressed():
	get_tree().quit()
	
