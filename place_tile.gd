extends TileMap

onready var tilemap = $Tilemap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_id = 0
	tilemap.set_cell(5, 5, tile_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
