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

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_FreezeTimer_timeout():
	set_linear_velocity(lin_vel)
