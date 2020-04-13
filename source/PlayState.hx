package;

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
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		walkers.forEachAlive(function (walker) {
			if (walker.isOnScreen()) {
				FlxG.collide(walker, walkers, (walker, _) -> FlxG.switchState(new LoseState()));
				FlxG.collide(walker, map, (walker, _) -> walker.chooseRandomDirection());
				checkJunctionEntry(walker);
			} else {
				walker.kill();
			}
		});

		if (walkers.countLiving() <= 0) {
			FlxG.switchState(new WinState());
		}
	}

	function checkJunctionEntry(walker:Walker) {
		walker.inJunction = FlxG.overlap(walker, junctions);
	}

	public function placeWalkers(entity:EntityData) {
		if (entity.name == "walker") {
			var walker = new Walker(entity.x, entity.y);
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
