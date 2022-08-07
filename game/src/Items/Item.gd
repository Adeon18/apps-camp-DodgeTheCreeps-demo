extends Area2D

class_name Item

var _type: String

var PowerupsSprites: Dictionary = {
	"freeze": "res://art/pickups/freeze.png",
	"speed": "res://art/pickups/speedup.png",
	"kill_all": "res://art/pickups/kill_all.png",
	"size_down": "res://art/pickups/size_down.png"
}

func set_type(type):
	_type = type
	$Sprite.texture = load(PowerupsSprites[type])

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$AnimationPlayer.play("float")


func _on_Item_area_entered(area):
	if area.is_in_group("player"):
		$AnimationPlayer.play("fadeout")

func get_type():
	return _type
