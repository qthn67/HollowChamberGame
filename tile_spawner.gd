extends Node2D
@export var tilemap: TileMap

var location = Vector2i(4,4)
var atlas = Vector2i(0,0)
var tile_id = 1

var lifetime = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var source_marker = marker.new(tilemap, location, tile_id, 0, atlas, lifetime)
	await get_tree().create_timer(0.4).timeout
	tilemap.clear()
	_ready()
	


class marker:
	
	var tilemap: TileMap
	var tile_position: Vector2i
	var tile_id: int
	var layer: int
	var atlas: Vector2i
	
	var self_lifetime : int
	var next_lifetime : int

	func _init(input_tilemap: TileMap, input_position: Vector2i, input_tile_id: int, input_layer: int, input_atlas: Vector2i, input_lifetime: int):
		self.tilemap = input_tilemap
		self.tile_position = input_position
		self.tile_id = input_tile_id
		self.layer = input_layer
		self.atlas = input_atlas
		self.self_lifetime = input_lifetime
		self.next_lifetime = self_lifetime-1
		start()
		
	func start():
		if randi() % 100 < 95:
			tilemap.set_cell(layer, tile_position, tile_id, atlas)
		
		for x in range (0, self_lifetime):
			
			# Randomly choose one of two lines of code to execute
			if randi() % 2 == 0:
				tile_position.x += 1
			else:
				tile_position.y += 1
			
			
			var next_marker = marker.new(tilemap, tile_position, tile_id, 0, atlas, next_lifetime)
		
