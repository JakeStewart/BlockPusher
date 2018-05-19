package worlds.room_designer.new_room 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class NewRoomButton extends TextButton 
	{
		private var newRoom:NewRoom;
		public var btnsIndex:uint;
		private const ALPHA_NORMAL:Number = .4;
		
		
		
		public function NewRoomButton(btnsIndex:uint, onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.btnsIndex = btnsIndex;
			
			
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = NewRoom.TEXTLAYER;
			changeSize(24);
			changeBackOffset(2);
			normalAlpha = ALPHA_NORMAL;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			newRoom = world.getInstance(Game.NAME_NewRoom) as NewRoom;
			
			// If the mouse pointer is already over a btn when the btns are added,
			// we don't want that btn to be highlighted, we want it to default to 'Yes' option
			if (collidePoint(x, y, world.mouseX, world.mouseY)) newRoom.mouseIndex = btnsIndex;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			newRoom = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (newRoom.btnsIndex == btnsIndex) changeState(HOVER);
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (newRoom.mouseIndex == newRoom.btnsIndex) super.interactivity();
		}
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
	}

}