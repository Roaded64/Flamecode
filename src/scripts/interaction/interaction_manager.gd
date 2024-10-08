extends Node2D

var can_interact = true
var active_areas = []

# recomendo não mexer

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)

func _register_area(area: InteractionArea):
	active_areas.push_back(area)

func _unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	
	if index != -1:
		active_areas.remove_at(index)

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("key_interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			
			await active_areas[0].interact.call()
			
			can_interact = true
