package;

import flixel.math.FlxRandom;

class RightSGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, BLUE);
		addBlock(x - 1, y, BLUE);
		
		var rand = new FlxRandom();
		
		if (rand.bool()) {
			addBlock(x - 1, y - 1, BLUE);
			addBlock(x - 2, y - 1, BLUE);
		}
		else {
			addBlock(x - 1, y + 1, BLUE);
			addBlock(x, y - 1, BLUE);
		}
	}
	
}