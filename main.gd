extends Node2D

@export var gameTime: int;

@onready var Coin = preload("res://coin/coin.tscn");
@onready var Powerup = preload("res://powerup/powerup.tscn");
@onready var Cactus = preload("res://enemy/cactus.tscn");

@onready var screenSize = Vector2(480, 720);
@onready var player = $Player;
@onready var HUD = $HUB;

var level := 1;
var score;
var timeLeft;
var playing = false;

func generateCactus():
	var cactus = Cactus.instantiate();
	var x = randf_range(0, screenSize.x);
	var y = randf_range(0, screenSize.y);
		
	cactus.position = Vector2(x, y)
	add_child(cactus);

func generateCoins():
	generateCactus();
	for i in range(4 + level):
		var coin = Coin.instantiate();
		var x = randf_range(0, screenSize.x);
		var y = randf_range(0, screenSize.y);
		
		coin.position = Vector2(x, y)
		$CoinsContainer.add_child(coin);
	
func newGame():
	$StartAudio.play();
	playing = true;
	level = 1;
	score = 0;
	timeLeft = 10;
	player.start($InitMarker.position);
	player.show();
	
	$Timer.start();
	$SpawnPowerupTimer.start();
	
	generateCoins();
	
	HUD.update_score(score);
	HUD.update_timer(timeLeft);

func _ready():
	randomize();
	player.windowT = screenSize;
	player.hide();

func _process(delta):
	if playing and $CoinsContainer.get_child_count() == 0:
		level += 1;
		timeLeft += 5;
		generateCoins();
	
func _on_timer_timeout():
	timeLeft -=1;
	HUD.update_timer(timeLeft);
	if timeLeft <= 0:
		game_over();

func game_over():
	playing = false;
	
	$DieAudio.play();
	
	$Timer.stop();
	$SpawnPowerupTimer.stop();
	
	for coin in $CoinsContainer.get_children():
		coin.queue_free();
	
	HUD.show_game_over();
	player.getDie();

func _on_player_harvest(area_picked):
	match area_picked:
		"coin":
			$CoinAudio.stream = load("res://assets/audio/Coin.wav");
			score += 1;
			HUD.update_score(score);
		"powerup":
			$CoinAudio.stream = load("res://assets/audio/Powerup.wav");
			timeLeft += 3;
	$CoinAudio.play();

func _on_player_get_hurt():
	$DieAudio.play();
	game_over();

func _on_spawn_powerup_timer_timeout():
	$SpawnPowerupTimer.wait_time = randi_range(3, 10);
	var powerup = Powerup.instantiate();
	add_child(powerup);
	powerup.position = Vector2(randf_range(0, screenSize.x), randf_range(0, screenSize.y));
