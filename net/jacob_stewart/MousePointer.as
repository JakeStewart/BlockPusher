package net.jacob_stewart 
{
	import flash.ui.MouseCursor;
	
	import net.flashpunk.utils.Input;
	
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer extends EntityPlus 
	{
		private var types:Array;
		
		
		
		public function MousePointer(types:Array) 
		{
			this.types = types;
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = JS.TYPE_MousePointer;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			Input.mouseCursor = MouseCursor.AUTO;
			if (qualified()) Input.mouseCursor = MouseCursor.BUTTON;
		}
		
		public function qualified():Boolean
		{
			if (collideTypes(types, world.mouseX, world.mouseY)) return true;
			return false;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}