extends CanvasLayer

signal game_start;

func update_score(value):
	$Menu/ScoreLabel.text = str(value);

func update_timer(value):
	$Menu/TimeLabel.text = str(value);

func update_start_message(text):
	$Menu/StartLabel.text = text;
	$Menu/StartLabel.show();
	$MessageTimer.start();

func _on_message_timer_timeout():
	$Menu/StartLabel.hide();

func _on_button_pressed():
	$Menu/Button.hide();
	$Menu/StartLabel.hide();
	emit_signal("game_start");
	
func show_game_over():
	update_start_message("Game over");
	await $MessageTimer.timeout;
	$Menu/Button.show();
	$Menu/StartLabel.text = "Pick the coins again!";
	$Menu/StartLabel.show();
