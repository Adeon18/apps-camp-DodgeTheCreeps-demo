extends Area2D

class_name Item

var _type: String

var PowerupsSprites: Dictionary = {
	"freeze": "res://art/pickups/freeze.png",
	"speed": "res://art/pickups/speedup.png"
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
