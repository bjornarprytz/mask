class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton


var feature_scene: PackedScene = preload("res://feature.tscn")
var fly_path_scene: PackedScene = preload("res://fly_path.tscn")
var fly_scene: PackedScene = preload("res://fly.tscn")

func feature(color: Color) -> Node2D:
	var feature_node = feature_scene.instantiate() as Node2D
	feature_node.modulate = color
	return feature_node

func fly() -> Fly:
	var fly_node = fly_scene.instantiate() as Fly
	return fly_node

func fly_path() -> FlyPath:
	var fly_path_node = fly_path_scene.instantiate() as FlyPath
	return fly_path_node
