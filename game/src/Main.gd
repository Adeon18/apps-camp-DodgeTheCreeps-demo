extends Node2D


export var Mob: PackedScene
export var Coin: PackedScene

var IS_WM_DEBUG: bool = true

var screensize

var score: int = 0

func _ready():
	randomize()
	screensize = get_viewport_rect().size
	print(screensize)
	if IS_WM_DEBUG:
		screensize.x = 480
		screensize.y = 720
	print(screensize)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	$Enemies.add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$CoinTimer.start()



func _on_CoinTimer_timeout():
	var coin_position = Vector2(randi()%int(screensize.x), randi()%int(screensize.y))
	var coin = Coin.instance()
	add_child(coin)
	coin.position = coin_position


func _on_Player_item_pickup(area):
	if area.get_name() == "Freeze":
		for node in $Enemies.get_children():
			node.freeze()
	elif area.get_name() == "Coin":
		score += 2
		$HUD.update_score(score)
