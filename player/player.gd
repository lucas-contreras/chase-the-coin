extends Area2D

@export var velocity : int;
@onready var animationSprite: AnimatedSprite2D = $AnimatedSprite2D;

var movementInput := Vector2();
# TODO: access to global configuration from the project window
var windowT = Vector2(480, 720);

func _process(delta):
	getInput();
	position += movementInput * delta;
	
	if movementInput.length() > 0:
		animationSprite.animation = "run";
		# TODO: nested ifs is not considered as a good practice
		if movementInput.x != 0:
			animationSprite.flip_h = movementInput.x < 0;
	else:
		animationSprite.animation = "idle";

func getInput():
	movementInput = Vector2();
	
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	
	movementInput.x = x;
	movementInput.y = y;

	movementInput = velocity * movementInput.normalized();
	calculateBoundaries();

func calculateBoundaries():
	position.x = clamp(position.x, 0, windowT.x);
	position.y = clamp(position.y , 50, windowT.y)
