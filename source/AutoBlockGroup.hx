package;

import flixel.FlxG;

class AutoBlockGroup extends BlockGroup {

	private var direction:Direction;
	
	public function new(dir:Direction) {
		super();
		this.direction = dir;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (C.state().heartbeat()) {
			var moveCommand = switch(direction) {
				case LEFT:  new MoveCommand(this, -1, 0);
				case RIGHT: new MoveCommand(this, 1, 0);
				case UP:    new MoveCommand(this, 0, -1);
				case DOWN:  new MoveCommand(this, 0, 1);
			};
			moveCommand.exec();
			//moveAndMerge(moveCommand, [this]);  // game becomes weeeeird.
			if (C.state().player != null && FlxG.overlap(C.state().player, this)) {
				moveCommand.undo();
				flash();
				C.state().player.merge(this);
			}
		}
	}
	
}