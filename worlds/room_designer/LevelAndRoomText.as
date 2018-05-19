package worlds.room_designer 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class LevelAndRoomText extends EntityGame 
	{
		private const COLOR_XML:uint = 0x85FF9C;
		private const COLOR_USER:uint = 0x85E1FF;
		
		private const STR_LEVEL:String = "Level ";
		private const STR_ROOM:String = "Room ";
		
		private const LRT_CENTEROFFSET:uint = 140;
		private const LRT_Y:Number = FP.height - Game.textAreaHeight + 16;
		
		private var levelText:TextPlus = new TextPlus(STR_LEVEL, 0, LRT_Y, { alignCenterX: FP.halfWidth - LRT_CENTEROFFSET, frontColor: COLOR_XML, backAlpha: .2 } );
		private var roomText:TextPlus = new TextPlus(STR_ROOM, 0, LRT_Y, { alignCenterX: FP.halfWidth + LRT_CENTEROFFSET, frontColor: COLOR_XML, backAlpha: .2 } );
		
		
		
		public function LevelAndRoomText() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([levelText, roomText]);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		public function changeText(levelNum:uint, roomNum:uint):void
		{
			levelText.changeText(STR_LEVEL + levelNum.toString());
			roomText.changeText(STR_ROOM + roomNum.toString());
		}
		
		public function changeColor():void
		{
			levelText.changeColor(COLOR_USER);
			roomText.changeColor(COLOR_USER);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}