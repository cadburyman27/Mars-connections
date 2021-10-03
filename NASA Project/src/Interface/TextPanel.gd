extends Node2D

var _text_contents := [] # Stores each slide of text for the text box to display
var _current_slide := 0 # Stores the current slide

onready var _label = $Label # Gets the text box's child node 'Label' which is used to display text

func _ready() -> void: # Called once text box and all of its children are loaded into the scene
	set_process(false) # Stop the process function from executing

func _process(delta: float) -> void: # Called every frame
	if Input.is_action_just_released("set_move_location"): # True if the player clicks the left mouse button
		if _current_slide + 1 >= _text_contents.size(): # True if there are no slides after this one
			visible = false # Hide the text box
			set_process(false)
		else: # True if there are slides remaining after the current slide
			_current_slide += 1
			_label.text = _text_contents[_current_slide] # Display the next slide

func show_text(text_contents: Array) -> void: # Called when the player interacts with an object
	_text_contents = text_contents # Store the desired text in the text box's private array
	_label.text = _text_contents[0] # Display the first slide
	_current_slide = 0 # Ensure that the text box starts from the beginning
	visible = true # Show the text box
	set_process(true) # Let the _process function execute every frame

