extends Node2D

@export var GRID_SQUARE: PackedScene
@export var GRID_SIZE: Vector2
@export var CHARACTER: PackedScene
@export var START_COORDINATES: Vector2

var GRID_SQUARE_SIZE: Vector2
var MOVE_TIME = 0.2
var DARK_GRAY = Color(0.33, 0.33, 0.33)
var GREEN = Color(0, 1, 0)
var YELLOW = Color(1, 1, 0)

var elapsed_time: float = 0
var timeToNextJump = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instantiate_grid()
	_instantiate_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _instantiate_grid():
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			var new_square = GRID_SQUARE.instantiate()
			GRID_SQUARE_SIZE = new_square.get_child(0).scale
			new_square.position = Vector2(GRID_SQUARE_SIZE.x * x, GRID_SQUARE_SIZE.y * y)
			new_square.get_child(1).text = str(x) + "," + str(y)
			new_square.get_node("Border").modulate = Color(0.33, 0.33, 0.33)
			var onClick = func (_viewport: Node, event: InputEvent, _shape_idx: int):
				var character = get_node('Character')
				if event is InputEventMouseButton && event.button_index == 1 && !(character.is_moving):
					_move_character_to_target_square(character, Vector2(x, y))
			new_square.get_node("Area2D").connect('input_event', onClick)
			add_child(new_square)


func _instantiate_player():
	var new_character = CHARACTER.instantiate()
	var start_square = _get_grid_square_by_coordinate(Vector2(0, 0))
	new_character.position = start_square.position
	new_character.scale = Vector2(GRID_SQUARE_SIZE.x / 50, GRID_SQUARE_SIZE.y / 50)
	new_character.game_coordinate = Vector2(0, 0)
	new_character.is_moving = false
	add_child(new_character)


func _get_grid_square_by_coordinate(coordinate: Vector2) -> Node:
	var index = coordinate.x * GRID_SIZE.y + coordinate.y
	return get_child(index)

func _move_character_to_target_square(character: Node2D, target_game_coord: Vector2):
	if (character.is_moving): return
	character.is_moving = true
	var start_square = _get_grid_square_by_coordinate(character.game_coordinate)
	var path = character.get_game_path(character.game_coordinate, target_game_coord)
	timeToNextJump = MOVE_TIME * path.size() + 1
	for coord in path:
		var next_square = _get_grid_square_by_coordinate(coord)
		next_square.get_node("Border").modulate = YELLOW

	var target_square = _get_grid_square_by_coordinate(target_game_coord)
	var border = target_square.get_node("Border")
	border.modulate = GREEN

	for coord in path:
		var next_square = _get_grid_square_by_coordinate(coord)
		await character.move_character(next_square.position, coord, MOVE_TIME)

	for coord in path:
		var next_square = _get_grid_square_by_coordinate(coord)
		next_square.get_node("Border").modulate = DARK_GRAY

	start_square.get_node("Border").modulate = DARK_GRAY
	
	character.is_moving = false


