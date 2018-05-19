package worlds.room_tester 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.text.TextPlus;
	
	import game_manual.Manual;
	import worlds.WorldGame;
	import worlds.game_play.GamePlayManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomTesterWorld extends WorldGame 
	{
		private var title:TextPlus = new TextPlus("ROOM TESTER", 0, 14, { size: 24, alignCenterX: FP.halfWidth } );
		
		
		
		public function RoomTesterWorld() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			manualPage = Manual.PAGE_STORYMODE;
		}
		
		override public function begin():void 
		{
			super.begin();
			
			
			wpAdd(new GamePlayManager(0));
			wpAdd(title);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}