extends Area2D

#Basic NPC code transferrable and rewriteable to allocate different dialogue boxes
#for different NPCS.
#Created 10/31/21 By Nick "Goro Majima" Mineo

func _input(event):
	if event.is_action_pressed("use_action") and len(get_overlapping_bodies()) > 0: #when the player is within the area of the dialogue collision box,
		find_and_use_dialogue() # do the thing vvvvv

#THE THING:
func find_and_use_dialogue():
	var dialogue_player = get_node_or_null("DialoguePlayer") #obtain the DialoguePlayer child node.
	
	if dialogue_player: 	   #if it exists,
		dialogue_player.play() #play its contents.
