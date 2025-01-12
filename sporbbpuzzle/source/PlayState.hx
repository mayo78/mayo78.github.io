package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
	var dortas:Tile;

	var tiles = new FlxTypedGroup<Tile>();

	override public function create() {
		super.create();

		for (i in 0...9) {
			final tile = new Tile(i, i == 6);
			if (tile.dortas) 
				dortas = tile;
			tiles.add(tile);
		}
		dortas.visible = false;
		add(tiles);
		FlxG.mouse.visible = false;
	}

	override function draw() {
		super.draw();
		dortas.draw();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (dortas.tween == null || dortas.tween.finished) {
			if (FlxG.keys.justPressed.LEFT)
				swapTile(dortas.gridX - 1, dortas.gridY);
			else if (FlxG.keys.justPressed.RIGHT)
				swapTile(dortas.gridX + 1, dortas.gridY);
			else if (FlxG.keys.justPressed.UP)
				swapTile(dortas.gridX, dortas.gridY - 1);
			else if (FlxG.keys.justPressed.DOWN)
				swapTile(dortas.gridX, dortas.gridY + 1);
		}
	}

	function swapTile(x:Int, y:Int) {
		for (tile in tiles.members) {
			if (tile.gridX == x && tile.gridY == y) {
				tile.move(dortas.gridX, dortas.gridY);
				dortas.move(x, y);
				break;
			}
		}
	}
}

class Tile extends FlxSprite {
	public var dortas:Bool;

	public var gridX = 0;
	public var gridY = 0;

	public var tween:FlxTween;

	public function new(i = 0, dortas = false) {
		gridX = i % 3;
		gridY = Math.floor(i / 3) % 3;
		super(gridX * 128, gridY * 128, dortas ? AssetPaths.dortas__png : AssetPaths.argskull__png);
		setGraphicSize(128, 128);
		updateHitbox();
		this.dortas = dortas;
	}

	public function move(gridX = 0, gridY = 0) {
		tween?.cancel();
		tween = FlxTween.tween(this, {x: gridX * 128, y: gridY * 128}, .25);
		this.gridX = gridX;
		this.gridY = gridY;
	}
}
