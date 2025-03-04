extends Node2D
@export var TileSpawner: TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta: float) -> void:
	
	'''
	var tile_id = 1
	var tile_position = Vector2i(randi_range(0,60),randi_range(0,34))
	var atlas_coords = Vector2i(0,0)
	var layer = 0

	TileSpawner.set_cell(layer, tile_position, tile_id, atlas_coords)
	'''
	
	
	
	
func spawnTile():
	print("test")
