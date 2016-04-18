package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(464, 464, MenuState, 2, 60, 60, true));
	}
}