package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class BlockGroup extends FlxTypedGroup<Block> {
	
	public function new() {
		super();
	}
	
	public function move(dx:Int, dy:Int):Void {
		this.forEachAlive(function(b) {
			b.x += C.unit(dx);
			b.y += C.unit(dy);
		});
	}
	
	public function addBlock(x:Int, y:Int, color:Color):Block {
		var b = new Block(C.unit(x), C.unit(y), color);
		C.state().blocks.add(b);
		this.add(b);
		return b;
	}
	
	public function removeBlock(block:Block):Void {
		this.remove(block);
		C.state().blocks.remove(block);
		block.destroy();
	}
	
	public function moveAndMerge(moveCommand:MoveCommand, visited:Array<BlockGroup>):Void {
		moveCommand.exec();
		var overlaps = Lambda.filter(C.state().overlaps(moveCommand.blocks), function(bg) {
			return visited.indexOf(bg) < 0;
		});
		for (g in overlaps) {
			visited.push(g);
			g.flash();
			moveAndMerge(new MoveCommand(g, moveCommand.dx, moveCommand.dy), visited);
			this.merge(g);
		}
	}
	
	public function flash():Void {
		forEachAlive(function(b) {
			b.flash();
		});
		FlxG.sound.load(AssetPaths.tone1__ogg).play(true);
	}
	
/**
 *  Keep this group, destroy the other
 *  @param	other
 */
	public function merge(other:BlockGroup):Void {
		for (b in other) 
			this.add(b);
		C.state().blockGroups.remove(other);
		other.clear();
		other.destroy();
	}
	
	public function isOutOfBounds():Bool {
		var outOfBounds = true;
		for (b in this)
			outOfBounds = outOfBounds && !(new FlxPoint(b.x, b.y).inRect(FlxG.worldBounds));
		return outOfBounds;
	}
}