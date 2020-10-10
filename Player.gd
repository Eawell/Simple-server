extends KinematicBody2D

var SPEED = 10.0

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

slave var slave_position = Vector2()
slave var slave_movement = Direction.NONE

func init(nickname, start_position, is_slave):
	$Nickname.text = nickname
	global_position = start_position
	if is_slave:
		$ColorRect.color = Color(0,0,1,1)

func _physics_process(delta):
	var direction = Direction.NONE
	if is_network_master():
		if Input.is_action_pressed('ui_left'):
			direction = Direction.LEFT
		elif Input.is_action_pressed('ui_right'):
			direction = Direction.RIGHT
		elif Input.is_action_pressed('ui_up'):
			direction = Direction.UP
		elif Input.is_action_pressed('ui_down'):
			direction = Direction.DOWN
		
		rset_unreliable('slave_position', position)
		rset('slave_movement', direction)
		_move(direction)
	else:
		_move(slave_movement)
		position = slave_position
	
	if get_tree().is_network_server():
		Network.update_position(int(name), position)

func _move(direction):
	match direction:
		Direction.NONE:
			return
		Direction.UP:
			move_and_collide(Vector2(0, -SPEED))
		Direction.DOWN:
			move_and_collide(Vector2(0, SPEED))
		Direction.LEFT:
			move_and_collide(Vector2(-SPEED, 0))
		Direction.RIGHT:
			move_and_collide(Vector2(SPEED, 0))
