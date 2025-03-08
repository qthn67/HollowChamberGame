extends CharacterBody2D
@export var tile_spawner: Node2D
@export var ground_tiles: TileMap
@export var event_tiles: TileMap
@onready var tween = $Tween  
@export var black_transition: Node2D
@export var combat: Control
@export var camera: Camera2D

var shake: bool
var snap_back = false
var fight_time = false

var animation_finished = true
signal camera_shake(message: String)
var fighting = false


func _ready() -> void:
	visible = true
	await get_tree().create_timer(0.1).timeout
	position = ground_tiles.map_to_local(Vector2i(30,17)) + Vector2(0,-4)
	pass


func _process(delta: float) -> void:
	
	### OUT OF COMBAT
	if(!fighting):
		visible = true
		var temp_tile_position
		var temp_tile_atlas
		var tween = create_tween()
		var tile_position
		
		tile_position = ground_tiles.local_to_map(global_position)
		ground_tiles.set_cell(0, tile_position, 1, Vector2i(1,0))
		# event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
		ground_tiles.ground_marker_locations.erase(tile_position)
		
		
		if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(2,0):
			get_tree().change_scene_to_file("res://choiceEvent.tscn")
		
		if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(0,1):
			await get_tree().create_timer(0.5).timeout
			fight_time = true
			event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
			await get_tree().create_timer(2).timeout
			black_transition.enter_trans = true
			black_transition.exit_trans = false
			fighting = true
			combat.visible = true
			
		
		
		#UP
		if (Input.is_action_just_pressed("ui_up") and animation_finished == true):
			snap_back = true
			animation_finished = false
			temp_tile_position = ground_tiles.local_to_map(position)
			temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

			if ((temp_tile_position + Vector2i(0,-1)) in ground_tiles.ground_marker_locations):
				# position.y -= 32
				tween.tween_property(self, "position", position + Vector2(0,-32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
			else:
				shake = true
				tween.tween_property(self, "position", position + Vector2(0,-5), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.1).timeout
				shake = false
			animation_finished = true
			snap_back = false
			
		
		#DOWN
		elif (Input.is_action_just_pressed("ui_down") and animation_finished == true):
			snap_back = true
			animation_finished = false
			temp_tile_position = ground_tiles.local_to_map(position)
			temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

			if ((temp_tile_position + Vector2i(0,1)) in ground_tiles.ground_marker_locations):
				# position.y -= 32
				tween.tween_property(self, "position", position + Vector2(0,32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
			else:
				shake = true
				tween.tween_property(self, "position", position + Vector2(0,5), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
				shake = false
			animation_finished = true
			snap_back = false
		#LEFT
		elif (Input.is_action_just_pressed("ui_left") and animation_finished == true):
			snap_back = true
			animation_finished = false
			temp_tile_position = ground_tiles.local_to_map(position)
			temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

			if ((temp_tile_position + Vector2i(-1,0)) in ground_tiles.ground_marker_locations):
				# position.y -= 32
				tween.tween_property(self, "position", position + Vector2(-32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
			else:
				shake = true
				tween.tween_property(self, "position", position + Vector2(-5,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
				shake = false
			animation_finished = true
			snap_back = false
		#RIGHT
		elif (Input.is_action_just_pressed("ui_right") and animation_finished == true):
			snap_back = true
			animation_finished = false
			temp_tile_position = ground_tiles.local_to_map(position)
			temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

			if ((temp_tile_position + Vector2i(1,0)) in ground_tiles.ground_marker_locations):
				# position.y -= 32
				tween.tween_property(self, "position", position + Vector2(32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
			else:
				shake = true
				tween.tween_property(self, "position", position + Vector2(5,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.2).timeout
				shake = false
			animation_finished = true
			snap_back = false
	else:
		visible = false
		
		
