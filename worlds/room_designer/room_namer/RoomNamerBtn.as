package worlds.room_designer.room_namer 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.text.TextButton;
	
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomNamerBtn extends TextButton 
	{
		private var rd:RoomDesigner;
		public var roomNamerTextSize:Number = Game.MAXTEXTSIZERN;
		
		
		
		public function RoomNamerBtn(onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=46, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomNamerBtn;
			changeBackOffset(2);
			centerHor(textWidth);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS, rd.im.NAMER, rd.im.NEWROOM, rd.im.ADDROOM);
			changeText(rd.roomName);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			// testing();
			
			updateCollidable();
			updateVisible();
		}
		
		private function updateCollidable():void
		{
			collidable = false;
			if (rd.im.state == rd.im.HUB) collidable = true;
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		override public function click():void 
		{
			super.click();
			
			
			collidable = false;
			world.add(new RoomNamer(this, rd.roomName, 0, 0, { size: roomNamerTextSize } ));
		}
		
		override public function changeAlpha(frontAlpha:Number=NaN, backAlpha:Number=.2):void
		{
			super.changeAlpha(frontAlpha, backAlpha);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		private function testing():void
		{
			if (Input.pressed(Key.F)) trace("RoomNamerBtn type:", type, "active:", active);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
	}

}