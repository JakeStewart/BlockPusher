package worlds.room_designer.room_namer 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.ConfirmOrCancelText;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomNamer extends TextPlus 
	{
		private var rd:RoomDesigner;
		private var roomNamerBtn:RoomNamerBtn;
		
		private var clearOnFirstPressed:Boolean = true;
		
		private const MAXNAMEWIDTH:Number = Game.ROOMNAMEMAXTEXTWIDTH;
		private var backupSize:Number;
		private var backupRoomName:String;
		
		// Various non-typing key values
		private var unqualifiedKeys:Array = [13, 15, 17, 16, 20, 46, 35, 27, 36, 45, 9, 34, 33, 219, 221];
		
		
		private const BASELAYER:int = -7;
		private const TEXTLAYER:int = BASELAYER - 1;
		
		private var screenTint:ScreenTint = new ScreenTint(BASELAYER);
		private var infoText1:TextPlus = new TextPlus("Name your room!", 0, 154, { alignCenterX: FP.halfWidth, frontAlpha: .7, includeBack: false }, TEXTLAYER);
		private var infoText2:ConfirmOrCancelText = new ConfirmOrCancelText(TEXTLAYER);
		private var guiList:Array = [screenTint, infoText1, infoText2];
		
		
		
		public function RoomNamer(roomNamerBtn:RoomNamerBtn, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=-5) 
		{
			this.roomNamerBtn = roomNamerBtn;
			
			
			super(text, x, 220 - (JS.getTextHeight(size) * .5), options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			centerHor(textWidth, FP.halfWidth);
			
			name = Game.NAME_RoomNamer;
			layer = TEXTLAYER;
			
			backupRoomName = text;
			backupSize = size;
			
			while (textWidth >= MAXNAMEWIDTH && size > Game.MINTEXTSIZERN) changeSize(size - 1);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.im.state = rd.im.NAMER;
			
			clearOnFirstPressed = true;
			
			epAddList(guiList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd.im.state = rd.im.HUB;
			
			rd = null;
			roomNamerBtn = null;
			guiList.length = 0;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		public function isQualifiedKey(key:int):Boolean
		{
			if (key > 36 && key < 41) return false; // Directional keys
			if (key > 111 && key < 127) return false; // Function keys
			if (unqualifiedKeys.indexOf(key) != -1) return false; // Various non-typing keys
			
			return true;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		public function updateName():void
		{
			if (clearOnFirstPressed)
			{
				clearOnFirstPressed = false;
				changeText("");
			}
			// if (text == "Untitled") changeText("");
			
			
			if (Input.lastKey == Key.BACKSPACE)
			{
				if (text.length > 0) changeText(text.slice(0, text.length - 1));
				while (textWidth < MAXNAMEWIDTH && size < Game.MAXTEXTSIZERN) size++, changeSize(size);
				centerHor(textWidth);
			}
			else if (canAddMore(size))
			{
				var charEntered:String = Input.keyString.charAt(Input.keyString.length - 1);
				var size2:Number = size;
				
				
				if (JS.getTextWidth(size, text + charEntered) >= MAXNAMEWIDTH && size > Game.MINTEXTSIZERN)
				{
					while (JS.getTextWidth(size2, "W") >= MAXNAMEWIDTH - JS.getTextWidth(size2, text + charEntered) && size2 > Game.MINTEXTSIZERN) size2--;
				}
				
				
				if (canAddMore(size2, charEntered))
				{
					changeSize(size2);
					changeText(text + charEntered);
				}
			}
		}
		
		private function canAddMore(size:Number, char:String = ""):Boolean
		{
			if (
			JS.getTextWidth(size, text + char) < MAXNAMEWIDTH // If the textWidth of the current (or current + the character typed) room name is less than the maximum room name width
			&& size > Game.MINTEXTSIZERN // If the current or next size of the text is greater than the minimum text size
			) return true;
			
			
			return false;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		public function finishNaming():void
		{
			Sounds.select1();
			
			removeSpaces();
			
			rd.roomName = text;
			rd.updateRoomData();
			
			roomNamerBtn.roomNamerTextSize = size;
			roomNamerBtn.changeText(text);
			
			world.remove(this);
		}
		
		public function cancelNaming():void
		{
			Sounds.knock1();
			
			changeSize(backupSize);
			changeText(backupRoomName);
			
			world.remove(this);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		private function removeSpaces():void
		{
			while (text.charAt(text.length - 1) == " ") changeText(text.slice(0, text.length - 1));
		}
		// ----------------------------------------------------------------------------------------------
		
		
		override public function centerHor(width:uint, alignValX:Number = NaN):Number 
		{
			super.centerHor(width, alignValX);
			roomNamerBtn.centerHor(roomNamerBtn.textWidth, alignValX);
			return x;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
	}

}