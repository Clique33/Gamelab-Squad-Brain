extends CharacterBody2D

enum TYPE_TRANSFORM{ROBOT,HUMAN}
var type_of_body: TYPE_TRANSFORM

@onready var human_animated_sprite: AnimatedSprite2D = $HumanAnimatedSprite
@onready var robot_animated_sprite: AnimatedSprite2D = $RobotAnimatedSprite

var speed: float = 4000.0
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO

var enemy_in_range = false

@onready var hp_hud: Node2D = $"../hp_hud"
@export var health: float = 100.0
@export var energy: float = 100.0

var is_dead: bool = false

@export var attack_basic: float
var attack_timer: float = 0.0
@export var attack_duration: float = 0.4 # Time in seconds
var enemy: Node2D = null

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO

@export var animated_sprite: AnimatedSprite2D

@onready var sword: Node2D = $Sword
@onready var sword_animation_player: AnimationPlayer = $Sword/SwordAnimationPlayer

@onready var hitbox: Area2D = $Sword/Node2D/Sprite2D/Hitbox

@export var transformation_limit: float
@onready var transformation_timer: Timer = $TransformationTimer
var time_part: float = 0.9


func _ready() -> void:
	add_to_group("Player")
	
	change_to(TYPE_TRANSFORM.HUMAN)

func change_to(type_transformation : TYPE_TRANSFORM = TYPE_TRANSFORM.ROBOT) -> void:
	if type_transformation == TYPE_TRANSFORM.ROBOT:
		human_animated_sprite.visible = false
		
		animated_sprite = robot_animated_sprite
	elif type_transformation == TYPE_TRANSFORM.HUMAN:
		robot_animated_sprite.visible = false
		
		animated_sprite = human_animated_sprite
	
	type_of_body = type_transformation
		
	animated_sprite.visible = true
	
	
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
	
	handle_sword_direction()
	
	attack_melee(delta)
	
	update_animation()
	
	uptade_energia()
	
	move_and_slide()


func update_animation() -> void:
	# invert direction do sprite righ to left
	if direction.y == 0:
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
	
	if not is_attacking():
		# manage sprite animation	
		if direction.y > 0:
			animated_sprite.play("walk_down")
		elif direction.y < 0:
			animated_sprite.play("walk_up")
		elif direction.x != 0:
			animated_sprite.play("walk_right")
		else:
			if last_direction.y > 0:
				animated_sprite.play("idle_down")
			elif last_direction.y < 0:
				animated_sprite.play("idle_up")
			elif last_direction.x != 0:
				animated_sprite.play("idle_right")	


func attack_melee(delta: float) -> void:
	if enemy_in_range and sword_animation_player.is_playing():
		attack_timer += delta
	
	if enemy_in_range and attack_timer >= attack_duration:
		enemy.update_health(attack_basic)

		if enemy.get_scene_file_path() != "res://scenes/enemy/turret.tscn":
			knockback_direction = (enemy.global_position - global_position).normalized()
		
			enemy.apply_knockback(knockback_direction, 75.0, 0.5)
		
		attack_timer = 0


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_in_range  = true
		print(body.get_scene_file_path())
		enemy = body


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_in_range  = false
		
		enemy = null
		
		attack_timer = 0


func update_health(value: int) -> void:
	health += value
	
	hp_hud.hp_bar_update(health)


func die() -> void:
	if health <= 0 and not is_dead:
		is_dead = true
		
		animated_sprite.play("die")


func _on_human_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "die":
		
		get_tree().change_scene_to_file("res://scenes/ui/endgame_screen.tscn")
		
		queue_free()


func _on_robot_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "die":
		
		get_tree().change_scene_to_file("res://scenes/ui/endgame_screen.tscn")
		
		queue_free()

func apply_knockback(direction_2: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction_2 * force
	
	knockback_timer = knockback_duration


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
			change_to(TYPE_TRANSFORM.ROBOT)
			
			attack_basic *= 2
			
			transformation_timer.start(transformation_limit)


func _on_change_timer_timeout() -> void:
	change_to(TYPE_TRANSFORM.HUMAN)
	
	attack_basic *= 1


func uptade_energia(value: int = -10) -> void:
	if type_of_body == TYPE_TRANSFORM.ROBOT:
		if transformation_timer.time_left - 0.1 <= transformation_limit * time_part:
			time_part -= 0.1
			
			energy += value

			hp_hud.energy_bar_update(energy)


func is_attacking() -> bool:
	return Input.is_action_just_pressed("attack")
	

func handle_sword_direction() -> void:
	if not sword_animation_player.is_playing():
		sword.hide()
	
		var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

		if mouse_direction.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif mouse_direction.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true

		sword.rotation = mouse_direction.angle()
		
		if sword.scale.y == 1 and mouse_direction.x < 0:
			sword.scale.y = -1
		elif sword.scale.y == -1 and mouse_direction.x > 0:
			sword.scale.y = 1
		
	if is_attacking() and not sword_animation_player.is_playing():
		sword.show()
		
		sword_animation_player.play("attack")
