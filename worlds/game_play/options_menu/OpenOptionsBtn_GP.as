package worlds.game_play.options_menu 
{
	import gui.options_menu.OpenOptionsBtn;
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OpenOptionsBtn_GP extends OpenOptionsBtn 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		
		
		
		public function OpenOptionsBtn_GP(onClick:Function=null, text:String="OPTIONS", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			visibleStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE, gpm.im.MOVING, gpm.im.OPTIONS);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			room = world.getInstance(Game.NAME_Room) as Room;
			updateCollidable();
			updateVisible();
			updateAlpha();
			
			
			super.update();
		}
		
		private function updateCollidable():void
		{
			epCollidable(false);
			if (room)
			{
				if (gpm.im.state == gpm.im.IDLE) epCollidable(true);
			}
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (room)
			{
				if (visibleStates.indexOf(gpm.im.state) != -1) epVisible(true);
			}
		}
		
		private function updateAlpha():void
		{
			normalAlpha = ALPHA_INACTIVE;
			if (gpm.im.state == gpm.im.IDLE) normalAlpha = NORMALALPHA;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}