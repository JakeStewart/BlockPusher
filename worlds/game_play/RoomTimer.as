package worlds.game_play 
{
	import net.jacob_stewart.other.DisplayTimer;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomTimer extends DisplayTimer
	{
		private var gpm:GamePlayManager;
		private var tickStates:Array = new Array;
		private var visibleStates:Array = new Array;
		
		
		
		public function RoomTimer() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomTimer;
			centerHor(textWidth, Game.TEXTCENXR);
			centerVer(textHeight, Game.BOTTOMAREAVERCEN);
		}
		
		override public function added():void 
		{
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			
			tickStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE, gpm.im.MOVING);
			visibleStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE, gpm.im.MOVING, gpm.im.OPTIONS);
			
			
			super.added();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateVisibility();
			updateTimer();
			
			
			super.update();
		}
		
		private function updateVisibility():void
		{
			visible = false;
			if (visibleStates.indexOf(gpm.im.state) != -1) visible = true;
		}
		
		private function updateTimer():void
		{
			if (tickStates.indexOf(gpm.im.state) != -1) timer.start();
			else timer.stop();
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
	}

}