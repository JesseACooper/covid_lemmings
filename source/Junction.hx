package;

import flixel.FlxSprite;

class Junction extends FlxSprite {
  
  public function new(x:Float = 0, y:Float = 0) {
    super(x, y);
    loadGraphic(AssetPaths.decision_64__png, false, 64, 64);
    alpha = 0;
  }

} 

