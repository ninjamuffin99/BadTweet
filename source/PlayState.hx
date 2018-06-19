package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

import com.newgrounds.*;
import com.newgrounds.components.*;

class PlayState extends FlxState
{
	private var curTweet:FlxText;
	private var whatsHappening:FlxText;
	private var tweetLoading:String;
	
	private var tweetCharPos:Int = 0;
	private var tweetsSent:Int = 0;
	
	private var grpTweets:FlxTypedGroup<TweetSprite>;
	private var fontSize:Int = 20;
	
	private var startedMusic:Bool = false;
	private var startedTweet:Bool = false;
	
	private var tweetsNeeded:Int = 0;
	private var endSegment:Bool = false;
	
	override public function create():Void
	{
		
		FlxG.camera.bgColor = 0xFF141D26;
		
		var textBox:FlxSprite = new FlxSprite(2, 2).makeGraphic(FlxG.width - 4, 160 - 4, 0xFF1B3247);
		add(textBox);
		
		whatsHappening = new FlxText(4, 4, 0, "What's happening?", fontSize);
		whatsHappening.alpha = 0.5;
		add(whatsHappening);
		
		regenTweet();
		curTweet = new FlxText(4, 4, FlxG.width - 4, "", fontSize);
		add(curTweet);
		
		grpTweets = new FlxTypedGroup<TweetSprite>();
		add(grpTweets);
		
		var newTweet:TweetSprite = new TweetSprite(0, 160, "Note to self: always make sure I delete my bad tweets before I finish writing them and post the good ones");
		
		grpTweets.add(newTweet);
		
		
		// get through 80% of the tweets before it transitions into the end?
		tweetsNeeded = Math.ceil(Tweets.TweetArray.length * 0.80);
		FlxG.log.add(tweetsNeeded);
		
		super.create();
	}


	
	override public function update(elapsed:Float):Void
	{
		if (tweetsSent >= tweetsNeeded)
		{
			tweetsSent = 0;
			endSegment = true;
		}
		
		if (tweetLoading.length > tweetCharPos)
		{
			
			if (FlxG.keys.justPressed.ANY)
			{
				tweetCharPos += 1;
				FlxG.sound.play("assets/sounds/keyClickOn" + FlxG.random.int(1, 4) + ".mp3");
				
				if (!FlxG.keys.justPressed.BACKSPACE)
					startedTweet = true;
			}
			if (FlxG.keys.justReleased.ANY)
			{
				FlxG.sound.play("assets/sounds/keyClickRelease" + FlxG.random.int(1, 4) + ".mp3");
			}
		}
		else
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				if (!startedMusic)
				{
					FlxG.sound.playMusic(AssetPaths.LSDAIM__mp3, 0.8);
					API.unlockMedal("Bounced on my boys dick to this for hours");
					
					startedMusic = true;
				}
				
				sendTweet();
				if (endSegment)
					tweetsSent += 1;
			}
		}
		
		if (tweetCharPos > 0)
		{
			whatsHappening.visible = false;
			
			if (FlxG.keys.justPressed.BACKSPACE)
			{
				tweetCharPos -= 2;
			}
			
			if (FlxG.keys.pressed.BACKSPACE)
			{
				tweetCharPos -= 1;
			}
		}
		else
		{
			if (startedTweet)
			{
				regenTweet();
				startedTweet = false;
			}
			whatsHappening.visible = true;
		}
		
		
		curTweet.text = tweetLoading.substring(0, tweetCharPos);
		
		super.update(elapsed);
	}
	
	private function sendTweet():Void
	{
		if (!endSegment)
			FlxG.sound.play("assets/sounds/keyEnter.mp3", 0.7);
		
		var newTweet:TweetSprite = new TweetSprite(0, 160, curTweet.text);
		
		grpTweets.forEachAlive(function(tweet:TweetSprite)
		{
			tweet.y += newTweet.box.height + 2;
			
			// a little bit of optimization for when the tweets go offscreen
			if (tweet.y > FlxG.height)
			{
				tweet.kill();
			}
			
		});
		
		grpTweets.add(newTweet);
		
		
		regenTweet();
		tweetCharPos = 0;
	}
	
	private function regenTweet():Void
	{
		if (!endSegment)
		{
			tweetsSent += 1;
		
			if (tweetsSent < Tweets.TweetArray.length - 1)
			{
				tweetLoading = Tweets.TweetArray[FlxG.random.int(tweetsSent, Tweets.TweetArray.length -1)];
				Tweets.TweetArray.remove(tweetLoading);
			}
			else
			{
				tweetsSent = 0;
				FlxG.log.add("Finish Game");
			}
		}
		else
		{		
			if (tweetsSent <= 11)
			{
				tweetLoading = Tweets.endTweets[tweetsSent];
			}
			else
			{
				FlxG.switchState(new CreditsState());
			}
		}
		
		
	}
}
