extends Area2D

func _on_Coin_area_entered(area):
	if area.is_in_group("player"):
		$AnimationPlayer.play("fadeout")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$AnimationPlayer.play("float")

func get_type():
	return "Coin"
