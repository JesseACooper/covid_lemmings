package;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Walker extends FlxSprite
{
  static inline var SPEED:Float = 64;
  var timer:FlxTimer;
  var roadCoords:Array<FlxPoint>;
  var impassibleCoords:Array<FlxPoint>;

  static var DIRECTIONS = [ 
    ["x" => 64, "y" => 0, "facing" => FlxObject.RIGHT],
    ["x" => 0, "y" => 64, "facing" => FlxObject.DOWN],
    ["x" => -64, "y" => 0, "facing" => FlxObject.LEFT],
    ["x" => 0, "y" => -64, "facing" => FlxObject.UP]
  ];


  public function new(x:Float = 0, y:Float = 0) {
    super(x, y);
    // makeGraphic(16, 16, FlxColor.BLUE);
    loadGraphic(AssetPaths.blue1__png, true, 64, 64);
    animation.add("up",    [for (i in 1...9) i + (13 * 8)]);
    animation.add("left",  [for (i in 1...9) i + (13 * 9)]);
    animation.add("down",  [for (i in 1...9) i + (13 * 10)]);
    animation.add("right", [for (i in 1...9) i + (13 * 11)]);
    timer = new FlxTimer();
    timer.start(1.0, updateMovement, 0);
  }

  function updateMovement(timer:FlxTimer) {
    var canMoveUp = true;
    var canMoveLeft = true;
    var canMoveDown = true;
    var canMoveRight = true;
    if (roadCoords != null && impassibleCoords != null) {

      for (i in 0...roadCoords.length) {
        trace("WalkerCoord: (" + x + ", " + y + ")" + " | RoadCoord: (" + roadCoords[i].x + ", " + roadCoords[i].y + ")");
        if (roadCoords[i].x == x - 64 && roadCoords[i].y == y) {
          trace("Adjacent left found!!");
          canMoveLeft = false;
        }
        if (roadCoords[i].x == x + 64 && roadCoords[i].y == y) {
          trace("Adjacent right found!!");
          canMoveRight = false;
        }
        if (roadCoords[i].y == y - 64 && roadCoords[i].x == x) {
          trace("Adjacent up found!!");
          canMoveUp = false;
        }
        if (roadCoords[i].y == y + 64 && roadCoords[i].x == x) {
          trace("Adjacent found!!");
          canMoveDown = false;
        }
      }

      for (i in 0...roadCoords.length) {
        trace("WalkerCoord: (" + x + ", " + y + ")" + " | ImpassibleCoord: (" + impassibleCoords[i].x + ", " + impassibleCoords[i].y + ")");
        if (impassibleCoords[i].x == x - 64 && impassibleCoords[i].y == y) {
          trace("Adjacent left found!!");
          canMoveLeft = false;
        }
        if (impassibleCoords[i].x == x + 64 && impassibleCoords[i].y == y) {
          trace("Adjacent right found!!");
          canMoveRight = false;
        }
        if (impassibleCoords[i].y == y - 64 && impassibleCoords[i].x == x) {
          trace("Adjacent up found!!");
          canMoveUp = false;
        }
        if (impassibleCoords[i].y == y + 64 && impassibleCoords[i].x == x) {
          trace("Adjacent found!!");
          canMoveDown = false;
        }
      }
    }

    var validDirections = [];
    if (canMoveUp) validDirections.push(DIRECTIONS[0]);
    if (canMoveLeft) validDirections.push(DIRECTIONS[1]);
    if (canMoveDown) validDirections.push(DIRECTIONS[2]);
    if (canMoveRight) validDirections.push(DIRECTIONS[3]);

    // If you're trapped, just keep walking right
    if (validDirections.length <= 0) validDirections.push(DIRECTIONS[3]);
    // choose a new direction
    var directionIndex = Std.random(validDirections.length);

    // Uncomment to make testing easier while we have undirected random walking
    // if (directionIndex == 0 || directionIndex == 3) {
    //   directionIndex = 1;
    // }
    var newDirection = validDirections[directionIndex];
    velocity.x = newDirection["x"];
    velocity.y = newDirection["y"];
    facing = newDirection["facing"];
  }

  override function update(elapsed: Float) {
    switch (facing)
    {
      case FlxObject.LEFT:
        animation.play("left");
      case FlxObject.RIGHT:
        animation.play("right");
      case FlxObject.UP:
        animation.play("up");
      case FlxObject.DOWN:
        animation.play("down");
    }
    super.update(elapsed);
  }

  public function setMapState(roadCoords:Array<FlxPoint>, impassibleCoords:Array<FlxPoint>) {
    this.roadCoords = roadCoords;
    this.impassibleCoords = impassibleCoords;
  }
}