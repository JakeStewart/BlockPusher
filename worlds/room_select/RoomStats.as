package worlds.room_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.other.DisplayTimer;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomStats extends EntityGame 
	{
		private var rs:RoomSelect;
		
		private const TEXTSIZE1:uint = 16;
		private const TEXTSIZE2:uint = 32;
		private const TEXTSIZE3:uint = 24;
		
		/**
		 * The y center coordinate for movesBestText & medalText
		 */
		private const CENTERY1:Number = Game.textAreaHeight + (Game.SPACESIZE * 1.5) + Game.SPACEPADDING;
		
		/**
		 * The y center coordinate for bestTimeText
		 */
		private const CENTERY2:Number = (FP.height - Game.textAreaHeight) - ((Game.SPACESIZE * 3) + Game.SPACEPADDING);
		
		/**
		 * The distance from top to bottom of 2 lines of text
		 * based off of:
			 * MOVES
			 * BEST
		 */
		private const TEXTAREA1HEIGHT:uint = Math.round(JS.getTextHeight(TEXTSIZE1) * 2);
		
		/**
		 * The distance between the bottom of TEXTAREA1 and stats like moves best amount or the medal image
		 */
		private const PADDING1:uint = 8;
		
		/**
		 * The y of a stat like moves best amount or the medal image
		 */
		private const STAT1Y:Number = Math.round(CENTERY1 + (TEXTAREA1HEIGHT * .5) + PADDING1);
		
		/**
		 * The y of the best time amount text
		 */
		private const STAT2Y:Number = Math.round(CENTERY2 + (TEXTAREA1HEIGHT * .5) + PADDING1);
		
		
		private var movesBestText:TextPlus = new TextPlus("MOVES BEST", 0, 0, { size: TEXTSIZE1, alignCenterX: Game.textAreaHalfWidth, alignCenterY: CENTERY1 } );
		private var movesBestAmtText:TextPlus = new TextPlus("0", 0, STAT1Y, { size: TEXTSIZE2, alignCenterX: Game.textAreaHalfWidth, includeBack: false } );
		
		private var medalText:TextPlus = new TextPlus("MEDAL", 0, 0, { size: TEXTSIZE1, alignCenterX: FP.width - Game.textAreaHalfWidth, alignCenterY: CENTERY1 } );
		private var medal:EntityGame = new EntityGame(FP.width - Game.textAreaHalfWidth - (Images.rankingGold.scaledWidth * .5), STAT1Y, Images.rankingNone);
		
		private var bestTimeText:TextPlus = new TextPlus("BEST TIME", 0, 0, { size: TEXTSIZE1, alignCenterX: Game.textAreaHalfWidth, alignCenterY: CENTERY2 } );
		private var bestTimeAmtText:TextPlus = new TextPlus("00:00", 0, STAT2Y, { size: TEXTSIZE3, alignCenterX: Game.textAreaHalfWidth, includeBack: false } );
		
		private var orbsText:TextPlus = new TextPlus("ORBS", 0, 0, { size: TEXTSIZE1, alignCenterX: FP.width - Game.textAreaHalfWidth, alignCenterY: CENTERY2 } );
		private var orbCountText:TextPlus = new TextPlus("0/0", 0, STAT2Y, { size: TEXTSIZE3, alignCenterX: FP.width - Game.textAreaHalfWidth, includeBack: false } );
		
		private var guiList:Array = [movesBestText, movesBestAmtText, medalText, medal, bestTimeText, bestTimeAmtText, orbsText, orbCountText];
		
		
		private var visibleStates:Array = new Array;
		
		
		
		public function RoomStats() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			movesBestText.wordWrap(Math.round(JS.getTextWidth(TEXTSIZE1, "MOVES")));
			movesBestText.align("center");
			movesBestText.centerHor(movesBestText.textWidth, Game.textAreaHalfWidth), movesBestText.centerVer(movesBestText.textHeight, CENTERY1);
			
			bestTimeText.wordWrap(Math.round(JS.getTextWidth(TEXTSIZE1, "BEST")));
			bestTimeText.align("center");
			bestTimeText.centerHor(bestTimeText.textWidth, Game.textAreaHalfWidth), bestTimeText.centerVer(bestTimeText.textHeight, CENTERY2);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
			visibleStates.push(rs.im.STATE_MAIN, rs.im.STATE_UDW);
			changeStats();
			epAddList(guiList);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
			guiList.length = 0;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			movesBestAmtText.epVisible(false), medal.epVisible(false), bestTimeAmtText.epVisible(false), orbCountText.epVisible(false);
			if (visibleStates.indexOf(rs.im.state) != -1) movesBestAmtText.epVisible(true), medal.epVisible(true), bestTimeAmtText.epVisible(true), orbCountText.epVisible(true);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		public function changeStats():void
		{
			var room:XML;
			
			// moves best
			var movesBest:int = SaveFileData.getMovesBest(rs.fileNameIndex);
			if (movesBest == -1) movesBestAmtText.changeText("~");
			else movesBestAmtText.changeText(movesBest.toString());
			
			
			// Medal
			var movesQualGold:uint;
			var medalIndex:uint = 0;
			medal.graphic = Images.rankingNone;
			
			if (rs.fileNamePrefix == RoomData.getUserPrefix())
			{
				Data.load(rs.fileNamePrefix + rs.fileNameIndex.toString());
				movesQualGold = Data.readUint("movesQualGold");
			}
			else
			{
				room = FP.getXML(RoomData.roomDataClasses[rs.fileNameIndex - 1]);
				movesQualGold = room.@movesQualGold;
			}
			
			if (movesBest <= movesQualGold + 5 && movesBest != -1) // If qualified for any medal
			{
				if (movesBest <= movesQualGold) medalIndex = 2; // Gold
				else if (movesBest > movesQualGold && movesBest < movesQualGold + 3) medalIndex = 1; // Silver
				
				medal.graphic = Images.rankingBlocks[medalIndex];
			}
			
			
			// Best time
			var bestTime:int = SaveFileData.getBestTime(rs.fileNameIndex);
			if (bestTime < 1) bestTimeAmtText.changeText("~");
			else bestTimeAmtText.changeText(JS.getTimerStr(bestTime));
			
			
			// Orbs
			var orbsPossible:uint;
			var orbsCollected:uint = SaveFileData.getOrbsBest(rs.fileNameIndex);
			
			if (rs.fileNamePrefix == RoomData.getUserPrefix())
			{
				Data.load(rs.fileNamePrefix + rs.fileNameIndex.toString());
				orbsPossible = Data.readUint("orbCount");
			}
			else
			{
				room = FP.getXML(RoomData.roomDataClasses[rs.fileNameIndex - 1]);
				orbsPossible = room.orbs.@count;
			}
			
			orbCountText.changeText(orbsCollected.toString() + "/" + orbsPossible.toString());
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}