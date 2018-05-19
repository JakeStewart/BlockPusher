package gui.options_menu.audio_level_changer 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AudioLevelBar extends EntityPlus 
	{
		private var image:Image = new Image(Images.AUDIO_LEVEL_BAR);
		private const COLOR:uint = 0xFFFFFF;
		
		private const ALPHA_ON:Number = 1;
		private const ALPHA_OFF:Number = .3;
		private const ALPHA_MUTE:Number = .6;
		private var alpha:Number = ALPHA_ON;
		
		
		
		public function AudioLevelBar(x:Number=0, centerCoordY:Number = 0, alphaState:Boolean = false) 
		{
			y = centerCoordY - (Game.AUDIOBARHEIGHT * .5);
			changeAlphaState(alphaState);
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.OPTIONSBASELAYER - 2;
			homeCoords.x = x, homeCoords.y = y;
			graphic = image;
		}
		// ------------------------------------------------------------------------------------------
		
		
		public function changeAlphaState(state:Boolean):void
		{
			if (state) image.alpha = ALPHA_ON;
			else if (!state) image.alpha = ALPHA_OFF;
		}
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
	}

}