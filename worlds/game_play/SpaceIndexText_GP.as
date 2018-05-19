package worlds.game_play 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import gui.SpaceIndexText;
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceIndexText_GP extends SpaceIndexText 
	{
		private var on:Boolean;
		
		
		
		public function SpaceIndexText_GP(host:EntityPlus, roomIndex:int=-1) 
		{
			super(host, roomIndex);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			centerOnPoint(textWidth, textHeight, host.x + Game.HALFSPACESIZE, host.y + Game.HALFSPACESIZE);
		}
		// ------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			toggleOn();
			updateVisible();
		}
		
		private function toggleOn():void
		{
			if (Input.pressed(Key.F4) && Game.developer)
			{
				if (on) on = false;
				else on = true;
			}
		}
		
		private function updateVisible():void
		{
			visible = false;
			if (on) visible = true;
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}