extends Area2D

signal hit
signal camera_shake_requested
signal item_pickup(area)



var IS_WM_DEBUG: bool = true


var speed: int = 200
var dash_speed: int = speed * 5

var is_dashing: bool = false
var can_dash: bool = true

var is_hidden = false

var screensize

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


var DashGhost = preload("res://src/Actors/DashGhost.tscn")


onready var SpriteNode: AnimatedSprite = get_node("AnimatedSprite")
onready var DashTimer: Timer = get_node("DashTimer")
onready var DashCooldown: Timer = get_node("DashCooldown")
onready var GhostCooldownTimer: Timer = get_node("GhostSpawnCooldown")
onready var Hitbox: CollisionShape2D = get_node("CollisionShape2D")


func _ready():
	screensize = get_viewport_rect().size
	if IS_WM_DEBUG:
		screensize.x = 480
		screensize.y = 720
	hide_self()


func _process(delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x += -1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
	
	if is_dashing:
		velocity = direction * dash_speed
	else:
		velocity = direction * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)


func _input(event):
	if Input.is_action_just_pressed("dash") and !is_dashing and can_dash and !is_hidden:
		start_dash()


func start(pos):
	position = pos
	show()
	Hitbox.disabled = false
	is_hidden = false


func start_dash():
	can_dash = false
	is_dashing = true
	Hitbox.disabled = true
	DashTimer.start()
	GhostCooldownTimer.start()
	


func stop_dash():
	Hitbox.disabled = false
	is_dashing = false
	DashCooldown.start()
	GhostCooldownTimer.stop()


func spawn_dash_ghost():
	var dghost = DashGhost.instance()
	get_parent().add_child(dghost)
	
	dghost.global_position = global_position
	dghost.texture = SpriteNode.get_sprite_frames().get_frame(SpriteNode.animation, SpriteNode.get_frame())
	dghost.flip_h = false if scale.x == 1 else true
	dghost.scale = SpriteNode.scale


func hide_self():
	hide()
	is_hidden = true


func _on_Player_body_entered(body):
	hide_self()
	emit_signal("hit")
	emit_signal("camera_shake_requested")


func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		emit_signal("item_pickup", area)


func _on_DashTimer_timeout():
	stop_dash()

func _on_DashCooldown_timeout():
	can_dash = true

func _on_GhostSpawnCooldown_timeout():
	spawn_dash_ghost()
