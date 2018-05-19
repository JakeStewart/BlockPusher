package worlds.room_designer.options_menu 
{
	import gui.options_menu.OpenOptionsBtn;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OpenOptionsBtn_RD extends OpenOptionsBtn 
	{
		private var rd:RoomDesigner;
		
		
		
		public function OpenOptionsBtn_RD(onClick:Function=null, text:String="OPTIONS", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidable();
			updateVisible();
			updateAlpha();
			
			
			super.update();
		}
		
		private function updateCollidable():void
		{
			collidable = false;
			if (rd.im.state == rd.im.HUB) collidable = true;
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		
		private function updateAlpha():void
		{
			normalAlpha = NORMALALPHA;
			if (rd.im.state == rd.im.OPTIONS) normalAlpha = ALPHA_INACTIVE;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}