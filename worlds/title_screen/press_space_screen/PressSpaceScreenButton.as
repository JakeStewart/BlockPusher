package worlds.title_screen.press_space_screen 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.Button;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PressSpaceScreenButton extends Button 
	{
		private var host:PressSpaceScreen;
		
		
		
		public function PressSpaceScreenButton(host:PressSpaceScreen) 
		{
			this.host = host;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			epSetHitbox(FP.width, FP.height);
			collidable = false;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			host = null;
		}
		// -------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollidable();
		}
		
		private function updateCollidable():void
		{
			collidable = false;
			if (tween != null)
			{
				if (!tween.active) collidable = true;
			}
			else if (!host.fromFileSelect) collidable = true;
		}
		// -------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			host.tsm.clickButton();
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}