package worlds.room_select 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class LevelAndRoomText extends TextPlus 
	{
		private const XPAD:Number = FP.width * (1 / 5); // Distance between the side edge of the game and the x center of the text
		private const TEXTY:Number = RoomSelectWorld.TOPAREAFLOOR - JS.getTextHeight(JS.TEXTSIZE_DEFAULT) - 2;
		
		
		
		public function LevelAndRoomText(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			if (text == "Level 1") centerHor(textWidth, XPAD);
			else if (text == "Room 1") centerHor(textWidth, FP.width - XPAD);
			setXY(x, TEXTY);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}