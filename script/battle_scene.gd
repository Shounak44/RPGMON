extends Node2D

# Health variables
var player_health := 100.0
var enemy_health := 100.0
var is_player_turn := true
var is_defending := false

# Node references
@onready var player_sprite := $PlayerMonster/AnimatedSprite2D
@onready var enemy_sprite := $EnemyMonster/AnimatedSprite2D
@onready var player_health_bar := $UI/PlayerHealth
@onready var enemy_health_bar := $UI/EnemyHealth
@onready var attack_button := $UI/Attack
@onready var defend_button := $UI/Defend

func _ready():
	update_health_bars()
	attack_button.pressed.connect(_on_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	start_player_turn()

func update_health_bars():
	player_health_bar.value = player_health
	enemy_health_bar.value = enemy_health

func start_player_turn():
	is_player_turn = true
	is_defending = false
	attack_button.disabled = false
	defend_button.disabled = false

func _on_attack_pressed():
	if not is_player_turn: return
	
	attack_button.disabled = true
	defend_button.disabled = true
	
	player_sprite.play("attack")
	await player_sprite.animation_finished
	
	var damage = randf_range(10, 20)
	enemy_health = max(enemy_health - damage, 0)
	enemy_health_bar.value = enemy_health
	
	if enemy_health <= 0:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/jungle.tscn")  # Updated path
		return
	
	player_sprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	enemy_turn()

func _on_defend_pressed():
	if not is_player_turn: return
	
	attack_button.disabled = true
	defend_button.disabled = true
	is_defending = true
	
	await get_tree().create_timer(0.5).timeout
	enemy_turn()

func enemy_turn():
	is_player_turn = false
	
	if randf() < 0.8:  # 80% chance to attack
		enemy_sprite.play("attack")
		await enemy_sprite.animation_finished
		
		var damage = randf_range(10, 20)
		if is_defending:
			damage *= 0.5
		
		player_health = max(player_health - damage, 0)
		player_health_bar.value = player_health
		
		if player_health <= 0:
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scene/main_menu.tscn")  # Updated path
			return
		
		enemy_sprite.play("idle")
	else:
		await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(0.5).timeout
	start_player_turn()
