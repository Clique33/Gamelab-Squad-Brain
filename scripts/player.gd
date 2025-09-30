extends CharacterBody2D

var speed: float = 4000.0
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var enemy_in_range = false

var health: float = 100.0
@onready var health_bar: ProgressBar = $HealthBar
var is_dead: bool = false

var is_attacking: bool = false
var attack_timer: float = 0.0
var attack_duration: float = 0.5 # Time in seconds
var enemy: Node2D = null

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("Player")


func _physics_process(delta: float) -> void:
	die()
	
	if is_dead:
		return
		
	if knockback_timer > 0.0:
		velocity = knockback
		
		knockback_timer -= delta
		
		if knockback_timer < 0.0:
			knockback = Vector2.ZERO
	else:	
		# Get the input direction
		# x is -1 if "left" is pressed, 1 if "rigth" is pressed, 0 otherwisew
		# y is -1 if "left" is pressed, 1 if "rigth" is pressed, 0 otherwise
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		velocity = direction * speed * delta
		
		if direction != Vector2.ZERO:
			last_direction = direction
	
	update_health()
	
	attack_melee(delta)
	
	update_animation()
	
	move_and_slide()


func update_animation() -> void:
	# invert direction do sprite righ to left
	if direction.y == 0:
		if direction.x > 0:
			animated_sprite_2d.flip_h = false
		elif direction.x < 0:
			animated_sprite_2d.flip_h = true
	
	if is_attacking:
		# manage sprite animation	
		if direction.y > 0:
			animated_sprite_2d.play("attack_down")
		elif direction.y < 0:
			animated_sprite_2d.play("attack_up")
		elif direction.x != 0:
			animated_sprite_2d.play("attack_right")
		else:
			if last_direction.y > 0:
				animated_sprite_2d.play("attack_down")
			elif last_direction.y < 0:
				animated_sprite_2d.play("attack_up")
			elif last_direction.x != 0:
				animated_sprite_2d.play("attack_right")
	else:
		# manage sprite animation	
		if direction.y > 0:
			animated_sprite_2d.play("walk_down")
		elif direction.y < 0:
			animated_sprite_2d.play("walk_up")
		elif direction.x != 0:
			animated_sprite_2d.play("walk_right")
		else:
			if last_direction.y > 0:
				animated_sprite_2d.play("idle_down")
			elif last_direction.y < 0:
				animated_sprite_2d.play("idle_up")
			elif last_direction.x != 0:
				animated_sprite_2d.play("idle_right")	


func attack_melee(delta: float) -> void:
	if is_attacking:
		attack_timer += delta
	
	if attack_timer >= attack_duration:
		if enemy_in_range:
			enemy.health -= 10
			
			knockback_direction = (enemy.global_position - global_position).normalized()
		
			enemy.apply_knockback(knockback_direction, 100, 0.5)
			
		is_attacking = false
		
		attack_timer = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_melee"):
		is_attacking = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_in_range  = true
		
		enemy = body


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_in_range  = false
		
		enemy = null


func update_health() -> void:
	# Update healthbar
	
	health_bar.value = health
	
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true


func die() -> void:
	if health <= 0 and not is_dead:
		is_dead = true
		
		animated_sprite_2d.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "die":
		queue_free()


func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	
	knockback_timer = knockback_duration
