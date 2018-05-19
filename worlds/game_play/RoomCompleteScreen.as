package worlds.game_play 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.other.DisplayTimer;
	import net.jacob_stewart.other.RunFunctionButton;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.AlphaPulseText;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomCompleteScreen extends EntityGame 
	{
		private var gpm:GamePlayManager;
		
		
		private const LEVELANDROOM_Y:Number = Math.round(FP.height * (26 / 600));
		private const LEVELANDROOM_CENTERX:Number = Math.round(FP.width * (276 / 800));
		private const ROOMNAME_Y:uint = Math.round(FP.height * (64 / 600));
		private const STATS_Y:uint = Math.round(FP.height * (156 / 600));
		private const STATS_ALIGN_R:Number = Math.round(FP.width * (300 / 800));
		private const STATS_ALIGN_L:Number = Math.round(FP.width * (500 / 800));
		private const MEMBER_PAD:uint = Math.round(FP.height * (14 / 600));
		private const GROUP_PAD:uint = Math.round(FP.height * (40 / 600));; // Vertical space height between a group of text
		private const ROOMNAMESIZE:uint = 32;
		private const STATSIZE:uint = 24;
		
		private var levelText:TextPlus;
		private var levelNum:uint;
		
		private var roomText:TextPlus;
		private var levelRoomNum:uint;
		
		private var roomNameText:TextPlus;
		private var roomNameStr:String;
		
		
		
		
		private var movesMadeText:TextPlus;
		private const STR_MOVESMADE:String = "Moves Made";
		private var movesMadeNumText:TextPlus;
		private var movesMade:uint;
		
		private var movesBestText:TextPlus;
		private const STR_MOVESBEST:String = "Moves Best";
		private var movesBestNumText:TextPlus;
		private var movesBest:int;
		
		
		private var clearTimeText:TextPlus;
		private const STR_CLEARTIME:String = "Clear Time";
		private var clearTimeNumText:TextPlus;
		private var clearTime:int;
		
		private var bestTimeText:TextPlus;
		private const STR_BESTTIME:String = "Best Time";
		private var bestTimeNumText:TextPlus;
		private var bestTime:int;
		
		
		private var orbsText:TextPlus;
		private const STR_ORBS:String = "Orbs";
		private var orbsStatText:TextPlus;
		private var orbsCollected:uint;
		private var orbsPossible:uint;
		
		
		private var medalText:TextPlus;
		private const STR_MEDAL:String = "Medal";
		private var medal:EntityPlus;
		private var movesQualGold:uint;
		
		
		
		private var screenTint:ScreenTint = new ScreenTint(Game.SCREENTINT_LAYER, 0);
		public var pressEnterText:AlphaPulseText = new AlphaPulseText("PRESS SPACE", 0, Math.round(FP.height * (526 / 600)), { size: 40, alignCenterX: FP.halfWidth } );
		
		private var fileNameIndexRetry:uint;
		private const STR_RETRY:String = "RETRY";
		private var retryX:Number = Math.round((FP.width * .95) - JS.getTextWidth(24, STR_RETRY));
		private var retryY:Number = Math.round((FP.height * .95) - JS.getTextHeight(24, STR_RETRY));
		private var retryBtn:TextButton = new TextButton(retryRoom, STR_RETRY, retryX, retryY, { size: 24, frontColor: 0xFF6161, backOffset: 2 } );
		
		private var guiList:Array = new Array;
		private var tweens:Array = new Array;
		private var saveDataRoomNum:uint;
		
		
		
		public function RoomCompleteScreen(roomNameStr:String, levelNum:uint, levelRoomNum:uint, movesMade:uint, clearTime:int, orbsCollected:uint, orbsPossible:uint, movesQualGold:uint, fileNameIndexRetry:uint) 
		{
			this.roomNameStr = roomNameStr;
			this.levelNum = levelNum;
			this.levelRoomNum = levelRoomNum;
			this.movesMade = movesMade;
			this.clearTime = clearTime;
			this.orbsCollected = orbsCollected;
			this.orbsPossible = orbsPossible;
			this.movesQualGold = movesQualGold;
			this.fileNameIndexRetry = fileNameIndexRetry;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomCompleteScreen;
			
			
			saveDataRoomNum = ((levelNum - 1) * 10) + levelRoomNum;
			
			movesBest = SaveFileData.getMovesBest(saveDataRoomNum);
			if (movesBest == -1 || movesMade < movesBest) movesBest = movesMade;
			
			bestTime = SaveFileData.getBestTime(saveDataRoomNum);
			if (bestTime == 0 || clearTime < bestTime) bestTime = clearTime;
			
			setup();
			guiList = [screenTint, roomNameText, levelText, roomText, movesMadeText, movesMadeNumText, movesBestText, movesBestNumText, clearTimeText, clearTimeNumText, bestTimeText, bestTimeNumText, orbsText, orbsStatText, medalText, medal];
		}
		
		override public function added():void 
		{
			super.added();
			
			
			Sounds.newSaveFile1();
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			gpm.im.state = gpm.im.ROOMCOMPLETE;
			gpm.roomGUIToggle(gpm.gameText.guiList, false);
			
			
			if (gpm.fileNamePrefix == RoomData.XMLFILEPREFIX) SaveFileData.saveRoomCompleteData(saveDataRoomNum, movesMade, clearTime, orbsCollected);
			
			
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
		
		
		private function setup():void
		{
			var nextY:Number;
			
			// Title
			levelText = new TextPlus("Level " + levelNum.toString(), FP.width, LEVELANDROOM_Y, { size: STATSIZE } );
			roomText = new TextPlus("Room " + levelRoomNum.toString(), -JS.getTextWidth(STATSIZE, "Room " + levelRoomNum.toString()), LEVELANDROOM_Y, { size: STATSIZE } );
			roomNameText = new TextPlus(roomNameStr, 0, -JS.getTextHeight(ROOMNAMESIZE, roomNameStr), { size: ROOMNAMESIZE, alignCenterX: FP.halfWidth } );
			
			
			
			// Stats
			movesMadeText = new TextPlus(STR_MOVESMADE, -JS.getTextWidth(STATSIZE, STR_MOVESMADE), STATS_Y, { size: STATSIZE } );
			movesMadeNumText = new TextPlus(movesMade.toString(), FP.width, STATS_Y, { size: STATSIZE } );
			
			nextY = movesMadeText.y + JS.getTextHeight(STATSIZE, movesMadeText.text) + MEMBER_PAD;
			movesBestText = new TextPlus(STR_MOVESBEST, -JS.getTextWidth(STATSIZE, STR_MOVESBEST), nextY, { size: STATSIZE } );
			movesBestNumText = new TextPlus(movesBest.toString(), FP.width, nextY, { size: STATSIZE } );
			
			
			nextY = movesBestText.y + JS.getTextHeight(STATSIZE, movesBestText.text) + GROUP_PAD;
			clearTimeText = new TextPlus(STR_CLEARTIME, -JS.getTextWidth(STATSIZE, STR_CLEARTIME), nextY, { size: STATSIZE } );
			clearTimeNumText = new TextPlus(JS.getTimerStr(clearTime), FP.width, nextY, { size: STATSIZE });
			
			nextY = clearTimeText.y + JS.getTextHeight(STATSIZE, clearTimeText.text) + MEMBER_PAD;
			bestTimeText = new TextPlus(STR_BESTTIME, -JS.getTextWidth(STATSIZE, STR_BESTTIME), nextY, { size: STATSIZE } );
			bestTimeNumText = new TextPlus(JS.getTimerStr(bestTime), FP.width, nextY, { size: STATSIZE } );
			
			
			nextY = bestTimeText.y + JS.getTextHeight(STATSIZE, bestTimeText.text) + GROUP_PAD;
			orbsText = new TextPlus(STR_ORBS, -JS.getTextWidth(STATSIZE, STR_ORBS), nextY, { size: STATSIZE } );
			orbsStatText = new TextPlus(orbsCollected.toString() + "/" + orbsPossible.toString(), FP.width, nextY, { size: STATSIZE } );
			
			
			nextY = orbsText.y + JS.getTextHeight(STATSIZE, orbsText.text) + GROUP_PAD;
			medalText = new TextPlus(STR_MEDAL, -JS.getTextWidth(STATSIZE, STR_MEDAL), nextY, { size: STATSIZE } );
			medal = new EntityPlus(FP.width, nextY + (JS.getTextHeight(STATSIZE, medalText.text) * .5) - (Images.rankingNone.scaledHeight * .5), medalImage(), Game.TEXTLAYER);
			
			
			
			// Set homeCoords
			levelText.setHomeXY(LEVELANDROOM_CENTERX - (JS.getTextWidth(levelText.size, levelText.text) * .5), LEVELANDROOM_Y);
			roomText.setHomeXY((FP.width - LEVELANDROOM_CENTERX) - (JS.getTextWidth(roomText.size, roomText.text) * .5), LEVELANDROOM_Y);
			roomNameText.setHomeXY(roomNameText.x, ROOMNAME_Y);
			
			
			movesMadeText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(movesMadeText.size, movesMadeText.text), movesMadeText.y);
			movesMadeNumText.setHomeXY(STATS_ALIGN_L, movesMadeNumText.y);
			
			movesBestText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(movesBestText.size, movesBestText.text), movesBestText.y);
			movesBestNumText.setHomeXY(STATS_ALIGN_L, movesBestNumText.y);
			
			clearTimeText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(clearTimeText.size, clearTimeText.text), clearTimeText.y);
			clearTimeNumText.setHomeXY(STATS_ALIGN_L, clearTimeNumText.y);
			
			bestTimeText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(bestTimeText.size, bestTimeText.text), bestTimeText.y);
			bestTimeNumText.setHomeXY(STATS_ALIGN_L, bestTimeNumText.y);
			
			orbsText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(orbsText.size, orbsText.text), orbsText.y);
			orbsStatText.setHomeXY(STATS_ALIGN_L, orbsStatText.y);
			
			medalText.setHomeXY(STATS_ALIGN_R - JS.getTextWidth(medalText.size, medalText.text), medalText.y);
			medal.setHomeXY(STATS_ALIGN_L, medal.y);
		}
		
		private function setTweens():void
		{
			var duration:Number = .5;
			var ease:Function;
			
			tweens.push(FP.tween(screenTint.image, { alpha: .6 }, duration, { tweener: screenTint } ));
			
			
			
			duration = .2;
			ease = Ease.quintOut;
			tweenText(levelText, 			duration, .4, ease);
			tweenText(roomText, 			duration, .4, ease);
			
			duration = .4;
			ease = Ease.bounceOut;
			tweenText(roomNameText, 		duration, .7, ease);
			
			
			
			duration = .2;
			ease = Ease.quintOut;
			tweenText(movesMadeText, 		duration, 1, ease);
			tweenText(movesMadeNumText, 	duration, 1, ease);
			tweenText(movesBestText, 		duration, 1.1, ease);
			tweenText(movesBestNumText, 	duration, 1.1, ease);
			tweenText(clearTimeText, 		duration, 1.2, ease);
			tweenText(clearTimeNumText, 	duration, 1.2, ease);
			tweenText(bestTimeText, 		duration, 1.3, ease);
			tweenText(bestTimeNumText, 		duration, 1.3, ease);
			tweenText(orbsText, 			duration, 1.4, ease);
			tweenText(orbsStatText, 		duration, 1.4, ease);
			tweenText(medalText, 			duration, 1.5, ease);
			FP.tween(medal, { x: medal.homeCoords.x, y: medal.homeCoords.y }, duration, { ease: ease, tweener: medal, delay: 1.5 } );
			
			FP.alarm(1.8, addPressSpaceTextAndRetryText);
		}
		
		private function addPressSpaceTextAndRetryText():void
		{
			epAdd(pressEnterText);
			epAdd(retryBtn);
			epAdd(new RunFunctionButton(nextRoom, 200, 0, 400));
		}
		// ------------------------------------------------------------------------
		
		
		private function tweenText(text:TextPlus, duration:Number, delay:Number = 0, ease:Function = null):void
		{
			tweens.push(FP.tween(text, { x: text.homeCoords.x, y: text.homeCoords.y }, duration, { ease: ease, tweener: text, delay: delay } ));
		}
		// ------------------------------------------------------------------------
		
		
		private function medalImage():Image
		{
			// Should the medal in RoomCompleteScreen be base off of movesBest or movesMade?
			// Going with movesMade for now, Stats in title menu will have medal based off of movesBest
			if (movesMade <= movesQualGold + Game.DIFF_BRONZE) // If qualified for any medal
			{
				if (movesMade <= movesQualGold) return Images.rankingGold;
				if (movesMade <= movesQualGold + Game.DIFF_SILVER) return Images.rankingSilver;
				return Images.rankingBronze;
			}
			
			
			return Images.rankingNone;
		}
		// ------------------------------------------------------------------------
		
		
		public function nextRoom():void
		{
			Sounds.select1();
			removeThis();
		}
		
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