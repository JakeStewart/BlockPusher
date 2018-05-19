package worlds.game_play 
{
	import flash.utils.Timer;
	
	import net.flashpunk.Entity;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomTimer_Old1 extends Entity
	{
		private var gpm:GamePlayManager;
		
		public var timer:Timer = new Timer(1000);
		private var tickStates:Array = new Array;
		
		private var timeText:TextPlus = new TextPlus("00:00", 0, 0, { alignCenterX: Game.TEXTCENXR, alignCenterY: Game.BOTTOMAREAVERCEN } );
		private var visibleStates:Array = new Array;
		
		
		
		public function RoomTimer_Old1() 
		{
			init();
		}
		
		public function init():void
		{
			name = Game.NAME_RoomTimer;
		}
		
		override public function added():void 
		{
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			
			tickStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE, gpm.im.MOVING);
			visibleStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE, gpm.im.MOVING, gpm.im.OPTIONS);
			
			timer.start();
			world.add(timeText);
		}
		
		override public function removed():void 
		{
			timer.stop();
			world.remove(timeText);
			
			gpm = null;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateVisibility();
			updateTimer();
			updateText();
		}
		
		private function updateVisibility():void
		{
			timeText.epVisible(false);
			if (visibleStates.indexOf(gpm.im.state) != -1) timeText.epVisible(true);
		}
		
		private function updateTimer():void
		{
			if (tickStates.indexOf(gpm.im.state) != -1) timer.start();
			else timer.stop();
		}
		
		private function updateText():void
		{
			timeText.changeText(getTimerStr(timer.currentCount));
		}
		// ------------------------------------------------------------------------------------------------
		
		
		public static function getTimerStr(totalSecs:int):String
		{
			var secs:uint = totalSecs % 60;
			var mins:uint = totalSecs / 60;
			
			var textStr:String;
			textStr = (mins < 10) ? "0" + mins.toString() + ":" : mins.toString() + ":";
			textStr += (secs < 10) ? "0" + secs.toString() : secs.toString();
			
			
			return textStr;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
	}

}