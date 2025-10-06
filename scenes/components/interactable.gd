extends Node2D

class_name Interactable

signal interacted()

enum States {LOCKED, UNLOCKED}
var state: States
var pop_up: Label

func _ready():
	pop_up = $Label

func _init():
	state = States.UNLOCKED

func interact():
	if state == States.UNLOCKED:
		interacted.emit()

func _on_area_2d_area_entered() -> void:
	if state == States.UNLOCKED:
		pop_up.visible = true
	elif state == States.LOCKED:
		pop_up.visible = false


func _on_area_2d_area_exited() -> void:
	pop_up.visible = false
