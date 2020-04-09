package;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class PlayState extends FlxState
{
	var mapTiles:FlxOgmo3Loader;
	var map:FlxTilemap;

	override public function create()
	{
		mapTiles = new FlxOgmo3Loader(AssetPaths.covid_lemmings__ogmo, AssetPaths.map_001__json);
		map = mapTiles.loadTilemap(AssetPaths.tiles__png, "tiles");
		map.follow();
		map.setTileProperties(1, FlxObject.NONE);
		map.setTileProperties(2, FlxObject.ANY);
		map.setTileProperties(3, FlxObject.NONE);
		map.setTileProperties(4, FlxObject.ANY);
		add(map);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
