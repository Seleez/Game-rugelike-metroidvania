extends Node2D

var Room = preload("res://Scenes/Room.tscn")

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10

func _ready():
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range(num_rooms):
		var position = Vector2(0,0)
		var room = Room.instantiate()
		var width = min_size + randi() % (max_size - min_size)
		var height = min_size + randi() % (max_size - min_size)
		room.make_room(position,Vector2(width,height) * tile_size)
		$Rooms.add_child(room)
		

