package;

import flixel.math.FlxRandom;

class LeftSGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, GREEN);
		addBlock(x - 1, y, GREEN);
		
		var rand = new FlxRandom();
		
		if (rand.bool()) {
			addBlock(x - 1, y + 1, GREEN);
			addBlock(x - 2, y + 1, GREEN);
		}
		else {
			addBlock(x - 1, y - 1, GREEN);
			addBlock(x, y + 1, GREEN);
		}
	}
	
}