extends StaticBody2D

export var _modulate_range := 20.0 # A value representing how close the mouse must be for the object to light up
export var _text_box_contents = [] # An array to store each page of the text box contents

var _is_interacting := false setget ,get_is_interacting # True if the player is interacting with the object and is queued to display a text box
var _lighting_up := false # Flag variable for lighting up animation
var _currently_colliding = null setget set_currently_colliding # Stores body that the object is currently colliding with

onready var _anim_player = $AnimationPlayer # Gets the object's child node 'AnimationPlayer' used to play animations
onready var _text_panel = $TextPanel # Gets the object's child node 'TextPanel' which displays text on the screen

func _on_InteractArea_body_entered(body: Node) -> void: # Called if a body enters object's child node 'InteractArea'
	if _is_interacting:
		body.set_currently_colliding(self) # Establishes a connection between the object and the player
		_text_panel.show_text(_text_box_contents) # Displays the object's text box

func _on_TextPanel_hide() -> void: # Called when the text box disappears
	_currently_colliding.set_currently_colliding(null) # Break connection between the object and the player
	_is_interacting = false # Set interacting to false, since objects are no longer interacting

func _process(delta: float) -> void: # Called every frame
	if abs((get_global_mouse_position() - position).length()) < _modulate_range: # True if the distance from the mouse to the object is less than the modulate range
		if not _lighting_up:
			_anim_player.play("light_up")
			_lighting_up = true
		if Input.is_action_just_released("set_move_location"):
			_is_interacting = true # Set interacting to true if the player clicks within the modulate range
	else:
		_anim_player.play("default") # Return to default graphic if the mouse is too far away
		_lighting_up = false

func get_is_interacting():
	return _is_interacting

func set_currently_colliding(given_currently_colliding):
	_currently_colliding = given_currently_colliding
