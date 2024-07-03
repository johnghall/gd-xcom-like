extends Node2D

@export var GRID_SQUARE: PackedScene
@export var GRID_SIZE: Vector2
@export var CHARACTER: PackedScene
@export var START_COORDINATES: Vector2

var GRID_SQUARE_SIZE: Vector2
var MOVE_TIME = 0.2
var DARK_GRAY = Color(0.33, 0.33, 0.33)
var GREEN = Color(0, 1, 0)
var YELLOW = Color(0.66, 0.66, 0.66)

var elapsed_time: float = 0
var timeToNextJump = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instantiate_grid()
	_instantiate_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= timeToNextJump:
		elapsed_time = 0
		var rng = RandomNumberGenerator.new()
		var rand_coord = Vector2(
			rng.randi_range(0, int(GRID_SIZE.x - 1)), rng.randi_range(0, int(GRID_SIZE.y - 1))
		)
		var character = get_node("Character")
		var path = character.get_game_path(character.game_coordinate, rand_coord)
		timeToNextJump = MOVE_TIME * path.size() + 1
		for coord in path:
			var next_square = _get_grid_square_by_coordinate(coord)
			next_square.get_node("Border").modulate = YELLOW

		var target_square = _get_grid_square_by_coordinate(rand_coord)
		var border = target_square.get_node("Border")
		border.modulate = GREEN

		for coord in path:
			var next_square = _get_grid_square_by_coordinate(coord)
			await character.move_character(next_square.position, coord, MOVE_TIME)

		for coord in path:
			var next_square = _get_grid_square_by_coordinate(coord)
			next_square.get_node("Border").modulate = DARK_GRAY


func _instantiate_grid():
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			var new_square = GRID_SQUARE.instantiate()
			GRID_SQUARE_SIZE = new_square.get_child(0).scale
			new_square.position = Vector2(GRID_SQUARE_SIZE.x * x, GRID_SQUARE_SIZE.y * y)
			new_square.get_child(1).text = str(x) + "," + str(y)
			new_square.get_node("Border").modulate = Color(0.33, 0.33, 0.33)
			add_child(new_square)


func _instantiate_player():
	var new_character = CHARACTER.instantiate()
	var start_square = _get_grid_square_by_coordinate(Vector2(0, 0))
	new_character.position = start_square.position
	new_character.scale = Vector2(GRID_SQUARE_SIZE.x / 50, GRID_SQUARE_SIZE.y / 50)
	new_character.game_coordinate = Vector2(0, 0)
	add_child(new_character)


func _get_grid_square_by_coordinate(coordinate: Vector2) -> Node:
	var index = coordinate.x * GRID_SIZE.y + coordinate.y
	return get_child(index)
