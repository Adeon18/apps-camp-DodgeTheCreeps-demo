extends Node2D

export var Mob: PackedScene
export var Coin: PackedScene
export var Item: PackedScene

var IS_WM_DEBUG: bool = true

var screensize

var can_spawn_new_enemies: bool = true

var item_types = ["freeze", "kill_all", "speed", "size_down"]

func _ready():
	randomize()
	screensize = get_viewport_rect().size
	if IS_WM_DEBUG:
		screensize.x = 480
		screensize.y = 720
	print(screensize)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$CoinTimer.stop()
	$ItemTimer.stop()
	for node in $Items.get_children():
		node.queue_free()
	for node in $Enemies.get_children():
		node.queue_free()

func new_game():
	Global.score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(Global.score)
	$HUD.show_message("Get Ready")


func _on_MobTimer_timeout():
	if can_spawn_new_enemies:
		$MobPath/MobSpawnLocation.set_offset(randi())
		var mob = Mob.instance()
		$Enemies.add_child(mob)
		var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
		mob.position = $MobPath/MobSpawnLocation.position
		direction += rand_range(-PI / 4, PI / 4)
		mob.rotation = direction
		mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))


func _on_ScoreTimer_timeout():
	Global.score += 1
	$HUD.update_score(Global.score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$CoinTimer.start()
	$ItemTimer.start()

func _on_CoinTimer_timeout():
	var coin_position = Vector2(randi()%int(screensize.x), randi()%int(screensize.y))
	var coin = Coin.instance()
	$Items.add_child(coin)
	coin.position = coin_position


func _on_Player_item_pickup(area):
	if area.get_type() == "freeze":
		for node in $Enemies.get_children():
			node.freeze()
		can_spawn_new_enemies = false
		yield(get_tree().create_timer(3), "timeout")
		can_spawn_new_enemies = true
	elif area.get_type() == "Coin":
		Global.score += 5
		$HUD.update_score(Global.score)
	elif area.get_type() == "speed":
		$Player.change_speed(300)
	elif area.get_type() == "kill_all":
		for node in $Enemies.get_children():
			node.queue_free()
	elif area.get_type() == "size_down":
		$Player.size_down()
		


func _on_ItemTimer_timeout():
	var item_position = Vector2(randi()%int(screensize.x), randi()%int(screensize.y))
	var item = Item.instance()
	$Items.add_child(item)
	item.position = item_position
	item.set_type(item_types[randi()%item_types.size()])

