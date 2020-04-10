package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class PlayState extends FlxState
{
	var mapTiles:FlxOgmo3Loader;
	var map:FlxTilemap;
	var walkers:Array<Walker>;

	override public function create()
	{
		mapTiles = new FlxOgmo3Loader(AssetPaths.covid_lemmings__ogmo, AssetPaths.map_002__json);
		map = mapTiles.loadTilemap(AssetPaths.tiles64x64__png, "tiles");
		map.follow();
		map.setTileProperties(1, FlxObject.NONE);
		map.setTileProperties(2, FlxObject.ANY);
		map.setTileProperties(3, FlxObject.NONE);
		map.setTileProperties(4, FlxObject.ANY);
		add(map);

		walkers = new Array<Walker>();
		mapTiles.loadEntities(placeWalkers, "walkers");

		for (i in 0...walkers.length) add(walkers[i]);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		for (i in 0...walkers.length) FlxG.collide(walkers[i], map);
	}

	public function placeWalkers(entity:EntityData) {
		if (entity.name == "walker") {
			var walker = new Walker(entity.x, entity.y);
			walkers.push(walker);
		}
	}
}
