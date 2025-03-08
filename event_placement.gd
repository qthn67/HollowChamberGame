extends TileMap
@export var tile_spawner: Node2D
@export var ground_tiles: TileMap

var events = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(1,1), Vector2i(2,1)] # atlas coords for each tile
var weights = [1, 1, 1, 1, 1]  # Adjust as needed
var max_capacities = [3, 30, 3, 5, 10]
var event_counts = [0, 0, 0, 0, 0]
var current_position = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	
	ground_tiles.ground_marker_locations.shuffle()
	for current_tile in ground_tiles.ground_marker_locations:
		#current_position = ground_tiles.ground_marker_locations[randi() % ground_tiles.ground_marker_locations.size()]
		current_position = current_tile
		
		if(current_position != Vector2i(30,17)):
			var chosen_event = weighted_random(weights)
			var current_event = events[chosen_event]
			
			# if(current_event == Vector2i(0,0) or current_event == Vector2i(1,1)):
				# while(get_cell_atlas_coords(0, current_tile + Vector2i(0,-1)) != Vector2i(0,0) or get_cell_atlas_coords(0, current_tile + Vector2i(0,-1)) != Vector2i(1,1) or get_cell_atlas_coords(0, current_tile + Vector2i(0,1)) != Vector2i(0,0) or get_cell_atlas_coords(0, current_tile + Vector2i(0,1)) != Vector2i(1,1) or get_cell_atlas_coords(0, current_tile + Vector2i(-1,0)) != Vector2i(0,0) or get_cell_atlas_coords(0, current_tile + Vector2i(-1,0)) != Vector2i(1,1) or get_cell_atlas_coords(0, current_tile + Vector2i(1,0)) != Vector2i(0,0) or get_cell_atlas_coords(0, current_tile + Vector2i(1,0)) != Vector2i(1,1)):
					# pass
			
			
			if(event_counts[chosen_event] < max_capacities[chosen_event]):
				set_cell(0, current_position, 2, current_event)
				event_counts[chosen_event] += 1
			else:
				if(get_cell_atlas_coords(0, current_position) == Vector2i(-1,-1)):
					set_cell(0, current_position, 2, Vector2i(-1,-1))


func weighted_random(weights: Array) -> int:
	var total_weight = sum_array(weights)
	var rnd = randf() * total_weight
	var cumulative = 0.0
	
	for i in range(weights.size()):
		cumulative += weights[i]
		if rnd < cumulative:
			return i
	return weights.size() - 1  # Default fallback


func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
