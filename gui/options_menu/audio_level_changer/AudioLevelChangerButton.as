package gui.options_menu.audio_level_changer 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Button;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AudioLevelChangerButton extends Button 
	{
		public var image:Image;
		private var host:AudioLevelChanger;
		private var inputVal:int; // 37 (Key.LEFT) for left (decrease audio), 39 (Key.RIGHT) for right (increase audio)
		private var baseX:Number;
		private var centerCoordY:Number;
		
		private var alphaStateVals:Array = [.6, 1, .6];
		
		
		
		public function AudioLevelChangerButton(host:AudioLevelChanger, inputVal:int, baseX:Number, centerCoordY:Number) 
		{
			this.host = host;
			this.inputVal = inputVal;
			this.baseX = baseX;
			this.centerCoordY = centerCoordY;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.OPTIONSBASELAYER - 1;
			
			image = new Image(Images.audioLevelArrows[inputVal - Key.LEFT]);
			graphic = image;
			
			if (inputVal == Key.LEFT) x = baseX - image.width;
			else x = baseX;
			y = centerCoordY - (image.height * .5);
			setHomeXY(x, y);
			
			epSetHitbox(image.width, image.height);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// ------------------------------------------------------------------------------
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			host.changeAudioLevel(inputVal);
		}
		
		override public function changeState(state:int = -1):void 
		{
			if (state == -1) state = this.state;
			image.alpha = alphaStateVals[state];
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}