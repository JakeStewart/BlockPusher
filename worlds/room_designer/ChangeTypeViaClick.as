package worlds.room_designer 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	
	import gui.KeyboardKeyButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ChangeTypeViaClick extends EntityGame 
	{
		private const XCENTER:Number = Math.round(FP.width * .15);
		private const XCENTER_PAD:Number = 24;
		private const YADJUST:uint = 4;
		private const YCENTER:Number = Math.round((Game.textAreaHeight * .5) - YADJUST);
		
		private var keyZ:KeyboardKeyButton = new KeyboardKeyButton("Z", Key.Z, clickKeyZ, -1, -1, XCENTER - XCENTER_PAD, YCENTER);
		private var keyX:KeyboardKeyButton = new KeyboardKeyButton("X", Key.X, clickKeyX, -1, -1, XCENTER + XCENTER_PAD, YCENTER);
		
		
		
		public function ChangeTypeViaClick() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			addList.push(keyZ, keyX);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList(addList);
		}
		// -----------------------------------------------------------------------------
		
		
		public function clickKeyZ():void
		{
			
		}
		
		public function clickKeyX():void
		{
			
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}