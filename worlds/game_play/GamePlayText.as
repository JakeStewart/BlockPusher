package worlds.game_play 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextPlus;
	
	import collectables.Orb;
	import worlds.game_play.GamePlayWorld;
	import worlds.room_tester.RoomTesterWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GamePlayText extends EntityGame 
	{
		private var gpm:GamePlayManager;
		
		private const BASELAYER:int = Game.GPGUILAYER;
		private const BACKALPHA:Number = .5;
		
		public var roomName:TextPlus = new TextPlus("Untitled", 0, Game.ROOMNAME_PADY, { size: Game.SIZE_ROOMNAME, alignCenterX: FP.halfWidth, backAlpha: BACKALPHA }, BASELAYER);
		
		
		private const LROFFSET:Number = .125;
		private var level:TextPlus = new TextPlus("Level 1", 0, 0, { alignCenterX: Math.round(FP.width * LROFFSET), alignCenterY: Game.textAreaHeight * .5, backAlpha: BACKALPHA }, BASELAYER);
		private var room:TextPlus = new TextPlus("Room 1", 0, 0, { alignCenterX: Math.round(FP.width * (1 - LROFFSET)), alignCenterY: Game.textAreaHeight * .5, backAlpha: BACKALPHA }, BASELAYER);
		
		
		private const MOVESPAD:uint = 4;
		private const MOVESSIZE:uint = 18;
		private const MOVESY:uint = Game.BOTTOMAREACEILING;
		
		private const DIVIDEROFFSET:uint = Math.round(JS.getTextWidth(MOVESSIZE, "MOVES MADE") * .7);
		
		private var movesMade:TextPlus = new TextPlus("MOVES MADE", 0, MOVESY, { size: MOVESSIZE, alignCenterX: FP.halfWidth - DIVIDEROFFSET, backAlpha: BACKALPHA }, BASELAYER);
		private var movesBest:TextPlus = new TextPlus("MOVES BEST", 0, MOVESY, { size: MOVESSIZE, alignCenterX: FP.halfWidth + DIVIDEROFFSET, backAlpha: BACKALPHA }, BASELAYER);
		private var movesMadeNum:TextPlus = new TextPlus("0", 0, MOVESY + JS.getTextHeight(MOVESSIZE, "0") + MOVESPAD, { alignCenterX: FP.halfWidth - DIVIDEROFFSET, backAlpha: BACKALPHA }, BASELAYER);
		private var movesBestNum:TextPlus = new TextPlus("0", 0, MOVESY + JS.getTextHeight(MOVESSIZE, "0") + MOVESPAD, { alignCenterX: FP.halfWidth + DIVIDEROFFSET, backAlpha: BACKALPHA }, BASELAYER);
		private var movesBestStr:String;
		
		
		private var movesDivider:MovesDividerLine = new MovesDividerLine(BASELAYER);
		
		public var orb:Orb = new Orb(FP.width - Game.textAreaHalfWidth - (Images.glowOrb1a.scaledWidth * .5), (FP.height * .75) - (Images.glowOrb1a.scaledHeight * .5));
		private var orbCounter:TextPlus = new TextPlus("0/0", 0, orb.y + Images.glowOrb1a.scaledHeight + 4, { alignCenterX: orb.x + (Images.glowOrb1a.scaledWidth * .5) } );
		
		
		public var guiList:Array = [roomName, level, room, movesMade, movesMadeNum, movesBest, movesBestNum, movesDivider, orb, orbCounter];
		
		
		
		public function GamePlayText() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -4;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			
			
			if (world is GamePlayWorld)
			{
				updateMovesBestText(gpm.fileNameIndex);
				updateLevelOrRoomNum(gpm.fileNameIndex);
				
				epAddList(guiList);
			}
			else if (world is RoomTesterWorld)
			{
				movesMade.centerHor(movesMade.textWidth), movesMadeNum.centerHor(movesMadeNum.textWidth);
				epAddList([movesMade, movesMadeNum, orb, orbCounter]);
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			guiList.length = 0;
		}
		// ------------------------------------------------------------------------------------------
		
		
		public function setRoomName(roomNameStr:String):void
		{
			roomName.changeText(roomNameStr);
		}
		
		public function updateLevelOrRoomNum(fileNameIndex:uint):void
		{
			var lnum:uint = ((fileNameIndex - 1) / 10) + 1;
			var rnum:uint = ((fileNameIndex - 1) % 10) + 1;
			
			if (fileNameIndex == 0) lnum = 0, rnum = 0; // Testing room
			
			level.changeText("Level " + lnum.toString());
			room.changeText("Room " + rnum.toString());
		}
		
		public function updateMovesBestText(fileNameIndex:uint):void
		{
			movesBestStr = SaveFileData.getMovesBest(fileNameIndex).toString();
			if (movesBestStr == "-1") movesBestStr = "~";
			movesBestNum.changeText(movesBestStr);
		}
		
		public function updateMovesMadeNum(movesMadeNum:uint):void
		{
			this.movesMadeNum.changeText(movesMadeNum.toString());
		}
		
		public function updateOrbText(collectedCount:uint, possible:uint):void
		{
			orbCounter.changeText(collectedCount.toString() + "/" + possible.toString());
		}
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
	}

}