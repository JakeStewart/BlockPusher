package worlds.title_screen 
{
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	
	import game_manual.Manual;
	import worlds.WorldGame;
	import worlds.title_screen.falling_blocks.FallingBlockManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TitleScreenWorld extends WorldGame 
	{
		private var fromGame:Boolean;
		
		private var fallingBlocks:FallingBlockManager = new FallingBlockManager;
		
		public static var navDuration:Number = .5;
		public static var navEase:Function = Ease.quintOut;
		
		
		
		public function TitleScreenWorld(fromGame:Boolean = false) 
		{
			this.fromGame = fromGame;
			
			
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
			
			
			add(fallingBlocks);
			
			Data.load("SaveFilesInfo");
			
			// "File1State" is -1 or 1 if the game has been launched before
			if (Data.readInt("File1State") == 0) SaveFileData.onFirstLaunch();
			
			add(new TitleScreenManager(fromGame));
		}
		
		override public function update():void 
		{
			super.update();
			
			
			// testing();
		}
		// ----------------------------------------------------------------------------------
		
		
		private function testing():void
		{
			if (Input.pressed(Key.T)) test1();
		}
		
		private function test1():void
		{
			SaveFileData.changeData();
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}
	
}