package worlds.title_screen 
{
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TitleScreenSection extends EntityGame 
	{
		public var tsm:TitleScreenManager;
		public var sectionNum:uint;
		public var objectsToTween:Array = [this]; // Will contain all the objects for this TitleScreenSection that need to be tweened
		
		
		
		public function TitleScreenSection() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_TitleScreenSection;
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
			objectsToTween.length = 0;
		}
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
		
	}

}