extends Node2D

@export var game_coordinate: Vector2


func move_character(coordinate_pxl: Vector2, coordinate_game: Vector2, duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", coordinate_pxl, duration)
	await tween.finished
	game_coordinate = coordinate_game
	return


func get_game_path(start_coord_game: Vector2, target_coord_game: Vector2) -> Array[Vector2]:
	if start_coord_game == target_coord_game:
		return []
	var diff = target_coord_game - start_coord_game
	var new_start
	if abs(diff.y) > abs(diff.x):
		new_start = Vector2(start_coord_game.x, start_coord_game.y + (diff.y / abs(diff.y)))
	else:
		new_start = Vector2(start_coord_game.x + (diff.x / abs(diff.x)), start_coord_game.y)
	var path_arr = get_game_path(new_start, target_coord_game)
	path_arr.push_front(new_start)
	return path_arr
