package;

import flixel.FlxG;
import AutoBlockGroup;

class SquareGroup extends AutoBlockGroup {

	public function new(x:Int, y:Int, dir:Direction) {
		super(dir);
		
		addBlock(x, y, YELLOW);
		addBlock(x + 1, y, YELLOW);
		addBlock(x, y + 1, YELLOW);
		addBlock(x + 1, y + 1, YELLOW);
	}
	
}