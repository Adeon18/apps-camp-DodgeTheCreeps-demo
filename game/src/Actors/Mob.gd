extends RigidBody2D

export var min_speed: int = 100
export var max_speed: int = 300

var lin_vel

var mob_types = ["walk", "swim", "fly"]


func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func freeze():
	lin_vel = get_linear_velocity()
	set_linear_velocity(Vector2.ZERO)
	$FreezeTimer.start()

func die():
	$DeathParticle.emitting = true
	$AnimatedSprite.modulate.a = 0.0
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	die()

func _on_FreezeTimer_timeout():
	set_linear_velocity(lin_vel)
