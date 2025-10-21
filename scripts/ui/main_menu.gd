extends Control

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var options: Panel = $Options
@onready var credits: Panel = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TransitionScene.first_fade()
	
	main_buttons.visible = true
	
	options.visible = false
	
	credits.visible = false


func _on_start_game_pressed() -> void:
	TransitionScene.change_scene("res://scenes/lab_inicial.tscn")


func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	
	
func _on_back_options_pressed() -> void:
	main_buttons.visible = true
	
	options.visible = false
	
	credits.visible = false
	
	
func _on_credits_pressed() -> void:
	main_buttons.visible = false
	credits.visible = true
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()
