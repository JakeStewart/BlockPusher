package worlds.game_play 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.other.RunFunctionButton;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.AlphaPulseText;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomFailedScreen extends EntityGame 
	{
		private var gpm:GamePlayManager;
		
		private var screenTint:ScreenTint = new ScreenTint( -4, 0);
		public var pressEnterText:AlphaPulseText = new AlphaPulseText("PRESS SPACE", 0, FP.height - (FP.height / 6), { size: 40, alignCenterX: FP.halfWidth } );
		
		
		private const ROOMNAMEY:uint = FP.halfHeight - 48;
		private const GROUPPAD:uint = 16; // Vertical space height between a group of text
		private const INFOSIZE:uint = 24;
		private const ROOMNAMESIZE:uint = 32;
		
		private var roomNameText:TextPlus;
		private var roomNameStr:String;
		
		private var levelText:TextPlus;
		private var levelNum:uint;
		
		private var roomText:TextPlus;
		private var levelRoomNum:uint;
		
		
		public static const NOBLOCKS:String = "All blocks lost!";
		public static const OUTOFTIME:String = "Why you take too long?!";
		public static const TOOMANYMOVES:String = "Too much pushing!";
		private var reason:String;
		
		private const ROOMFAILEDSTR:String = "ROOM FAILED";
		private const ROOMFAILEDSIZE:uint = 48;
		private const ROOMFAILEDTEXT_HOMECOORD_Y:Number = 40;
		private var roomFailedText:TextPlus;
		private var reasonFailedText:TextPlus;
		
		private var fileNameIndexRetry:uint;
		
		private var guiList:Array = new Array;
		private var tweens:Array = new Array;
		
		
		
		public function RoomFailedScreen(reason:String, roomNameStr:String, levelNum:uint, levelRoomNum:uint, fileNameIndexRetry:uint) 
		{
			this.reason = reason;
			this.roomNameStr = roomNameStr;
			this.levelNum = levelNum;
			this.levelRoomNum = levelRoomNum;
			this.fileNameIndexRetry = fileNameIndexRetry;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomFailedScreen;
			
			setupText();
			guiList.push(screenTint, roomNameText, levelText, roomText, roomFailedText, reasonFailedText);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			Sounds.warning1();
			Sounds.knock1();
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			gpm.setBlockPendingMove(null);
			gpm.im.state = gpm.im.ROOMFAILED;
			gpm.roomGUIToggle(gpm.gameText.guiList, false);
			
			epAddList(guiList);
			setTweens();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm.im.state = gpm.im.IDLE;
			gpm.newPuzzle();
			
			gpm = null;
			guiList.length = 0;
			tweens.length = 0;
		}
		// ------------------------------------------------------------------------
		
		
		private function setupText():void
		{
			roomFailedText = new TextPlus(ROOMFAILEDSTR, 0, -JS.getTextHeight(ROOMFAILEDSIZE, ROOMFAILEDSTR), { size: ROOMFAILEDSIZE, alignCenterX: FP.halfWidth } ); // start above screen, centered horizontally
			reasonFailedText = new TextPlus(reason, FP.width, ROOMFAILEDTEXT_HOMECOORD_Y + roomFailedText.textHeight + GROUPPAD, { size: 32 } ); // start right of screen
			roomNameText = new TextPlus(roomNameStr, 0, FP.height, { size: ROOMNAMESIZE, alignCenterX: FP.halfWidth } ); // start below screen, centered horizontally
			levelText = new TextPlus("Level " + levelNum.toString(), -JS.getTextWidth(INFOSIZE, "Level " + levelNum.toString()), ROOMNAMEY + roomNameText.textHeight + 40, { size: INFOSIZE } ); // start left of screen
			roomText = new TextPlus("Room " + levelRoomNum.toString(), FP.width, levelText.y + levelText.textHeight + GROUPPAD, { size: INFOSIZE } ); // start right of screen
			
			
			roomFailedText.setHomeXY(roomFailedText.x, ROOMFAILEDTEXT_HOMECOORD_Y);
			reasonFailedText.setHomeXY(FP.halfWidth - (reasonFailedText.textWidth * .5), reasonFailedText.y);
			roomNameText.setHomeXY(roomNameText.x, ROOMNAMEY);
			levelText.homeCoords.x = FP.halfWidth - levelText.textHalfWidth, levelText.homeCoords.y = levelText.y;
			roomText.homeCoords.x = FP.halfWidth - roomText.textHalfWidth, roomText.homeCoords.y = roomText.y;
		}
		
		private function setTweens():void
		{
			tweens.push(FP.tween(screenTint.image, { alpha: .6 }, .5, { tweener: screenTint } ));
			tweenText(roomFailedText, .2, .4);
			tweenText(reasonFailedText, .3, .4);
			tweenText(roomNameText, .3, .5); // 100
			tweenText(levelText, .2, .7);
			tweenText(roomText, .2, .7);
			
			FP.alarm(.8, addPressSpaceText);
		}
		
		private function addPressSpaceText():void
		{
			epAdd(pressEnterText);
			epAdd(new RunFunctionButton(retryRoom));
		}
		// ------------------------------------------------------------------------
		
		
		private function tweenText(text:TextPlus, duration:Number, delay:Number = 0):void
		{
			tweens.push(FP.tween(text, { x: text.homeCoords.x, y: text.homeCoords.y }, duration, { tweener: text, delay: delay } ));
		}
		// ------------------------------------------------------------------------
		
		
		public function retryRoom():void
		{
			Sounds.select1();
			gpm.fileNameIndex = fileNameIndexRetry;
			removeThis();
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}