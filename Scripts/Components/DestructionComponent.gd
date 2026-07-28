extends Node

@onready var destructable_object = get_parent()
@onready var parts = getParts()

@export var destroyed = false

var deathMomentumDirection = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var spinning_speeds = [-3, -2, 2, 3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if destroyed == true:
		_explode_action(delta)

func _explode_action(delta):
	# First Make the object stop moving
	destructable_object.velocity = Vector2.ZERO
	# Set the objects rotation to default
	destructable_object.rotation = 0
	
	# For each part, set the angle of its movement after death
	for part in parts:
		# If the object's part doesn't have a random value set for the dispersal direction give it one
		if part.disperseDirection == Vector2.ZERO:
			part.disperseDirection = deathMomentumDirection + Vector2(rng.randf_range(-40, 40), rng.randf_range(-40, 40))
			
		# If the object's part doesn't have a random value set for the dispersal rotation give it one
		if part.disperseRotation == 0:
			part.disperseRotation = spinning_speeds.pick_random()
			
		# disperse the parts over time
		part.position.x += part.disperseDirection.x * 1 * delta
		part.position.y += part.disperseDirection.y * 1 * delta
		# rotate the parts over time
		part.rotation += part.disperseRotation * delta
		
		# Make the parts fade out
		part.default_color.a8 -= 1

func getParts():
	var parts = destructable_object.get_children()
	var result = []
	for child in parts:
		if child is DestructablePart:
			result.append(child)
	return result

func destroy():
	destroyed = true

func regen():
	destroyed = false
