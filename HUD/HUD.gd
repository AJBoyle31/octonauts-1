extends CanvasLayer

#var score = 0 setget update_score
var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var stats = PlayerStats



signal game_over

onready var scoreLabel = $Container/ScoreLabel
onready var fishCounter = $Container/FishCounter
onready var heartUIFull = $Health/HeartUIFull
onready var heartUIEmpty = $Health/HeartUIEmpty
onready var godMode = $GodMode
#onready var score = stats.currentScore

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(PlayerScore.score)
	PlayerScore.connect("score_changed", self, "update_score")
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	PlayerStats.connect("update_god_mode", self, "set_god_mode")

func _process(delta):
	update_counter()


func update_score(value) -> void:
	scoreLabel.text = "Score: " + str(value)
	

func update_counter() -> void:
	var count = get_tree().get_nodes_in_group("Fish").size()
	fishCounter.text = "Fish Left: " + str(count)
	#if count <= 0:
	#	$Winner.visible = true
	#	$ResetButton.visible = true
	#	emit_signal("game_over")

func _on_ResetButton_pressed() -> void:
	$GameOver.visible = false
	$ResetButton.visible = false
	$Winner.visible = false
	heartUIFull.visible = true
	PlayerScore.myScore = 0
	get_tree().reload_current_scene()

func set_hearts(value) -> void:
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	if hearts <= 0:
		$GameOver.visible = true
		$ResetButton.visible = true
		heartUIFull.visible = false
		emit_signal("game_over")

func set_max_hearts(value) -> void:
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15

func set_god_mode():
	godMode.visible = !godMode.visible

