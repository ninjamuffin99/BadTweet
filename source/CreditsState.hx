package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import io.newgrounds.NG;

/**
 * ...
 * @author 
 */
class CreditsState extends FlxState 
{

	private var specialThanks:Array<String> =
	[
		"Special Thanks/Shoutouts", 
		"Davey Wreden",
		"Kyle Seeley",
		"Nina Freeman",
		"Yotam Perel",
		"Nicky Case",
		"Newgrounds.com"
		
		//MUSIC: https://www.newgrounds.com/audio/listen/743522
	];
	
	override public function create():Void 
	{
		if (NGio.isLoggedIn)
		{
			var hornyMedal = NG.core.medals.get(55015);
			if (!hornyMedal.unlocked)
				hornyMedal.sendUnlock();
		}
		
		FlxG.sound.play("assets/sounds/keyEnter.mp3", 0.7);
		
		var end:FlxText = new FlxText(0, 35, 0, "THE END", 45);
		end.screenCenter(X);
		add(end);
		
		for (i in 0...specialThanks.length - 1)
		{
			var thanks:FlxText = new FlxText(0, 150 + (40 * i), 0, specialThanks[i], 25);
			thanks.screenCenter(X);
			add(thanks);
		}
		
		super.create();
	}
	
}