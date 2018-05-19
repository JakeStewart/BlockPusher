package 
{
	import flash.display.Stage;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import net.jacob_stewart.Keys;
	
	import worlds.title_screen.TitleScreenWorld;
	
	// This is the place code needs to be changed to 
	// set the desired resolution; 800 x 600 or 1600 x 1200
	// [SWF(width = "1600", height = "1200")]
	[SWF(width = "800", height = "600")]
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(Game.RES_WIDTH_DEF, Game.RES_HEIGHT_DEF);
		}
		
		override public function init():void
		{
			super.init();
			
			
			FP.screen.color = Game.SCREENCOLOR;
			
			Keys.defineKeys();
			
			// scale the size of everything
			if (stage.stageWidth == Game.RES_WIDTH_ALT) FP.screen.scale = Game.RES_WIDTH_ALT / FP.width; // 1600 / 800 = 2
			
			
			FP.world = new TitleScreenWorld;
			
			
			FP.console.enable();
			FP.console.visible = false;
		}
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
	}
	
}