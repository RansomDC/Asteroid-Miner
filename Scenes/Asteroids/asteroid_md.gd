class_name Asteroid_md extends Destructor

# Signals
signal asteroid_destroyed(position : Vector2, assType : Destructor)
signal spawn_crystal(position : Vector2)

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var rng = RandomNumberGenerator.new()
var asteroid_size = 64

func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		destroy()
	
	if area.get_parent() is Player:
		destroy()

func destroy():
	collisionShape.set_deferred("disabled", true)
	destructionComponent.destroy()
	asteroid_destroyed.emit(self.global_position, self)
	
			# Happens 35% of the time
	if rng.randf() < 0.35:
		spawn_crystal.emit(self.global_position)
		print("spawn crystal signal sent")
