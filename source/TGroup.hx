package;

import flixel.math.FlxRandom;

class TGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, RED);
		
		var emptySlot = new FlxRandom().int(0, 3);
		
		if(emptySlot != 0)
			addBlock(x + 1, y, RED);
		if(emptySlot != 1)
			addBlock(x, y + 1, RED);
		if(emptySlot != 2)
			addBlock(x - 1, y, RED);
		if(emptySlot != 3)
			addBlock(x, y - 1, RED);
	}
	
}