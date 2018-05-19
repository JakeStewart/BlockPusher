package worlds.game_play 
{
	import game_manual.Manual;
	import worlds.WorldGame;
	import worlds.game_play.GamePlayManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GamePlayWorld extends WorldGame 
	{
		private var fileNameIndex:uint;
		private var fileNamePrefix:String;
		
		
		
		public function GamePlayWorld(fileNameIndex:uint = 1, fileNamePrefix:String = null) 
		{
			this.fileNameIndex = fileNameIndex;
			this.fileNamePrefix = fileNamePrefix;
			
			
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
			
			
			wpAdd(new GamePlayManager(fileNameIndex, fileNamePrefix));
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}