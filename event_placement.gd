extends TileMap
@export var tile_spawner: Node2D
@export var ground_tiles: TileMap

var items = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var current_position = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	
	for x in range(1,50):
		current_position = ground_tiles.ground_marker_locations[randi() % ground_tiles.ground_marker_locations.size()]
		
		if(current_position != Vector2i(30,17)):
			var current_item = items[randi() % items.size()]
			set_cell(0, current_position, 2, current_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
