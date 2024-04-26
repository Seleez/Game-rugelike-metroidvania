extends RigidBody2D

var size

func  make_room(_pos, _size):
	size = _size
	position = _pos
	var s = RectangleShape2D.new()
	s.extents = size
	$CollisionShape2D.shape = s
