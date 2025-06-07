extends Area2D

@onready var anim = $grass_anim

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		anim.play("default")

func _on_body_exited(body):
	if body.name == "player":
		anim.stop()
