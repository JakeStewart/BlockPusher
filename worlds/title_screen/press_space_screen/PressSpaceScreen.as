package worlds.title_screen.press_space_screen 
{
	import net.flashpunk.FP;
	
	import gui.AlphaPulseText;
	import worlds.title_screen.TitleScreenSection;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PressSpaceScreen extends TitleScreenSection 
	{
		public var fromFileSelect:Boolean;
		private var btn:PressSpaceScreenButton;
		
		private var pressSpaceText:AlphaPulseText = new AlphaPulseText("PRESS SPACE", 0, 0, { size: 32, alignCenterX: FP.halfWidth, alignCenterY: Math.round(Game.TSTAH + ((FP.height - Game.TSTAH) * .5)) } );
		
		
		
		public function PressSpaceScreen(fromFileSelect:Boolean = false) 
		{
			this.fromFileSelect = fromFileSelect;
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_PressSpaceScreen;
			
			btn = new PressSpaceScreenButton(this);
			objectsToTween.push(btn);
			objectsToTween.push(pressSpaceText);
			
			if (fromFileSelect)
			{
				x = -FP.width;
				pressSpaceText.centerHor(pressSpaceText.textWidth, -FP.halfWidth);
			}
			
			pressSpaceText.name = "pressSpaceText";
		}
		
		override public function added():void 
		{
			super.added();
			
			
			sectionNum = tsm.SPACESCREEN;
			epAdd(btn);
			epAdd(pressSpaceText);
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}