extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"


func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		
		var currentscene = get_tree().current_scene.scene_file_path
		var nextlvl = currentscene.to_int() + 1 
		audio_stream_player_2d.play()
		await audio_stream_player_2d.finished
		var upcomingscene = "res://scenes/levels/level"+ str(nextlvl) + ".tscn"
		get_tree().change_scene_to_packed(upcomingscene)
