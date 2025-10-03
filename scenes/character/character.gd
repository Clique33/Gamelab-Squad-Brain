extends CharacterBody2D
class_name Character

const FRICTION: float = 0.15

@export var hp: int = 2
@export var acceleration: int = 40
@export var max_speed: int = 100

@onready var state_machine: FiniteStateMachine = get_node("FiniteStateMachine")
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var mov_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()


func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acceleration
	velocity = velocity.limit_length(max_speed)
	
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	hp -= dam
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force * 2
	
