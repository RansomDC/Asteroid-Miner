extends Node

# This code sets the player's location to the opposite side of the screen when they go past the edge.

func traverse_edge(screenSize, globalPosition, objectSize):
	if (globalPosition.y + objectSize) > 0 && (globalPosition.y - objectSize) < screenSize.y && (globalPosition.x + objectSize) > 0 && (globalPosition.x - objectSize) < screenSize.x:
		return globalPosition
	elif (globalPosition.y + objectSize) < 0:
		return Vector2(globalPosition.x, (screenSize.y + objectSize))
	elif (globalPosition.y - objectSize) > screenSize.y:
		return Vector2(globalPosition.x, -objectSize)
	elif (globalPosition.x + objectSize) < 0:
		return Vector2((screenSize.x + objectSize), globalPosition.y)
	elif (globalPosition.x - objectSize) > screenSize.x:
		return Vector2(-objectSize, globalPosition.y)
