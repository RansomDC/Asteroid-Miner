extends Area2D

var is_empty: bool:
	get:
		var check1 = !has_overlapping_areas()
		var check2 = !has_overlapping_bodies()
		return (check1 && check2)
