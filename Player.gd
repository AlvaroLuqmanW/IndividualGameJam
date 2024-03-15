extends KinematicBody2D

const MOVE_SPEED = 300
const bullet = preload("res://Bullet.tscn")

onready var raycast = $RayCast2D

export var type = "Player"
export var rescued = 0

var health = 100.0
var ammo : int = 30
var magazine : int = 120
var cooldown = false
var isReloading = false

func _ready():
	yield(get_tree(), "idle_frame")
	add_to_group("player")
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_just_pressed("toggle_follow"):
		get_tree().call_group("survivors", "toggleFollow", "follow")
	if Input.is_action_just_pressed("toggle_stop"):
		get_tree().call_group("survivors", "toggleFollow", "stop")
	if Input.is_action_just_pressed("reload"):
		reload()
		
	move_vec = move_vec.normalized()
# warning-ignore:return_value_discarded
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_pressed("shoot"):
		if ammo > 0 and not cooldown and not isReloading:
			shoot()
			cooldown = true
			yield(get_tree().create_timer(0.2), "timeout")
			cooldown = false
			
	$Node2D.look_at(get_global_mouse_position())
	
	#var damage_rate = 10.0
	#var overlapping_mobs = $Area2D.get_overlapping_bodies()
	#if overlapping_mobs.size() > 0:
		#if overlapping_mobs[0].type == "Zombie":
			#health -= damage_rate * overlapping_mobs.size() * delta
		#elif overlapping_mobs[0].type == "Survivor":
			#rescued += 1
	$CanvasLayer/Magazine.text = str(magazine)
	$CanvasLayer/ProgressBar.value = health
	$CanvasLayer/RescuedCount.text = str(rescued)
	
	if health <= 0:
		kill()
			
func shoot():
	var projectile = bullet.instance()
	get_parent().add_child(projectile)
	projectile.global_position = $Node2D/Position2D.global_position
	projectile.global_rotation = $Node2D/Position2D.global_rotation
	#$Node2D/Position2D.add_child(projectile)
	#projectile.velocity = get_global_mouse_position() - projectile.position
	ammo -= 1
	$CanvasLayer/Ammo.text = str(ammo)
	#if ammo == 0:
		#reload()
		
		

func take_damage(damage, delta):
	health -= damage * delta
	if health <= 0:
		kill()

func heal(amount):
	health += amount

func resupply(amount):
	magazine += amount
	
func reload():
	if magazine == 0:
		print("Out of magazine!")
		return
	if ammo == 30:
		return
	else:
		isReloading = true
		print("Reloading magz")
		$CanvasLayer/Reloading.percent_visible = 1
		yield(get_tree().create_timer(3.5), "timeout")		
		var requiredAmmo = 30 - ammo
		if magazine >= requiredAmmo:
			magazine -= requiredAmmo
			ammo += requiredAmmo
		else:
			ammo += magazine
			magazine = 0
		$CanvasLayer/Ammo.text = str(ammo)
		print("Reloaded")
		$CanvasLayer/Reloading.percent_visible = 0
		isReloading = false
		
func rescue():
	rescued += 1
	
func reset():
	health = 100.0
	ammo = 30
	magazine = 120
	rescued = 0

func set_total_survivor(n):
	var total_survivor = "/" + str(n)
	$CanvasLayer/TotalSurvivors.text = total_survivor
	
func kill():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
