extends Node2D

@export var GRID_SQUARE: PackedScene
@export var GRID_SIZE: Vector2
@export var CHARACTER: PackedScene
@export var START_COORDINATES: Vector2

var GRID_SQUARE_SIZE: Vector2
var elapsed_time: float = 0
var TIME_BETWEEN_JUMPS = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instantiate_grid()
	_instantiate_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= TIME_BETWEEN_JUMPS:
		elapsed_time = 0
		var rng = RandomNumberGenerator.new()
		var rand_coord = Vector2(
			rng.randi_range(0, int(GRID_SIZE.x)), rng.randi_range(0, int(GRID_SIZE.y))
		)
		var character_node = get_node("Character")
		var target_square = _get_grid_square_by_coordinate(rand_coord)
		character_node.position = target_square.position
	pass


func _instantiate_grid():
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			var new_square = GRID_SQUARE.instantiate()
			GRID_SQUARE_SIZE = new_square.get_child(0).scale
			new_square.position = Vector2(GRID_SQUARE_SIZE.x * x, GRID_SQUARE_SIZE.y * y)
			new_square.get_child(1).text = str(x) + "," + str(y)
			add_child(new_square)


func _instantiate_player():
	var new_character = CHARACTER.instantiate()
	var start_square = _get_grid_square_by_coordinate(Vector2(0, 0))
	new_character.position = start_square.position
	new_character.scale = Vector2(GRID_SQUARE_SIZE.x / 50, GRID_SQUARE_SIZE.y / 50)
	add_child(new_character)


func _get_grid_square_by_coordinate(coordinate: Vector2) -> Node:
	var index = coordinate.y * GRID_SIZE.x + coordinate.x
	return get_child(index)
