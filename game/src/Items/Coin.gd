extends Area2D

var statemachine

func _ready():
	pass

func _on_Coin_area_entered(area):
	if area.is_in_group("player"):
		$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$AnimationPlayer.play("float")
