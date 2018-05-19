package worlds.room_select 
{
	import net.flashpunk.FP;
	
	import game_manual.Manual;
	import worlds.WorldGame;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomSelectWorld extends WorldGame 
	{
		private static const TEXTPADY:uint = 4; // The padding between the top or bottom of the text and what it's against
		public static const TOPAREAFLOOR:uint = Game.textAreaHeight - TEXTPADY;
		
		
		
		public function RoomSelectWorld() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			manualPage = Manual.PAGE_ROOMSELECT;
		}
		
		override public function begin():void 
		{
			super.begin();
			
			
			wpAdd(new RoomSelect);
		}
		// --------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------
		
	}

}