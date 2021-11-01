extends CanvasLayer

#Main function for obtaining and translating dialogue from an external JSON file
#and importing it into GODOT and displaying it as a dialogue box
#Created by Nick "Goro Majima" Mineo

export(String, FILE, "*.json") var dialogue_file #export variable viewable by inspector, load in the corresponding NPC's dialogue JSON file here.


var dialogues = []		  #array of JSON lines from external file
var dialogueCurrentID = 0 #Current JSON line number storage variable
var is_dialogue_active = false #dialogue is by default not active

onready var textName = $ColorRect/Name       #ease of formatting
onready var textMessage = $ColorRect/Message #ditto
onready var dialogueBox = $ColorRect         #also ditto


func _ready():
	dialogueBox.visible = false #invisible upon startup

func play():
	if is_dialogue_active:
		return
	
	dialogues = load_dialogue()
	
	set_player_inactive() #set the player controls to inactive while dialogue is open
	is_dialogue_active = true
	dialogueBox.visible = true
	dialogueCurrentID = -1 #set the current line to be 1 before the first
	next_line()
	
func _input(event):
	if event.is_action_pressed("use_action"): #when the action button (Default E, can be changed later) is pressed,
		next_line() #Play the next line of dialogue

func next_line():
	if not is_dialogue_active:
		return
	dialogueCurrentID += 1
	if dialogueCurrentID >= len(dialogues): #once the final box has been reached,
		$DialogueTimer.start() #start the timer that prevents looping,
		dialogueBox.visible = false #deactive the box,
		set_player_active() # and regain player control.
		return
	textName.text = dialogues[dialogueCurrentID]['name'] #set the npc name to the corresponding line.
	textMessage.text = dialogues[dialogueCurrentID]['text'] #Set the text to the corresponding line.
	
func load_dialogue():
	var file = File.new() #standard file loading function
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())


func _on_DialogueTimer_timeout():
	is_dialogue_active = false #makes sure that the player cannot activate the same dialogue loop for .4 seconds after ending the final box.

func set_player_active():
	var player = get_tree().get_root().find_node("Player", true, false)
	if player:
		player.set_active(true)

func set_player_inactive():
	var player = get_tree().get_root().find_node("Player", true, false)
	if player:
		player.set_active(false)
