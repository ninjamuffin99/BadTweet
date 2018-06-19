package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class TweetSprite extends FlxSpriteGroup 
{
	public var box:FlxSprite;
	private var profilePic:FlxSprite;
	private var tweetText:FlxText;
	
	private var likes:FlxText;
	private var curLikes:Int = 0;
	private var username:FlxText;
	
	public function new(X:Float=0, Y:Float=0, text:String) 
	{
		super(X, Y);
		
		tweetText = new FlxText(0, 8, FlxG.width - 82, "   Cam", 20);
		tweetText.text += "\n" + text;
		
		username = new FlxText(tweetText.x + 170, 8, 0, "@ninja_muffin99", 20);
		username.alpha = 0.5;
		
		
		box = new FlxSprite(0, 0);
		box.makeGraphic(FlxG.width, 64 + tweetText.textField.numLines * 24 + 8, 0xFF1B2836);
		add(box);
		
		profilePic = new FlxSprite(6, 10).loadGraphic(AssetPaths.twitterPic__jpg);
		profilePic.setGraphicSize(64, 64);
		profilePic.updateHitbox();
		add(profilePic);
		
		tweetText.x = profilePic.x + profilePic.width + 12;
		
		
		add(tweetText);
		add(username);
		
		likes = new FlxText(40, box.height - 34, 0, "♡ " + curLikes, 20);
		likes.alpha = 0.5;
		add(likes);
		
		if (FlxG.random.bool(50))
		{
			new FlxTimer().start(FlxG.random.float(2, 5), function(timer:FlxTimer)
			{
				if (FlxG.random.bool(25))
					curLikes += 1;
			}, 0);
		}
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		likes.text = "Likes <3 " + curLikes;
		
		super.update(elapsed);
		
		if ((FlxG.mouse.overlaps(profilePic) || FlxG.mouse.overlaps(username) )&& FlxG.mouse.justPressed)
		{
			FlxG.openURL("https://twitter.com/ninja_muffin99");
		}
	}
	
}