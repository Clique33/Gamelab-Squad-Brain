extends CharacterBody2D

class_name MainCharacter

enum States {IDLE, WALKING, FLYING, STUNNED, ATTACKING, CHARGING, DODGING}

signal health_updated(new_health, max_health)
signal energy_updated(new_energy, max_energy)
signal died

@export var health_max: float = 1
@export var energy_max: float = 1
@export var speed: float = 400
@export var speed_multiplier: float = 1
@export var dash_duration: float = 1
@export var dash_speed: float = 1
@export var attack_power: float = 1
var health: float
var energy: float
var state: States
var current_interactable = null
var aim_direction: Vector2 = Vector2.ZERO

@onready var interaction_area: Area2D = $InteractionBox
@onready var dash_timer: Timer = $DashTimer
@onready var basic_attack_timer: Timer = $BasicAttackTimer

func _ready():
	health = health_max
	energy = energy_max
	state = States.IDLE
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

func _physics_process(delta):
	handle_movement_input()
	move_and_slide()
	
func handle_movement_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _on_interaction_area_entered(area):
	current_interactable = area.owner
	print("Entered range of:", current_interactable.name)

func _on_interaction_area_exited(area):
	if area.owner == current_interactable:
		current_interactable = null
		print("Left range of:", area.owner.name)

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		if current_interactable:
			current_interactable.interact(self)
