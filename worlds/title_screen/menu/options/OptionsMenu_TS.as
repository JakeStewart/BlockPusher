package worlds.title_screen.menu.options 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.Keys;
	
	import game_manual.Manual;
	import gui.options_menu.OptionsMenu;
	import gui.options_menu.OptionsMenuText;
	import worlds.title_screen.TitleScreenManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsMenu_TS extends OptionsMenu 
	{
		private var tsm:TitleScreenManager;
		private var resolutionText:OptionsMenuText;
		private var resolutions:Array = [[800, 600], [1024, 768]];
		
		
		
		public function OptionsMenu_TS() 
		{
			super();
		}
		
		override public function init():void 
		{
			resolutionText = new OptionsMenuText(4, null, "Resolution", panel.x + Game.OPTIONSPAD);
			resolutionText.collidable = false;
			// options.push(resolutionText);
			// textList.push(resolutionText);
			
			
			super.init();
			
			
			manualPage = Manual.PAGE_STORYMODE;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			tsm = world.getInstance(Game.NAME_TitleScreenManager) as TitleScreenManager;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			tsm = null;
		}
		// ------------------------------------------------------------------------
		
		
		override public function changeSetting(key:int):void 
		{
			super.changeSetting(key);
			
			if (options[selector.optionsIndex] == resolutionText)
			{
				if (changeResolution()) Sounds.tick1();
			}
		}
		
		private function changeResolution():Boolean
		{
			if (Input.pressed(Keys.RIGHT))
			{
				trace("changeResolution");
				
				FP.screen.scaleX = 1024 / 800;
				FP.screen.scaleY = 768 / 600;
				
				FP.stage.stageWidth = 1024;
				FP.stage.stageHeight = 768;
			}
			
			
			return false;
		}
		
		override public function exit():void 
		{
			if (state == STATE_HUB || state == STATE_TWEENING) tsm.currentSectionNum = tsm.TITLEMENU;
			
			
			super.exit();
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}