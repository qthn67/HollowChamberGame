extends Label


func _process(delta: float) -> void:
	text = "Level: " + str(Global.level)
