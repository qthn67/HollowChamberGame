extends CharacterBody2D
@export var tile_spawner: Node2D
@export var ground_tiles: TileMap
@export var event_tiles: TileMap
@onready var tween = $Tween  # Reference to the Tween node

var animation_finished = true

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	position = ground_tiles.map_to_local(Vector2i(30,17)) + Vector2(0,-4)
	pass


func _process(delta: float) -> void:
	var temp_tile_position
	var temp_tile_atlas
	var tween = create_tween()
	var tile_position
	tile_position = ground_tiles.local_to_map(global_position)
	ground_tiles.set_cell(0, tile_position, 1, Vector2i(1,0))
	event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
	ground_tiles.ground_marker_locations.erase(tile_position)
	
	#UP
	if (Input.is_action_just_pressed("ui_up") and animation_finished == true):
		animation_finished = false
		temp_tile_position = ground_tiles.local_to_map(position)
		temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

		if ((temp_tile_position + Vector2i(0,-1)) in ground_tiles.ground_marker_locations):
			# position.y -= 32
			tween.tween_property(self, "position", position + Vector2(0,-32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		else:
			tween.tween_property(self, "position", position + Vector2(0,-5), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", position + Vector2(0,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		animation_finished = true
		
		
		
	#DOWN
	elif (Input.is_action_just_pressed("ui_down") and animation_finished == true):
		animation_finished = false
		temp_tile_position = ground_tiles.local_to_map(position)
		temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

		if ((temp_tile_position + Vector2i(0,1)) in ground_tiles.ground_marker_locations):
			# position.y -= 32
			tween.tween_property(self, "position", position + Vector2(0,32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		else:
			tween.tween_property(self, "position", position + Vector2(0,5), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", position + Vector2(0,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		animation_finished = true
	#LEFT
	elif (Input.is_action_just_pressed("ui_left") and animation_finished == true):
		animation_finished = false
		temp_tile_position = ground_tiles.local_to_map(position)
		temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

		if ((temp_tile_position + Vector2i(-1,0)) in ground_tiles.ground_marker_locations):
			# position.y -= 32
			tween.tween_property(self, "position", position + Vector2(-32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		else:
			tween.tween_property(self, "position", position + Vector2(-5,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", position + Vector2(0,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		animation_finished = true
	#LEFT
	elif (Input.is_action_just_pressed("ui_right") and animation_finished == true):
		animation_finished = false
		temp_tile_position = ground_tiles.local_to_map(position)
		temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

		if ((temp_tile_position + Vector2i(1,0)) in ground_tiles.ground_marker_locations):
			# position.y -= 32
			tween.tween_property(self, "position", position + Vector2(32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		else:
			tween.tween_property(self, "position", position + Vector2(5,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", position + Vector2(0,0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.2).timeout
		animation_finished = true
		
		
