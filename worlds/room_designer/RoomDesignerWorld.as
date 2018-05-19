package worlds.room_designer 
{
	import game_manual.Manual;
	import worlds.WorldGame;
	import worlds.room_designer.room_namer.RoomNamer;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomDesignerWorld extends WorldGame 
	{
		private var roomNamer:RoomNamer;
		private var fileName:String;
		private var xmlRoomNum:int;
		
		
		
		public function RoomDesignerWorld(fileName:String = null, xmlRoomNum:int = -1) 
		{
			this.fileName = fileName;
			this.xmlRoomNum = xmlRoomNum;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			manualPage = Manual.PAGE_ROOMDESIGNER;
		}
		
		override public function begin():void 
		{
			super.begin();
			
			
			wpAdd(new RoomDesigner(this, fileName, xmlRoomNum)) as RoomDesigner;
		}
		
		override public function end():void 
		{
			super.end();
			
			
			roomNamer = null;
		}
		// ----------------------------------------------------------------------------
		
		
		override public function toggleMute():void 
		{
			roomNamer = getInstance(Game.NAME_RoomNamer) as RoomNamer;
			if (!roomNamer) super.toggleMute();
		}
		// ----------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------
		
	}

}