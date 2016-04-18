package;

import flixel.math.FlxRandom;

class LongGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, CYAN);
		
		var rand = new FlxRandom();
		
		if (rand.bool()) {
			addBlock(x + 1, y, CYAN);
			addBlock(x + 2, y, CYAN);
			addBlock(x - 1, y, CYAN);
		}
		else {
			addBlock(x, y + 1, CYAN);
			addBlock(x, y + 2, CYAN);
			addBlock(x, y - 1, CYAN);
		}
	}
	
}