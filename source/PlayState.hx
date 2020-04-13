package;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class PlayState extends FlxState
{
	var mapTiles:FlxOgmo3Loader;
	var map:FlxTilemap;
	var walkers:FlxTypedGroup<Walker>;
	var junctions:FlxTypedGroup<Junction>;
	var mayor:Mayor;
	var speechTimer:FlxTimer;
	var speechText:FlxText;

	override public function create()
	{
		mapTiles = new FlxOgmo3Loader(AssetPaths.covid_lemmings__ogmo, AssetPaths.map_002__json);
		map = mapTiles.loadTilemap(AssetPaths.tiles64x64Fancy__png, "tiles");
		map.follow();
		map.setTileProperties(1, FlxObject.NONE);
		map.setTileProperties(2, FlxObject.ANY);
		map.setTileProperties(3, FlxObject.NONE);
		map.setTileProperties(4, FlxObject.ANY);
		add(map);

		walkers = new FlxTypedGroup<Walker>();
		add(walkers);
		mapTiles.loadEntities(placeWalkers, "walkers");
		junctions = new FlxTypedGroup<Junction>();
		add(junctions);
		mapTiles.loadEntities(placeJunctions, "walkers");

		mayor = new Mayor();
		mayor.visible = false;
		add(mayor);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		walkers.forEachAlive(function (walker) {
			if (walker.isOnScreen()) {
				FlxG.collide(walker, walkers, (walker, _) -> FlxG.switchState(new LoseState()));
				FlxG.collide(walker, map, (walker, _) -> walker.chooseRandomDirection());
				FlxG.collide(walker, mayor, (walker, mayor) -> walker.turnAround());
				checkJunctionEntry(walker);
			} else {
				walker.kill();
			}
		});

		if (FlxG.mouse.justReleased) {
			placeLori();
		}

		if (walkers.countLiving() <= 0) {
			FlxG.switchState(new WinState());
		}
	}

	function placeLori() {
		removeText();
		if (speechTimer != null) {
			speechTimer.cancel();
		}

		var tileCoordX:Int = Math.floor(FlxG.mouse.x / 64);
		var tileCoordY:Int = Math.floor(FlxG.mouse.y / 64);
		var tileUnderMouse = map.getTile(tileCoordX, tileCoordY);
		trace("placing lori at " + tileCoordX + ", " + tileCoordY);
		if (tileUnderMouse == 1) {
			var x = tileCoordX * 64 + 15; // fudge for narrow sprite, ick
			var y = tileCoordY * 64;
			mayor.visible = true;
			FlxTween.tween(mayor, { x: x, y: y }, 1, { ease: FlxEase.bounceOut, onComplete: showText.bind(_, x, y) });
		}

	}

	function showText(tween:FlxTween, x:Float, y: Float) {
		speechText = new FlxText(x - 50, y - 15, 0, "Stay home, save lives", 18);
		speechText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4);
		add(speechText);
		
    speechTimer = new FlxTimer();
    speechTimer.start(3.0, hideText, 0);
	}

	// Gross hack to let removeText() be callable from places without a timer
	function hideText(timer:FlxTimer) {
		removeText();
	}

	function removeText() {
		remove(speechText);
	}

	function checkJunctionEntry(walker:Walker) {
		walker.inJunction = FlxG.overlap(walker, junctions);
	}

	public function placeWalkers(entity:EntityData) {
		if (entity.name == "walker") {
			var startDirection = FlxObject.RIGHT;
			switch (entity.values.initial_direction) {
				case "up":
					startDirection = FlxObject.UP;
				case "down":
					startDirection = FlxObject.DOWN;
				case "left":
					startDirection = FlxObject.LEFT;
				case "right":
					startDirection = FlxObject.RIGHT;
			}
			var walker = new Walker(entity.x, entity.y, startDirection);
			walkers.add(walker);
		}
	}

	public function placeJunctions(entity:EntityData) {
		if (entity.name == "junction") {
			var junction = new Junction(entity.x, entity.y);
			junctions.add(junction);
		}
	}
}
