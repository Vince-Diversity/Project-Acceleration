@tool
extends CanvasItem

@export_range(0, 10) var r := 1.0
@export_range(0, PI) var a := 0.1


func _draw():
	var p := PackedVector2Array();
	p.append(Vector2.ZERO)
	p.append(Utils.ra2xy(r, -a))
	p.append(Utils.ra2xy(r, a))
	draw_polygon(p, [Color(0, 0, 0, 0.5)])


func _process(_delta):
	queue_redraw()
