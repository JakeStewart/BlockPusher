package gui.options_menu.audio_level_changer 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AudioLevelChanger extends EntityGame 
	{
		private var audioTypeIndex:uint; // 0 for SFX, 1 for Music
		private var getLevel:Function;
		private var setLevel:Function;
		
		public var bars:Array = new Array(10);
		private var level:uint;
		public var centerCoordY:Number;
		
		private const BTNPAD:uint = 24;
		private var leftBtn:AudioLevelChangerButton;
		public var rightBtn:AudioLevelChangerButton;
		public var arrowBtns:Array = new Array;
		
		
		
		public function AudioLevelChanger(audioTypeIndex:uint, centerCoordY:Number) 
		{
			this.audioTypeIndex = audioTypeIndex;
			this.centerCoordY = centerCoordY;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			if (audioTypeIndex == 0) // Sfx
			{
				setLevel = SaveFileData.setSFXLevel;
				getLevel = SaveFileData.getSFXLevel;
			}
			else if (audioTypeIndex == 1) // Music
			{
				setLevel = SaveFileData.setMusicLevel;
				getLevel = SaveFileData.getMusicLevel;
			}
			
			level = getLevel();
			
			var alphaState:Boolean = false; // true: sets alpha at AudioLevelBar.ALPHAON, false: sets alpha at AudioLevelBar.ALPHAOFF
			for (var i:uint = 0; i < bars.length; i++)
			{
				alphaState = false;
				if (level > i) alphaState = true;
				bars[i] = new AudioLevelBar(Game.audioBarsX + ((Game.AUDIOBARTHICK + Game.AUDIOBARPAD) * i), centerCoordY, alphaState);
			}
			
			
			createArrowBtns();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([bars, arrowBtns]);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			bars.length = 0;
			arrowBtns.length = 0;
		}
		
		private function activate():void
		{
			active = true;
		}
		// ------------------------------------------------------------------------------------------
		
		
		public function changeAudioLevel(val:int):Boolean
		{
			var bar:AudioLevelBar;
			level = getLevel();
			
			if ((val == Key.RIGHT || val == Key.D) && level < 10)
			{
				changeLevel(level, true, 1), rightBtn.changeState(1);
				Sounds.tick1();
				return true;
			}
			else if ((val == Key.LEFT || val == Key.A) && level > 0)
			{
				changeLevel(level - 1, false, -1), leftBtn.changeState(1);
				Sounds.tick1();
				return true;
			}
			
			
			return false;
			
			
			function changeLevel(barsIndex:uint, alphaState:Boolean, moreOrLess:int):void
			{
				bar = bars[barsIndex];
				bar.changeAlphaState(alphaState);
				
				setLevel(moreOrLess);
			}
		}
		
		public function onKeyCheck(key:int):void
		{
			if (Input.pressed(Keys.RIGHT)) rightBtn.changeState(1);
			else if (Input.pressed(Keys.LEFT)) leftBtn.changeState(1);
		}
		// ------------------------------------------------------------------------------------------
		
		
		private function createArrowBtns():void
		{
			leftBtn = new AudioLevelChangerButton(this, Key.LEFT, Game.audioBarsX - BTNPAD, centerCoordY);
			rightBtn = new AudioLevelChangerButton(this, Key.RIGHT, Game.audioBarsX + ((Game.AUDIOBARTHICK + Game.AUDIOBARPAD) * (bars.length - 1)) + BTNPAD, centerCoordY);
			arrowBtns.push(leftBtn, rightBtn);
		}
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
	}

}