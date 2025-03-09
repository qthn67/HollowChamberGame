extends ColorRect

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	visible = false
