package;

import flixel.text.FlxText;

class DeltaScoreText extends FlxText {

	public function new() {
		super(0, 0, 0, "", 8);
	//	this.scrollFactor.set(0, 0);
		kill();
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		this.y -= 1;
		this.alpha -= 0.01;
		if (alpha <= 0)
			kill();
	}
	
	public function appear(x:Float, y:Float, amount:Int):Void {
		reset(x, y);
		this.alpha = 1;
		this.size = determineSize(amount);
		this.text = "+ " + Std.string(amount);
	}
	
	private function determineSize(amount:Int):Int {
		var sz = 8;
		if (amount > 100)
			sz += 2;
		if (amount > 500)
			sz += 2;
		if (amount > 750)
			sz += 2;
		if (amount > 1100)
			sz += 2;
		if (amount > 1700)
			sz += 2;
		if (amount > 2600)
			sz += 2;
		return sz;
	}
	
}