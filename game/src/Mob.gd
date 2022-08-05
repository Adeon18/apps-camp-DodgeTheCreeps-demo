extends RigidBody2D

export var min_speed: int = 100
export var max_speed: int = 300

var mob_types = ["walk", "swim", "fly"]


func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
