package worlds.room_designer 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TextButton_RD extends TextButton 
	{
		public var rd:RoomDesigner;
		
		private const ALPHA_NORMAL:Number = .7;
		private const ALPHA_INACTIVE:Number = .3;
		
		
		
		public function TextButton_RD(onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			deactivate();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		
		override public function interactivity():void 
		{
			if (collidable && rd.im.state == rd.im.HUB) super.interactivity();
		}
		// -----------------------------------------------------------------------------
		
		
		public function activationCheck():void
		{
			deactivate();
		}
		
		public function activate():void
		{
			collidable = true;
			normalAlpha = ALPHA_NORMAL;
		}
		
		public function deactivate():void
		{
			collidable = false;
			normalAlpha = ALPHA_INACTIVE;
			changeState(NORMAL);
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}