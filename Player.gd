extends KinematicBody2D

var SPEED = 10.0
var skins = ["blue", "green", "pink", "red", "yellow"]

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

#var my_data = Network.players[name]

slave var slave_position = Vector2()
slave var slave_movement = Direction.NONE
slave var my_skin = ""

func _ready():
	if is_network_master():
		$up.visible = true
		$down.visible = true
		$left.visible = true
		$right.visible = true
		for skin in skins.size():
			if !Network.taken.has(skins[skin]):
				$Skin.animation = skins[skin]
				Network.taken.append(skins[skin])
				my_skin = skins[skin]
				for player in Network.players:
					if player != get_tree().get_network_unique_id():
						rset_id(player, 'my_skin', my_skin)
				return
	else:
		$Skin.animation = my_skin
		Network.taken.append(my_skin)

func init(nickname, start_position, is_slave):
	$Nickname.text = nickname
	global_position = start_position
	if is_slave:
		pass

func _physics_process(delta):
	var direction = Direction.NONE
	if is_network_master():
		$Camera2D.current = true
		if Input.is_action_pressed('ui_left') or $left.is_pressed():
			direction = Direction.LEFT
		elif Input.is_action_pressed('ui_right') or $right.is_pressed():
			direction = Direction.RIGHT
		elif Input.is_action_pressed('ui_up') or $up.is_pressed():
			direction = Direction.UP
		elif Input.is_action_pressed('ui_down') or $down.is_pressed():
			direction = Direction.DOWN
		for player in Network.players:
			if player != get_tree().get_network_unique_id():
				rset_unreliable_id(player, 'slave_position', position)
				rset_id(player, 'slave_movement', direction)
		_move(direction)
	else:
		_move(slave_movement)
		position = slave_position
	
	#if get_tree().is_network_server():
	#	Network.update_position(int(name), position)

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

func change_skin(colour):
	if is_network_master():
		if !Network.taken.has(colour):
			$Skin.animation = colour
			Network.taken.erase(my_skin)
			Network.taken.append(colour)
			my_skin = colour
			for player in Network.players:
				if player != get_tree().get_network_unique_id():
					rset_id(player, 'my_skin', my_skin)
					return


func _on_blue_pressed():
	change_skin("blue")

func _on_green_pressed():
	change_skin("green")

func _on_pink_pressed():
	change_skin("pink")

func _on_red_pressed():
	change_skin("red")

func _on_yellow_pressed():
	change_skin("yellow")
