extends Area2D
signal hit

export var speed : int = 400;
var screen_size;

func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;

func _ready():
	screen_size = get_viewport_rect().size;
	hide();

func _process(delta):
	var velocity = Vector2();
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1;
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		$AnimatedSprite.play();
	else:
		$AnimatedSprite.stop();
		
	position += velocity * delta;
	position.x = clamp(position.x, 0, screen_size.x);
	position.y = clamp(position.y, 0, screen_size.y);
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk";
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0;
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up";
		$AnimatedSprite.flip_v = velocity.y > 0;


func _on_Player_body_entered(body):
	hide();
	emit_signal("hit");
	$CollisionShape2D.set_deferred("disabled", true);
