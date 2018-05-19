package worlds.room_designer 
{
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomDesignerTitle extends TextPlus 
	{
		private var rd:RoomDesigner;
		private var qualifiedStates:Array = new Array;
		
		
		
		public function RoomDesignerTitle(text:String="ROOM DESIGNER", x:Number=0, y:Number=14, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeSize(26);
			changeBackOffset(2);
			changeAlpha(NaN, .5);
			centerHor(textWidth);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			qualifiedStates.push(rd.im.HUB, rd.im.OPTIONS, rd.im.NAMER, rd.im.NEWROOM, rd.im.ADDROOM, rd.im.MEDAL);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (qualifiedStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}