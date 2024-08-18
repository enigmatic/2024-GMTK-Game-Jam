@tool
extends EditorScript

var randomHolderName = 'RandomRocks';
var sceneToPlace = "res://scenes/rock.tscn";
var numberToAdd = 100;
var minPos = Vector2(-1000,0)
var maxPos = Vector2(0,2500)

func placeThing(parent:Node, position:Vector2):
	var scene = load(sceneToPlace);
	var placeScene = scene.instantiate();
	placeScene.position = position;
	placeScene.randomSeed = randi();
	placeScene.variation = randi_range(5,20);
	var scale = randf_range(1.5,0.25);
	placeScene.scale.x = scale;
	placeScene.scale.y = scale;
	parent.add_child(placeScene);
	placeScene.owner = get_scene();

# Called when the node enters the scene tree for the first time.
func _run():
	print('running')
	var rootNode = get_scene();
	print(rootNode)
	var rndHolder:Node = rootNode.find_child(randomHolderName, true);
	if !rndHolder:
		rndHolder = Node.new();
		rndHolder.name = randomHolderName;
		rootNode.add_child(rndHolder);
		rndHolder.owner = get_scene();
	
	for child in rndHolder.get_children():
		child.queue_free()
	
	
	
	for i in range(0, numberToAdd):
		var position = Vector2(randi_range(minPos.x, maxPos.x), randi_range(minPos.y, maxPos.y));
		placeThing(rndHolder, position);
