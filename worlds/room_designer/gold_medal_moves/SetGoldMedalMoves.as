package worlds.room_designer.gold_medal_moves 
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
	public class SetGoldMedalMoves extends TextPlus 
	{
		private var rd:RoomDesigner;
		
		private const BASELAYER:int = -7;
		private const TEXTLAYER:int = BASELAYER - 1;
		private var backupMoves:uint = 1;
		private var firstKeyPress:Boolean = true;
		
		private var screenTint:ScreenTint = new ScreenTint(BASELAYER);
		private var infoText1:TextPlus = new TextPlus("Set the number of qualifying moves for a gold medal.", 0, 154, { alignCenterX: FP.halfWidth, frontAlpha: .7, includeBack: false }, TEXTLAYER);
		private var infoText2:ConfirmOrCancelText = new ConfirmOrCancelText(TEXTLAYER);
		private var guiList:Array = [screenTint, infoText1, infoText2];
		
		
		
		public function SetGoldMedalMoves(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=-5) 
		{
			super(text, x, 220 - (JS.getTextHeight(size) * .5), options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_SetGoldMedalMoves;
			layer = TEXTLAYER;
			changeSize(32);
			centerHor(textWidth, FP.halfWidth);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.im.state = rd.im.MEDAL;
			
			backupMoves = rd.movesQualGold;
			changeText(rd.movesQualGold.toString());
			
			epAddList(guiList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd.im.state = rd.im.HUB;
			
			rd = null;
			guiList.length = 0;
		}
		// ----------------------------------------------------------------------------------------------
		
		
		public function updateMoves(key:int):void
		{
			var diff:int;
			
			if (key >= 48 && key <= 57) diff = 48;
			if (key >= 96 && key <= 105) diff = 96;
			
			
			if (Input.pressed(Key.BACKSPACE))
			{
				if (firstKeyPress || rd.movesQualGold < 10) rd.movesQualGold = -1;
				else rd.movesQualGold /= 10;
			}
			else if (firstKeyPress || rd.movesQualGold < 1 || rd.movesQualGold > 9)
			{
				rd.movesQualGold = key - diff;
			}
			else
			{
				rd.movesQualGold *= 10;
				if (key - diff > 0) rd.movesQualGold += (key - diff);
			}
			
			firstKeyPress = false;
			
			
			
			if (rd.movesQualGold == -1) changeText("");
			else changeText(rd.movesQualGold.toString());
			
			centerHor(textWidth);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		public function confirmChange():void
		{
			if (rd.movesQualGold < 1) rd.movesQualGold = 1;
			rd.goldMedalMovesBtn.movesText.changeText(rd.movesQualGold.toString(), false);
			
			rd.updateRoomData();
			
			world.remove(this);
		}
		
		public function cancelChange():void
		{
			rd.movesQualGold = backupMoves;
			rd.goldMedalMovesBtn.movesText.changeText(rd.movesQualGold.toString(), false);
			
			world.remove(this);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
	}

}