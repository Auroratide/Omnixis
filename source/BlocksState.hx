package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;

class BlocksState extends FlxState {

	private var counter:Int = 0;
	public var blocks(default, null):FlxTypedGroup<Block>;
	public var blockGroups(default, null):FlxTypedGroup<BlockGroup>;
	public var player(default, null):Player;
	public var beats(default, null):Int;
	
	override public function create():Void {
		super.create();
		blocks = new FlxTypedGroup<Block>();
		blockGroups = new FlxTypedGroup<BlockGroup>();
		beats = C.HEARTBEAT;
		//this.add(blocks);
		//this.add(blockGroups);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		++counter;
	}
	
	public function heartbeat():Bool {
		return counter % beats == 0;
	}
	
	public function overlaps(group:BlockGroup):Array<BlockGroup> {
		var arr = new Array<BlockGroup>();
		for (g in blockGroups) {
			if (g != group && FlxG.overlap(g, group))
				arr.push(g);
		}
		return arr;
	}
	
}