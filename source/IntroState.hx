package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.FlxState;

class IntroState extends FlxState {

  var playButton:FlxButton;

  override public function create()
    {
      var titleText = new flixel.text.FlxText(0, 100, 0, "Lemmings: Chicago 2020 Edition", 64);
      var setupText = new flixel.text.FlxText(0, 200, 0, "People of Chicago want to stop the spread of coronavirus.\nBut they need your help!", 32);
      var instructionText = new flixel.text.FlxText(0, 300, 0, "Click to enforce social distancing rules.", 32);
      titleText.screenCenter(FlxAxes.X);
      setupText.screenCenter(FlxAxes.X);
      instructionText.screenCenter(FlxAxes.X);
      add(titleText);
      add(setupText);
      add(instructionText);
      var playButton = new FlxButton(0, 0, "Regulate! ", clickPlay);
      playButton.screenCenter();
      playButton.setPosition(playButton.getPosition().x, playButton.getPosition().y + 65);
      add(playButton);
      super.create();
    }

  function clickPlay()
  {
    FlxG.switchState(new PlayState());
  }
}