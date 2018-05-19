package worlds.room_select 
{
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ScrollRoomButtonX10 extends ScrollRoomButton 
	{
		private const PAD:uint = 8;
		private var x10:TextPlus = new TextPlus("x10");
		
		
		
		public function ScrollRoomButtonX10(arrowNum:uint, x:Number=0, y:Number=0) 
		{
			super(arrowNum, x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			if (arrowNum == 2) x10.setXY(x - x10.textWidth - PAD, (y + (img.height * .5)) - x10.textHalfHeight);
			else x10.setXY(x + img.width + PAD, (y + (img.height * .5)) - x10.textHalfHeight);
			
			x10.changeAlpha(.7, 0);
			
			var _originX:int = 0;
			if (arrowNum == 2) _originX = x - x10.x;
			epSetHitbox(img.width + x10.textWidth + PAD, img.height, _originX);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAdd(x10);
		}
		// ----------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------
		
	}

}