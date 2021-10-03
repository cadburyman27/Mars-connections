extends KinematicBody2D

const FLOOR_NORMAL = Vector2.ZERO # This vector is perpendicular to the floor, and is used for collision processing

export var _speed := 250.0 # The speed that the player can move
var _velocity := Vector2.ZERO # The velocity of the player
var _currently_colliding = null setget set_currently_colliding # Stores object that the player is currently colliding with, used to establish a temporary connection

onready var _target = $TargetPos # Gets the player's child node, 'TargetPos' (a set of 2D coordinates describing the point the player needs to move to)

func _on_InteractArea_body_entered(body: Node) -> void: # Called if a body enters player's child node 'InteractArea'
	if body.is_in_group("Objects"):
		body.set_currently_colliding(self) # Establish temporary connection between player and object

func _ready() -> void: # Called once player and all of its children are loaded into the scene
	_target.position = position  # Sets the player's target position to its current position so that it doesn't initially move to the origin (the default position is (0,0))

func _physics_process(delta: float) -> void: # Called every frame
	_target.position = _calculate_target_position()
	_velocity = _calculate_move_velocity(delta)
	move_and_slide(_velocity, FLOOR_NORMAL) # A built in method that moves the player by the given _velocity vector and handles collisions

func _calculate_target_position():
	var out = _target.position # Default return for this function is the current target position, since the player probably won't click this frame
	if Input.is_action_just_released("set_move_location"): # Is true if the left mouse button has just been released
		out = get_viewport().get_mouse_position()  # Sets the target coordinates to the mouse's coordinates
	return out

func _calculate_move_velocity(delta: float) -> Vector2:
	var out = _target.position - position # Sets velocity to a vector from the current position to the target position
	if out.length() < 8.0:
		out = Vector2.ZERO # If the player is acceptably close to its target, velocity is set to zero so the player doesn't jump back and forth trying to reach an exact coordinate
	else:
		out = out.normalized() * _speed; # Otherwise, sets magnitude of the velocity vector to speed
	var in_text_box = _check_in_text_box() # Checks if a text box is being displayed, so that velocity can be altered appropriately
	if in_text_box:
		out = Vector2.ZERO # Ensures that the player can't move while a text box is being displayed
	return out

func _check_in_text_box():
	var out = false
	if not _currently_colliding == null: # Ensure that the player is colliding (they must be colliding for a text box to be shown)
		if _currently_colliding.is_in_group("Objects"): # Ensure that the collider is an object
			if _currently_colliding.get_is_interacting(): # True if object is displaying text
				out = true
			else:
				out = false
				_currently_colliding.set_currently_colliding(null) # Terminate connection between player and object
				# This is necessary so that the player is free to move once text has stopped being displayed
	return out

func set_currently_colliding(given_currently_colliding): # Setter for _currently_colliding
	_currently_colliding = given_currently_colliding
