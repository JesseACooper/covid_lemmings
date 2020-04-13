package;

import flixel.math.FlxRandom;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Walker extends FlxSprite
{
  static inline var SPEED:Float = 64;
  var timer:FlxTimer;

  public var leavingJunction:Bool = false;
  public var inJunction:Bool = false;

  static var DIRECTIONS = [ 
    ["x" => 64, "y" => 0, "facing" => FlxObject.RIGHT],
    ["x" => 0, "y" => 64, "facing" => FlxObject.DOWN],
    ["x" => -64, "y" => 0, "facing" => FlxObject.LEFT],
    ["x" => 0, "y" => -64, "facing" => FlxObject.UP]
  ];


  public function new(x:Float = 0, y:Float = 0, initialFacing = FlxObject.RIGHT) {
    super(x, y);
    // makeGraphic(16, 16, FlxColor.BLUE);
    loadGraphic(AssetPaths.blue1__png, true, 64, 64);
    animation.add("up",    [for (i in 1...9) i + (13 * 8)]);
    animation.add("left",  [for (i in 1...9) i + (13 * 9)]);
    animation.add("down",  [for (i in 1...9) i + (13 * 10)]);
    animation.add("right", [for (i in 1...9) i + (13 * 11)]);

    setSize(56, 56);
    offset.set(8, 8);

    setDirectionFromFacing(initialFacing);
    timer = new FlxTimer();
    timer.start(1.0, updateMovement, 0);
    elasticity = 1;
  }

  function updateMovement(timer:FlxTimer) {
    // move out of a junction
    if (inJunction) {
      if (!leavingJunction) {
         chooseRandomDirection();
         leavingJunction = true;
      }
    } else {
      inJunction = leavingJunction = false;
    }
  }

  public function setDirectionFromFacing(newFacing:Int = FlxObject.RIGHT) {
    var newDirection = Lambda.find(DIRECTIONS, (dir) -> return dir["facing"] == newFacing);
    velocity.x = newDirection["x"];
    velocity.y = newDirection["y"];
    facing = newDirection["facing"];
  }

  public function chooseRandomDirection() {
    // choose a new direction
    var directionIndex = Std.random(DIRECTIONS.length);

    // Uncomment to make testing easier while we have undirected random walking
    // if (directionIndex == 0 || directionIndex == 3) {
    //   directionIndex = 1;
    // }
    var newDirection = DIRECTIONS[directionIndex];
    velocity.x = newDirection["x"];
    velocity.y = newDirection["y"];
    facing = newDirection["facing"];
  }

  public function turnAround() {
    switch (facing) {
      case FlxObject.LEFT:
        facing = FlxObject.RIGHT;
      case FlxObject.RIGHT:
        facing = FlxObject.LEFT;
      case FlxObject.UP:
        facing = FlxObject.DOWN;
      case FlxObject.DOWN:
        facing = FlxObject.UP;
    }
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
}