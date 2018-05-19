package  
{
	import flash.ui.MouseCursor;
	
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.MousePointer;
	
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * Mainly manages the mouse pointer icon between arrow and hand
	 */
	public class MousePointerGame extends MousePointer 
	{
		private var mp:MousePointerGame;
		private var mpGame:Array = new Array;
		
		
		
		public function MousePointerGame(types:Array) 
		{
			super(types);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = JS.TYPE_MousePointer;
			name = Game.NAME_MousePointer;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			mpGame.length = 0;
			world.getType(JS.TYPE_MousePointer, mpGame);
			
			for (var i:uint = 0; i < mpGame.length; i++)
			{
				mp = mpGame[i];
				if (mp != this) mp.active = false;
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			for (var i:uint = 0; i < mpGame.length; i++) mp = mpGame[i], mp.active = true;
			mp = null;
			mpGame.length = 0;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function epActive(active:Boolean, includeThis:Boolean = true, exclude:Array = null):Array 
		{
			if (!active && includeThis) Input.mouseCursor = MouseCursor.AUTO;
			
			
			return super.epActive(active, includeThis, exclude);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}