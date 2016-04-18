package;

import flixel.math.FlxRandom;

class LeftLGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, ORANGE);
		addBlock(x + 1, y, ORANGE);
		
		var r = new FlxRandom().int(0, 3);
		switch(r) {
			case 0:
				addBlock(x, y - 1, ORANGE);
				addBlock(x, y - 2, ORANGE);
			case 1:
				addBlock(x + 2, y, ORANGE);
				addBlock(x + 2, y - 1, ORANGE);
			case 2:
				addBlock(x + 1, y + 1, ORANGE);
				addBlock(x + 1, y + 2, ORANGE);
			case 3:
				addBlock(x + 2, y, ORANGE);
				addBlock(x, y + 1, ORANGE);
		}
	}
	
}