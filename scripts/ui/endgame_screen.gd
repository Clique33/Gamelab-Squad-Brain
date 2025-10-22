extends Control

@onready var victory_title: Label = $VictoryTitle
@onready var death_title: Label = $DeathTitle

@onready var death_music: AudioStreamPlayer2D = $DeathMusic
@onready var victory_music: AudioStreamPlayer2D = $VictoryMusic


func _ready() -> void:
	victory_title.visible = false
	victory_music.stop()
	
	if Global.victories >= 2:
		death_music.stop()
		
		victory_music.play()
		
		endgame_victory()
		
		main_menu()
	
	Global.energy = 100
	
	Global.health = 100

func endgame_victory() -> void:
	death_title.visible = false
	
	victory_title.visible = true

func _on_main_menu_pressed() -> void:
	TransitionScene.change_scene("res://scenes/ui/main_menu.tscn")
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func main_menu() -> void:
	Global.last_world_positioin = Vector2.ZERO
	
	Global.health = 100
	Global.energy = 100
	Global.victories = 0

	Global.block_cave_plaines = false
	Global.block_cave_montains = false
