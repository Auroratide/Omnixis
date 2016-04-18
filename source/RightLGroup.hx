package;

import flixel.math.FlxRandom;

class RightLGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, MAGENTA);
		addBlock(x + 1, y, MAGENTA);
		
		var r = new FlxRandom().int(0, 3);
		switch(r) {
			case 0:
				addBlock(x + 1, y - 1, MAGENTA);
				addBlock(x + 1, y - 2, MAGENTA);
			case 1:
				addBlock(x + 2, y, MAGENTA);
				addBlock(x + 2, y + 1, MAGENTA);
			case 2:
				addBlock(x, y + 1, MAGENTA);
				addBlock(x, y + 2, MAGENTA);
			case 3:
				addBlock(x + 2, y, MAGENTA);
				addBlock(x, y - 1, MAGENTA);
		}
	}
	
}