extends Node2D

@export var BULLET: PackedScene = null

var target: Node2D = null
var new_target: Node2D = null
var bullet_element: Node2D = null

@onready var gun_animated_sprite_2d: AnimatedSprite2D = $GunAnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var reload_timer: Timer = $RayCast2D/ReloadTimer

var angle_to_target: float

@export var health: float 
@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	target = find_target()


func _process(delta: float) -> void:
	if health <= 0: # Skip animation update and kill the enemy
		#animated_sprite_2d.play("turret_die")
		#queue_free()
		
		return	
	
	if target != null:
		angle_to_target = global_position.direction_to(target.global_position).angle()
		
		ray_cast_2d.global_rotation = angle_to_target
		
		if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider().is_in_group("Player"):
			gun_animated_sprite_2d.rotation = angle_to_target
			
			if reload_timer.is_stopped():
				gun_animated_sprite_2d.play()
				
				shoot()
			
			
func shoot() -> void:
	ray_cast_2d.enabled = false

	if BULLET:
		bullet_element = BULLET.instantiate()
		
		get_tree().current_scene.add_child(bullet_element)
		
		bullet_element.global_position = global_position
		
		bullet_element.global_rotation = ray_cast_2d.rotation
	
	reload_timer.start()


func find_target() -> Node2D:
	new_target = null

	if get_tree().has_group("Player"):
		new_target = get_tree().get_nodes_in_group("Player")[0]
		
	return new_target


func _on_reload_timer_timeout() -> void:
	ray_cast_2d.enabled = true


func update_health(value: int) -> void:
	health += value
		
	health_bar.value = health
	
	if health == health_bar.max_value or health <= 0:
		health_bar.visible = false
	else:
		health_bar.visible = true
