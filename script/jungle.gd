extends Node2D

var encounter_timer : Timer

func _ready():
	# Create and configure timer
	encounter_timer = Timer.new()
	add_child(encounter_timer)
	encounter_timer.timeout.connect(_start_battle)
	encounter_timer.one_shot = true

func _on_grassarea_body_entered(body: CharacterBody2D):
	# Set random wait time (5-20 seconds)
	encounter_timer.start(randf_range(5, 20))

func _start_battle():
	get_tree().change_scene_to_file("res://scene/battle_scene.tscn")
