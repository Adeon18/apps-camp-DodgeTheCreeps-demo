extends Area2D

class_name Item

func _on_Coin_area_entered(area):
	if area.is_in_group("player"):
		$AnimationPlayer.play("fadeout")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$AnimationPlayer.play("float")
