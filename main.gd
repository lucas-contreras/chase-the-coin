extends Node2D

@export var gameTime: int;

@onready var Coin = preload("res://coin/coin.tscn");
@onready var screenSize = Vector2(480, 720);
@onready var player = $Player;

var level := 1;
var score;
var timeLeft;
var playing = false;

func generateCoins():
	for i in range(4 + level):
		var coin = Coin.instantiate();
		var x = randf_range(0, screenSize.x);
		var y = randf_range(0, screenSize.y);
		
		coin.position = Vector2(x, y)
		$CoinsContainer.add_child(coin);
	
func newGame():
	playing = true;
	level = 1;
	score = 0;
	timeLeft = 0;
	player.start($InitMarker.position);
	player.show();
	$Timer.start();
	generateCoins();

func _ready():
	randomize();
	player.windowT = screenSize;
	player.hide();
	newGame();

func _process(delta):
	if playing and $CoinsContainer.get_child_count() == 0:
		level += 1;
		timeLeft += 5;
		generateCoins();
	
