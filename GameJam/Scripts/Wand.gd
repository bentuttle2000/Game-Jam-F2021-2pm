extends Node2D

#function called from Player.gd that returns the position to spawn projectiles
#written by Ben Tuttle
func getWandPosition():
	return $Position2D.global_position;
