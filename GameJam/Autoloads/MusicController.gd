extends Node2D

var mainTheme = load("res://Music/LizardMain.mp3")

func changeSong(newSong):
	mainTheme = load(newSong)
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = mainTheme
	$AudioStreamPlayer.play()
