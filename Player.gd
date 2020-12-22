extends KinematicBody2D

var speed = 500.0
var skins = ["blue", "green", "pink", "red", "yellow", "dew"]
onready var collisions = "NormalArea"

enum Direction { UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT, UP, DOWN, LEFT, RIGHT, NONE }

var my_data
var killer
var activity
var person
var place

slave var slave_position = Vector2()
slave var slave_movement = Direction.NONE

func _ready():
	place = get_parent().name
	killer = false
	$KillerTag.visible = false
	$PartyGoerTag.visible = false
	if get_parent().name != "Lobby" && is_network_master():
		if Network.killer == name:
			killer = true
			$KillerTag.visible = true
		else:
			$PartyGoerTag.visible = true
	my_data = Network.players[int(name)]
	$Skins.modulate = Color(1,1,1,1)
	$Normal.disabled = false
	$Dew.disabled = false
	$NormalArea.monitorable = false
	$NormalArea.monitoring = false
	$DewArea.monitorable = false
	$DewArea.monitoring = false
	$Buttons/Use.visible = false
	$Buttons/Kill.visible = false
	get_node(collisions).monitorable = true
	if is_network_master():
		z_index = 1
		$up.visible = true
		$down.visible = true
		$left.visible = true
		$right.visible = true
		get_node(collisions).monitoring = true
		if get_parent().name == "Lobby":
			$Selection.visible = true
			$Joined.visible = true
		else:
			$Selection.visible = false
			$Joined.visible = false
	else:
		$Joined.visible = false
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
			move_and_slide(Vector2(1, -1).normalized()*speed)
		Direction.UPLEFT:
			move_and_slide(Vector2(-1, -1).normalized()*speed)
		Direction.DOWNRIGHT:
			move_and_slide(Vector2(1, 1).normalized()*speed)
		Direction.DOWNLEFT:
			move_and_slide(Vector2(-1, 1).normalized()*speed)
		Direction.UP:
			move_and_slide(Vector2(0, -speed))
		Direction.DOWN:
			move_and_slide(Vector2(0, speed))
		Direction.LEFT:
			move_and_slide(Vector2(-speed, 0))
		Direction.RIGHT:
			move_and_slide(Vector2(speed, 0))

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
		collisions = "DewArea"
		if is_network_master():
			$Dew.disabled = false
	else:
		$Nickname.rect_position = Vector2(-128, -48)
		collisions = "NormalArea"
		if is_network_master():
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
	if activity == "StartButton":
		Network.call_start()
	elif activity == "GameRules":
		pass

func _on_Kill_pressed():
	Network.kill_person(person)

func die():
	$Normal.disabled = true
	$Dew.disabled = true
	if is_network_master():
		#spawnbody
		$Skins.modulate = Color(1,1,1,0.6)
	else:
		#spawnbody
		$NormalArea.monitorable = false
		$NormalArea.monitoring = false
		$DewArea.monitorable = false
		$DewArea.monitoring = false
		visible = false
