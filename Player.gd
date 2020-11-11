extends KinematicBody2D

var SPEED = 500.0
var skins = ["blue", "green", "pink", "red", "yellow", "dew"]
onready var collisions = "NormalArea"

enum Direction { UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT, UP, DOWN, LEFT, RIGHT, NONE }

var my_data

slave var slave_position = Vector2()
slave var slave_movement = Direction.NONE

func _ready():
	my_data = Network.players[int(name)]
	$NormalArea.monitorable = false
	$NormalArea.monitoring = false
	$DewArea.monitorable = false
	$DewArea.monitoring = false
	$Use.visible = false
	get_node(collisions).monitorable = true
	if is_network_master():
		$Joined.visible = true
		$Selection.visible = true
		$up.visible = true
		$down.visible = true
		$left.visible = true
		$right.visible = true
		get_node(collisions).monitoring = true
	else:
		$Selection.visible = false
		$NormalArea.collision_layer = 2
		$NormalArea.collision_mask = 2
		$DewArea.collision_layer = 2
		$DewArea.collision_mask = 2

		
func _process(delta):
	$Joined.text = str(Network.players.size()) + "/6"

func init(nickname, start_skin, is_slave):
	$Nickname.text = nickname
	vis_skin(start_skin)
	

func _physics_process(delta):
	var direction = Direction.NONE
	if is_network_master():
		$Camera2D.current = true
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			direction = Direction.UPRIGHT
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			direction = Direction.UPLEFT
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			direction = Direction.DOWNRIGHT
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			direction = Direction.DOWNLEFT
		elif Input.is_action_pressed('ui_left') or $left.is_pressed():
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
	

func _move(direction):
	match direction:
		Direction.NONE:
			return
		Direction.UPRIGHT:
			move_and_slide(Vector2(1, -1).normalized()*SPEED)
		Direction.UPLEFT:
			move_and_slide(Vector2(-1, -1).normalized()*SPEED)
		Direction.DOWNRIGHT:
			move_and_slide(Vector2(1, 1).normalized()*SPEED)
		Direction.DOWNLEFT:
			move_and_slide(Vector2(-1, 1).normalized()*SPEED)
		Direction.UP:
			move_and_slide(Vector2(0, -SPEED))
		Direction.DOWN:
			move_and_slide(Vector2(0, SPEED))
		Direction.LEFT:
			move_and_slide(Vector2(-SPEED, 0))
		Direction.RIGHT:
			move_and_slide(Vector2(SPEED, 0))

func vis_skin(colour):
	$Skins/blue.visible = false
	$Skins/green.visible = false
	$Skins/pink.visible = false
	$Skins/red.visible = false
	$Skins/white.visible = false
	$Skins/yellow.visible = false
	$Skins/dew.visible = false
	get_node("Skins/" + colour).visible = true
	$Normal.disabled = true
	$Dew.disabled = true
	if colour == "dew":
		$Nickname.rect_position = Vector2(-128, -66)
		if is_network_master():
			collisions = "DewArea"
			$Dew.disabled = false
	else:
		$Nickname.rect_position = Vector2(-128, -48)
		if is_network_master():
			collisions = "NormalArea"
			$Normal.disabled = false
	$NormalArea.monitorable = false
	$DewArea.monitorable = false
	get_node(collisions).monitorable = true
	if is_network_master():
		$NormalArea.monitoring = false
		$DewArea.monitoring = false
		get_node(collisions).monitoring = true
		
func _on_blue_pressed():
	Network.change_skin(int(name), my_data["skin"], "blue")

func _on_green_pressed():
	Network.change_skin(int(name), my_data["skin"], "green")

func _on_pink_pressed():
	Network.change_skin(int(name), my_data["skin"], "pink")

func _on_red_pressed():
	Network.change_skin(int(name), my_data["skin"], "red")

func _on_yellow_pressed():
	Network.change_skin(int(name), my_data["skin"], "yellow")

func _on_dew_pressed():
	Network.change_skin(int(name), my_data["skin"], "dew")

func _on_Use_pressed():
	print("yes")
