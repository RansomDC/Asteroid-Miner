extends Node

# These methods set the player's location to the opposite side of the screen when they go past the edge.

func traverse_y(screenSize, globalPosition, shipSize):
	if (globalPosition.y + shipSize) > 0 && (globalPosition.y - shipSize) < screenSize.y:
		return globalPosition.y
	elif (globalPosition.y + shipSize) < 0:
		return (screenSize.y + shipSize)
	elif (globalPosition.y - shipSize) > screenSize.y:
		return -shipSize

func traverse_x(screenSize, globalPosition, shipSize):
	if (globalPosition.x + shipSize) > 0 && (globalPosition.x - shipSize) < screenSize.x:
		return globalPosition.x
	if (globalPosition.x + shipSize) < 0:
		return (screenSize.x + shipSize)
	elif (globalPosition.x - shipSize) > screenSize.x:
		return -shipSize
