extends Area2D

@onready var screenSize = Vector2(480, 720);

func pick():
	var tween = create_tween();
	tween.tween_property($AnimatedSprite2D, "modulate", Color.GRAY, .2);
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(.1, .1), .2);
	tween.finished.connect(delete);
	
func delete():
	queue_free();

func _on_life_timer_timeout():
	pass # Replace with function body.


func _on_area_entered(area):
	if area.is_in_group("Enemies"):
		var x = randf_range(0, screenSize.x);
		var y = randf_range(0, screenSize.y);
		
		position = Vector2(x, y)
