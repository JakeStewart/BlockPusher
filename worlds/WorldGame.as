package worlds 
{
	import flash.system.fscommand;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.WorldPlus;
	import net.jacob_stewart.text.TextPlus;
	import net.jacob_stewart.graphics.OverlayFadeIn;
	
	import worlds.title_screen.TitleScreenWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class WorldGame extends WorldPlus 
	{
		public var manualPage:uint = 0;
		private const STR_DEV:String = "developer";
		private const SIZE_DEV:uint = Text.size;
		
		
		
		public function WorldGame() 
		{
			super();
		}
		
		override public function begin():void 
		{
			super.begin();
			
			
			if (Game.developer) add(new TextPlus(STR_DEV, FP.width - JS.getTextWidth(SIZE_DEV, STR_DEV), FP.height - JS.getTextHeight(SIZE_DEV, STR_DEV), { frontColor: JS.RED } ));
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			if (Input.pressed(Key.M)) toggleMute();
			toggleConsole();
		}
		
		/**
		 * Toggles sound when 'M' key is pressed
		 */
		public function toggleMute():void
		{
			SaveFileData.toggleMute();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		/**
		 * Packaged sequence for navigating to the TitleMenu
		 * Plays the OverlayFadeIn before changing thw world to TitleScreenWorld
		 * @param	onComplete		Optional completion callback
		 */
		public function navTitleMenu(onComplete:Function = null):void
		{
			if (!getInstance(JS.NAME_OverlayFadeIn)) add(new OverlayFadeIn(Game.OVERLAYDURATION, onComplete, Game.SCREENCOLOR));
			else FP.world = new TitleScreenWorld(true);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		private function toggleConsole():void
		{
			if (Input.pressed(Key.F12))
			{
				if (FP.console.visible) FP.console.visible = false;
				else FP.console.visible = true;
			}
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}