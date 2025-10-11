extends CharacterBody2D

var speed: float = 2000.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.ZERO
var direction_change_timer: float = 0.0
var direction_change_intervals: float = 3.0 # seconds

var old_position: Vector2 = Vector2.ZERO
var min_position: Vector2 = Vector2(250.0, 415.0)
var max_position: Vector2 = Vector2(450.0, 575.0)

var swoop_speed: float = 3000.0
var swoop: bool = false

var direction_to_player: Vector2 = Vector2.ZERO
var player = null
var player_in_range = false

var health: float = 10.0
@onready var health_bar: ProgressBar = $HealthBar
var is_dead: bool = false

var is_attacking: bool = false
var attack_timer: float = 0.0 # Timer in seconds to damage player
var attack_duration: float = 0.5

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO

signal damaged(amount)
signal attacked(cost)

func apply_damage(amount: int):
	emit_signal("damaged", amount)

func perform_attack(cost: int):
	emit_signal("attacked", cost)

func _ready() -> void:
	add_to_group("Enemy")
	
	pick_random_direction()


func _physics_process(delta: float) -> void:	
	die()
	
	if is_dead: # Skip animation update
		return	
	
	if knockback_timer > 0.0:
		velocity = knockback
		
		knockback_timer -= delta
		
		if knockback_timer < 0.0:
			knockback = Vector2.ZERO
	else:
		if swoop:
			# Calculate the direction towards player
			direction_to_player = (player.position - position).normalized()
			# Update position towards the player using the swooping speed
			velocity = direction_to_player * swoop_speed * delta
			
			attack_melee(delta)
			
			update_animation(direction_to_player, true)
		else:
			# Increment the timer by the time since the last frame
			direction_change_timer += delta 
				# Pick a new random direstion every 5 sec
			if direction_change_timer >= direction_change_intervals:
				pick_random_direction()
				direction_change_timer = 0
			# Calculate velocity based on time	
			velocity = last_direction * speed * delta
			
			update_animation(last_direction)
	
	update_health()
	
	move_and_slide()
	
	# Check if position has been clamped to a boundary
	old_position = position
	
	position.x = clamp(position.x, min_position.x, max_position.x)
	position.y = clamp(position.y, min_position.y, max_position.y)
		
	# Reverse the direction by 180 if the enemy hits a boundary
	if old_position != position:
		last_direction = -last_direction
	
	
func pick_random_direction() -> void:
	var new_direction = Vector2.ZERO
	
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	
	last_direction = new_direction # Update last direction


func update_animation(direction: Vector2, swooping: bool = false) -> void:
	if player_in_range and swooping:
		animated_sprite_2d.play("drone_attack")
		
		animated_sprite_2d.flip_h = direction.x < 0
		
		animated_sprite_2d.flip_v = false
		
		return
	
	# Reset flips for the sprite
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.flip_v = false
	
	if direction.y < 0:
		animated_sprite_2d.play("move_up")
	elif direction.y > 0:
		animated_sprite_2d.play("move_up")
		
		# Flip vertically down
		animated_sprite_2d.flip_v = false
	elif direction.x != 0:
		animated_sprite_2d.play("move_right")
		
		# Flip horizontally to the left
		animated_sprite_2d.flip_h = last_direction.x < 0
	
	return


func attack_melee(delta: float) -> void:
	if is_attacking:
		attack_timer += delta
	
	if attack_timer >= attack_duration:
		if player_in_range:
			player.health -= 10
			emit_signal("damaged", 10)
			knockback_direction = (player.global_position - global_position).normalized()
		
			player.apply_knockback(knockback_direction, 100, 0.5)
		
		attack_timer = 0.0


func _on_magpie_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		
		is_attacking = true
		
		swoop_speed = 0
		 
		

func _on_magpie_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		
		is_attacking = false
		
		update_animation(last_direction)
		
		swoop_speed = 3000.0


func _on_territory_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		
		swoop = true # Star swooping toward the player


func _on_territory_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		
		swoop = false # Stop swooping toward the player
		
		pick_random_direction()
		
		update_animation(last_direction)


func update_health() -> void:
	health_bar.value = health
	
	if health >= 50:
		health_bar.visible = false
	else:
		health_bar.visible = true


func die() -> void:
	if health <= 0 and not is_dead:
		is_dead = true

		animated_sprite_2d.play("drone_die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "drone_die":
		queue_free()

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	
	knockback_timer = knockback_duration
