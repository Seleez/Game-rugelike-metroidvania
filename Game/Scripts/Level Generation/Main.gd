extends Node2D

var Room = preload("res://Scenes/Room.tscn")

@export var tile_size = 32
@export var num_rooms = 50
@export var min_size = 4
@export var max_size = 10
@export var horizontal_spread = 40
@export var vertical_spread = 400
@export var cull = 0.5

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
	await(get_tree().create_timer(1.1).timeout)
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
	
		
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),Color(81, 96, 237), false)


func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()
