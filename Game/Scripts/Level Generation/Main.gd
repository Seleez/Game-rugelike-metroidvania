extends Node2D

var Room = preload("res://Scenes/Room.tscn")

@export var tile_size = 16
@export var num_rooms = 50
@export var min_size = 4
@export var max_size = 10
@export var horizontal_spread = 400
@export var vertical_spread = 400
@export var cull = 0.5

var path

@onready var Map = $TileMap

func _ready():
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range(num_rooms):
		var position = Vector2(randf_range(-horizontal_spread, horizontal_spread),randf_range(-vertical_spread, vertical_spread))
		var room = Room.instantiate()
		var width = min_size + randi() % (max_size - min_size)
		var height = min_size + randi() % (max_size - min_size)
		room.make_room(position,Vector2(width,height) * tile_size)
		$Rooms.add_child(room)
	await(get_tree().create_timer(0.1).timeout)
	var room_position = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			#print(position)
			room_position.append(Vector2(room.position.x,room.position.y))
			#print(room_position)
			
	await(get_tree().create_timer(0.1).timeout)
	path = find_mst(room_position)
	
		
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),Color(81, 96, 237), false)
		if path:
			for p in path.get_point_ids():
				for c in path.get_point_connections(p):
					var p_temp = path.get_point_position(p)
					var c_temp = path.get_point_position(c)
					draw_line(p_temp, c_temp,Color(1,1,0), 15, true)


func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
	if event.is_action_pressed('ui_focus_next'):
		make_map()
		
func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(),nodes.pop_front())
	
	while nodes:
		var min_distance = INF
		var min_position = null
		var position = null
		for position1 in path.get_point_ids():
			var position_temp = path.get_point_position(position1)
			for position2 in nodes:
				if position_temp.distance_to(position2) < min_distance:
					min_distance = position_temp.distance_to(position2)
					min_position = position2
					position = position_temp
		var n = path.get_available_point_id()
		path.add_point(n,min_position)
		path.connect_points(path.get_closest_point(position),n)
		nodes.erase(min_position)
	return path


func make_map():
	Map.clear()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var rect = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents * 2)
		full_rect = full_rect.merge(rect)
	var	topleft = Map.local_to_map(full_rect.position)
	var bottomright = Map.local_to_map(full_rect.end)
	#var cells = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(0,1),Vector2i(1,1), Vector2i(2,1),Vector2i(0,2),Vector2i(1,2),Vector2i(2,2)]
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1), 0)
			#Map.set_cells_terrain_connect(0,cells,0,0)
	
	for room in $Rooms.get_children():
		var size = (room.size / tile_size).floor()
		var pos = Map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - size
		for x in range(2,size.x * 2 - 1):
			for y in range(2,size.y * 2 - 1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 0, Vector2i(3, 2), 0)
