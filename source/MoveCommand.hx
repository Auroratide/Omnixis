package;

class MoveCommand {
	public var blocks:BlockGroup;
	public var dx:Int;
	public var dy:Int;
	
	public function new(blocks:BlockGroup, dx:Int, dy:Int) {
		this.blocks = blocks;
		this.dx = dx;
		this.dy = dy;
	}
	
	public function exec():Void {
		blocks.move(dx, dy);
	}
	
	public function undo():Void {
		blocks.move(-dx, -dy);
	}
}