extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if not Main.nostra_active:
		get_input()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
