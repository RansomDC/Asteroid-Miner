class_name Asteroid_lg extends Destructor

# Signals
signal asteroid_destroyed(position : Vector2, assType : Destructor)
signal spawn_crystal(position : Vector2, crystalType : PackedScene)
signal update_score(points : int)

const MONEY_CRYSTAL_SCENE = preload("res://Scenes/Crystals/MoneyCrystal/MoneyCrystal.tscn")
const HEALTH_CRYSTAL_SCENE = preload("res://Scenes/Crystals/HealthCrystal/HealthCrystal.tscn")

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var rng = RandomNumberGenerator.new()
var asteroid_size = 80

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
	
	# spawn money crystal 20% of the time
	if rng.randf() < 0.20:
		spawn_crystal.emit(self.global_position, MONEY_CRYSTAL_SCENE)
		print("Spawn health crystal signal sent!")
	
	#spawn health crystal 20% of the time
	if rng.randf() < 0.20:
		spawn_crystal.emit(self.global_position, HEALTH_CRYSTAL_SCENE)
		print("Spawn health crystal signal sent!")
