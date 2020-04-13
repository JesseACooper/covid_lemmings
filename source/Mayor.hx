package;

import flixel.addons.display.FlxExtendedSprite;

class Mayor extends FlxExtendedSprite {

  public function new(x:Float = 0, y:Float = 0) {
    super(x, y);
    loadGraphic(AssetPaths.lightfootcutout__png, false, 64, 64);
  }

}
