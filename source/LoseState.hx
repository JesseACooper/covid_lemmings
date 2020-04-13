package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;

class LoseState extends FlxState
{
  var playButton:FlxButton;

	override public function create()
	{
    var victoryText = new flixel.text.FlxText(0, 0, 0, "You lose...", 64);
    victoryText.screenCenter();
    add(victoryText);
    playButton = new FlxButton(0, 0, "Play again?", clickPlay);
    playButton.screenCenter();
    playButton.setPosition(playButton.getPosition().x, playButton.getPosition().y + 65);
    add(playButton);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
  }
  
  function clickPlay()
  {
    FlxG.switchState(new PlayState());
  }
}
