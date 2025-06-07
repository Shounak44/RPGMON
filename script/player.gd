extends CharacterBody2D

@export var speed := 200.0
@onready var anim := $AnimatedSprite2D

func _physics_process(_delta):
	var dir = Vector2.ZERO

	if Input.is_key_pressed(KEY_W):
		dir.y -= 1
	elif Input.is_key_pressed(KEY_S):
		dir.y += 1

	if Input.is_key_pressed(KEY_A):
		dir.x -= 1
	elif Input.is_key_pressed(KEY_D):
		dir.x += 1

	dir = dir.normalized()
	velocity = dir * speed
	move_and_slide()  # ← handles collision but no gravity now

	if dir == Vector2.ZERO:
		anim.play("idle")
	else:
		if dir.y < 0:
			anim.play("walk_up")
		elif dir.y > 0:
			anim.play("walk_down")
		elif dir.x < 0:
			anim.play("walk_left")
		elif dir.x > 0:
			anim.play("walk_right")
