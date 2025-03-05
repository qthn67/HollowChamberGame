extends TileMap
@export var ground_tiles: TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	
	for x in range(1,50):
		var current_positon = ground_tiles.ground_marker_locations[randi() % ground_tiles.ground_marker_locations.size()]
		var current_item = Vector2i(randi_range(0,1),randi_range(0,1))
		
		set_cell(0, current_positon, 2, current_item)
		print(current_positon)
		
	await get_tree().create_timer(0.39).timeout
	clear()
	_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
