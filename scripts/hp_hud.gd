extends Node2D

@onready var hp_bar = $CanvasLayer/hp_bar
@onready var energy_bar = $CanvasLayer/energy_bar

@onready var player: CharacterBody2D = $"../Player"


func _ready() -> void:
	player.emit_health_update.connect(_on_health_update)
	
	player.emit_energy_update.connect(_on_energy_update)


func _on_health_update(new_health: float) -> void:
	hp_bar.value = new_health


func _on_energy_update(new_energy: float) -> void:
	energy_bar.value = new_energy
