extends CharacterBody2D
@export var tile_spawner: Node2D
@export var ground_tiles: TileMap
@export var event_tiles: TileMap
@onready var tween = $Tween  
@export var black_transition: Node2D
@export var combat: Node2D
@export var camera: Camera2D
@export var music: AudioStreamPlayer2D
@export var move_sfx: AudioStreamPlayer2D
@export var event_sfx: AudioStreamPlayer2D

@export var event_box: Sprite2D

@export var inv: Inv

var shake: bool
var snap_back = false
var fight_time = false

var animation_finished = true
signal camera_shake(message: String)
var fighting = false
var cornered = false
var start_wait_over = false
var pause_movement= false

var toggle_choice = false
var stupid_bool1 = false
var stupid_bool2 = false

var dead = false


func _ready() -> void:
	visible = true
	await get_tree().create_timer(0.1).timeout
	position = ground_tiles.map_to_local(Vector2i(30,17)) + Vector2(0,-4)
	await get_tree().create_timer(0.1).timeout
	start_wait_over = true


func _process(delta: float) -> void:
	
	if(dead):
		await get_tree().create_timer(1).timeout
	if (!pause_movement):
		### OUT OF COMBAT
		if(!fighting and start_wait_over):
			visible = true
			var temp_tile_position
			var temp_tile_atlas
			var tween = create_tween()
			var tile_position
			
			tile_position = ground_tiles.local_to_map(global_position)
			ground_tiles.set_cell(0, tile_position, 1, Vector2i(1,0))
			# event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
			ground_tiles.ground_marker_locations.erase(tile_position)
			
			# print("pause movement: ", pause_movement)
			# print("camera.pause_camera: ", camera.pause_camera)
			# print("event_box.triggered: ", event_box.triggered)
			### CHOICE EVENT
			if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(2,0):
				if(stupid_bool1 == true):
					stupid_bool2 = true
				if(toggle_choice == false):
					toggle_choice = true
					event_sfx.stream = preload("res://choice.mp3")
					event_sfx.play()
					await get_tree().create_timer(0.15).timeout
					pause_movement = true
					camera.pause_camera = true
					event_box.triggered = true
					
				if(event_box.moving_up == true and stupid_bool1 == false):
					event_tiles.set_cell(0, ground_tiles.local_to_map(position), 1, Vector2i(-1,-1))
					event_box.moving_up == false
					pause_movement = false
					camera.pause_camera = false
					event_box.triggered = false
					toggle_choice = false
					stupid_bool1 = true
				else:
					stupid_bool1 = false
					stupid_bool2 = false
					camera.pause_camera = false
				
				
			### BOSS FIGHT
			if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(0,1):
				combat.boss_start = true
				print("test")
				shake = true
				combat.starting()
				pause_movement = true
				event_sfx.pitch_scale = 0.7
				event_sfx.stream = preload("res://boss_trigger.mp3")
				event_sfx.play()
				await get_tree().create_timer(0.5).timeout
				music.stream_paused = true
				fight_time = true
				event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
				await get_tree().create_timer(2).timeout
				black_transition.enter_trans = true
				black_transition.exit_trans = false
				fighting = true
				combat.visible = true
				shake = false
			### STANDARD FIGHT
			shake = true
			if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(1,0):
				combat.starting()
				pause_movement = true
				event_sfx.stream = preload("res://boss_trigger.mp3")
				event_sfx.play()
				await get_tree().create_timer(0.5).timeout
				music.stream_paused = true
				fight_time = true
				event_tiles.set_cell(0, tile_position, 1, Vector2i(-1,-1))
				await get_tree().create_timer(2).timeout
				black_transition.enter_trans = true
				black_transition.exit_trans = false
				fighting = true
				combat.visible = true
			shake = false
				### ITEM GET
			if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(0,0):
				animation_finished = false
				await get_tree().create_timer(0.2).timeout
				if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(0,0):
					event_sfx.stream = preload("res://item.mp3")
					event_sfx.play()
					if(stupid_bool1 == true):
						stupid_bool2 = true
					if(toggle_choice == false):
						toggle_choice = true
						await get_tree().create_timer(0.15).timeout
						pause_movement = true
						camera.pause_camera = true
						event_box.triggered = true
						print("event_box.triggered: ",event_box.triggered)
						
					if(event_box.moving_up == true and stupid_bool1 == false):
						animation_finished = true
						event_tiles.set_cell(0, ground_tiles.local_to_map(position), 1, Vector2i(-1,-1))
						event_box.moving_up == false
						pause_movement = false
						camera.pause_camera = false
						event_box.triggered = false
						toggle_choice = false
						stupid_bool1 = true
					else:
						stupid_bool1 = false
						stupid_bool2 = false
						camera.pause_camera = false
					
			### BULLETS GET
			if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(1,1):
				animation_finished = false
				await get_tree().create_timer(0.2).timeout
				if event_tiles.get_cell_atlas_coords(0, ground_tiles.local_to_map(position)) == Vector2i(1,1):
					event_sfx.stream = preload("res://bullet.mp3")
					event_sfx.play()
					if(stupid_bool1 == true):
						stupid_bool2 = true
					if(toggle_choice == false):
						toggle_choice = true
						await get_tree().create_timer(0.15).timeout
						pause_movement = true
						camera.pause_camera = true
						event_box.triggered = true
						print("event_box.triggered: ",event_box.triggered)
						
					if(event_box.moving_up == true and stupid_bool1 == false):
						animation_finished = true
						event_tiles.set_cell(0, ground_tiles.local_to_map(position), 1, Vector2i(-1,-1))
						event_box.moving_up == false
						pause_movement = false
						camera.pause_camera = false
						event_box.triggered = false
						toggle_choice = false
						stupid_bool1 = true
					else:
						stupid_bool1 = false
						stupid_bool2 = false
						camera.pause_camera = false
			
			
			#UP
			if (Input.is_action_just_pressed("ui_up") and animation_finished == true and black_transition.modulate.a < 0):
				snap_back = true
				animation_finished = false
				temp_tile_position = ground_tiles.local_to_map(position)
				temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

				if ((temp_tile_position + Vector2i(0,-1)) in ground_tiles.ground_marker_locations):
					# position.y -= 32
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://move.mp3")
					move_sfx.play()
					tween.tween_property(self, "position", position + Vector2(0,-32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
				else:
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://blocked.mp3")
					move_sfx.play()
					shake = true
					tween.tween_property(self, "position", position + Vector2(0,-5), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.1).timeout
					shake = false
				animation_finished = true
				snap_back = false
				
			
			#DOWN
			elif (Input.is_action_just_pressed("ui_down") and animation_finished == true and black_transition.modulate.a < 0):
				snap_back = true
				animation_finished = false
				temp_tile_position = ground_tiles.local_to_map(position)
				temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

				if ((temp_tile_position + Vector2i(0,1)) in ground_tiles.ground_marker_locations):
					# position.y -= 32
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://move.mp3")
					move_sfx.play()
					tween.tween_property(self, "position", position + Vector2(0,32), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
				else:
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://blocked.mp3")
					move_sfx.play()
					shake = true
					tween.tween_property(self, "position", position + Vector2(0,5), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
					shake = false
				animation_finished = true
				snap_back = false
			#LEFT
			elif (Input.is_action_just_pressed("ui_left") and animation_finished == true and black_transition.modulate.a < 0):
				snap_back = true
				animation_finished = false
				temp_tile_position = ground_tiles.local_to_map(position)
				temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

				if ((temp_tile_position + Vector2i(-1,0)) in ground_tiles.ground_marker_locations):
					# position.y -= 32
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://move.mp3")
					move_sfx.play()
					tween.tween_property(self, "position", position + Vector2(-32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
				else:
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://blocked.mp3")
					move_sfx.play()
					shake = true
					tween.tween_property(self, "position", position + Vector2(-5,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
					shake = false
				animation_finished = true
				snap_back = false
			#RIGHT
			elif (Input.is_action_just_pressed("ui_right") and animation_finished == true and black_transition.modulate.a < 0):
				snap_back = true
				animation_finished = false
				temp_tile_position = ground_tiles.local_to_map(position)
				temp_tile_atlas = ground_tiles.get_cell_atlas_coords(0, temp_tile_position)

				if ((temp_tile_position + Vector2i(1,0)) in ground_tiles.ground_marker_locations):
					# position.y -= 32
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://move.mp3")
					move_sfx.play()
					tween.tween_property(self, "position", position + Vector2(32,0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
				else:
					move_sfx.pitch_scale = 1 + randf_range(-0.5,0.4)
					move_sfx.stream = preload("res://blocked.mp3")
					move_sfx.play()
					shake = true
					tween.tween_property(self, "position", position + Vector2(5,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.tween_property(self, "position", position + Vector2(0,0), 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					await get_tree().create_timer(0.2).timeout
					shake = false
				animation_finished = true
				snap_back = false
				
				
			### WHEN THERE'S NOWHERE LEFT TO GO
			shake = true
			temp_tile_position = ground_tiles.local_to_map(position)
			if(!cornered):
				if ((temp_tile_position + Vector2i(0,-1)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(0,1)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(-1,0)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(1,0)) not in ground_tiles.ground_marker_locations):
					await get_tree().create_timer(0.2).timeout
					if ((temp_tile_position + Vector2i(0,-1)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(0,1)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(-1,0)) not in ground_tiles.ground_marker_locations) and ((temp_tile_position + Vector2i(1,0)) not in ground_tiles.ground_marker_locations):
						event_tiles.set_cell(0, temp_tile_position, 2, Vector2i(0,1))
						cornered = true
						await get_tree().create_timer(0.2).timeout
						pause_movement = true
			shake = false
		else:
			visible = false
		
		
