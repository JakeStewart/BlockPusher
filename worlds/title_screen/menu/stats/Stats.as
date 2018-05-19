package worlds.title_screen.menu.stats 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.Rectangle;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.other.DisplayTimer;
	import net.jacob_stewart.text.TextButton;;
	
	import gui.MenuArrow;
	import gui.PanelBackground;
	import worlds.title_screen.TitleScreenManager;
	import worlds.title_screen.TitleScreenWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Stats extends EntityGame 
	{
		private var tsm:TitleScreenManager;
		
		private const IDLE:uint = 0;
		private const TWEENING:uint = 1;
		private var state:uint = TWEENING;
		
		private var screenTint:ScreenTint = new ScreenTint(Game.STATSBASELAYER, 0);
		private var panel:PanelBackground = new PanelBackground(Game.STATSBASELAYER - 1, -1, -1);
		
		
		private const YOFFSET:uint = FP.height;
		
		private const PANELSIDEPAD:uint = 10;
		private const TITLEPAD:uint = 10;
		
		private const LINEPAD:uint = PANELSIDEPAD;
		private const LINEWIDTH:uint = JS.roundEven(Math.round(panel.outline.scaledWidth - (LINEPAD * 2)));
		private const LINEX1:Number = FP.halfWidth - (LINEWIDTH * .5);
		private const LINEX2:Number = LINEX1 + LINEWIDTH;
		private var lineY:Number = Math.round(panel.y + JS.getTextHeight(24) + 40 + TITLEPAD);
		
		private const COLOR:uint = 0xFFFFFF;
		private const THICK:uint = 2;
		
		private var line:Rectangle = new Rectangle(LINEX2 - LINEX1, THICK, LINEX1, lineY, Game.STATSBASELAYER - 2, 1, 1, COLOR);
		
		
		private const COLUMNTITLETEXTY:Number = lineY - JS.getTextHeight(16) - 2;
		private const MEDALCENTERX:Number = Math.round(panel.x + panel.outline.scaledWidth - (PANELSIDEPAD * 2) - Game.HALFSPACESIZE);
		private const STATCOLUMN_PAD:uint = 20;
		
		private var levelText:StatsText = new StatsText("LEVEL 1", 0, panel.y + TITLEPAD, { size: 24, alignCenterX: FP.halfWidth } );
		private var roomText:StatsText = new StatsText("Room", LINEX1 + 2, COLUMNTITLETEXTY);
		private var medalText:StatsText = new StatsText("Medal", 0, COLUMNTITLETEXTY, { alignCenterX: MEDALCENTERX } );
		
		private const STR_ORBS:String = "Orbs";
		private const STR_TIME:String = "Time";
		private const STR_MOVES:String = "Moves";
		private const STATCOLUMN_WIDTH:uint = widestStr([STR_TIME, STR_MOVES, STR_ORBS, "00:00"]);
		
		private const ORBS_COLUMN_CENTERX:Number = (medalText.x - STATCOLUMN_PAD) - (STATCOLUMN_WIDTH * .5);
		private var orbsTitle:StatsText = new StatsText(STR_ORBS, 0, COLUMNTITLETEXTY, { alignCenterX: ORBS_COLUMN_CENTERX } );
		
		private const BESTTIME_COLUMN_CENTERX:Number = (orbsTitle.x - STATCOLUMN_PAD) - (STATCOLUMN_WIDTH * .5);
		private var bestTimeTitle:StatsText = new StatsText(STR_TIME, 0, COLUMNTITLETEXTY, { alignCenterX: BESTTIME_COLUMN_CENTERX } );
		
		private const MOVESBEST_COLUMN_CENTERX:Number = (bestTimeTitle.x - STATCOLUMN_PAD) - (STATCOLUMN_WIDTH * .5);
		private var movesBestText:StatsText = new StatsText(STR_MOVES, 0, COLUMNTITLETEXTY, { alignCenterX: MOVESBEST_COLUMN_CENTERX } );
		
		
		
		private var statsAreaY:Number = lineY + THICK;
		private const STATSAREAHEIGHT:uint = (panel.outline.scaledHeight - Game.PANELTHICK) - (statsAreaY - panel.y);
		private const STATSPACING:uint = Math.round(STATSAREAHEIGHT / 11); // 11: the number of rooms displayed + 1
		
		
		private var roomNamesData:Array;
		private var movesBestData:Array;
		private var medalsData:Array;
		private var bestTimeData:Array;
		private var orbsCollectedData:Array;
		
		
		private const TEXTPADLEFTPANEL:uint = 18;
		private const ROOMNUMRIGHTALIGNX:Number = panel.x + TEXTPADLEFTPANEL + JS.getTextWidth(16, "10."); // panel.x is 94
		
		private var levelNum:uint = 1;
		
		
		private var statsText:Array = new Array;
		private var medals:Array = new Array;
		private var movesQualGoldData:Array;
		private var orbsPossibleData:Array;
		
		private var roomCompleteCount:uint = SaveFileData.getRoomCompleteCount(SaveFileData.getSaveFileInUse());
		
		private const ARROWPAD:uint = 6;
		private var arrowUp:MenuArrow = new MenuArrow(pageChange, 0, FP.halfWidth, Math.round(statsAreaY + ARROWPAD + (Images.arrowUpNormal.scaledHeight * .5)), Game.STATSBASELAYER - 2);
		private var arrowDown:MenuArrow = new MenuArrow(pageChange, 2, FP.halfWidth, Math.round((panel.y + panel.outline.scaledHeight) - Images.arrowDownNormal.scaledHeight - 2), Game.STATSBASELAYER - 2);
		
		
		private const STR_EXIT:String = "Exit";
		private const EXITBTN_PAD_TOP:uint = 12;
		private const EXITBTN_PAD_SIDE:uint = 10;
		private const EXITBTN_SIZE:uint = 16;
		private var exitBtn:TextButton = new TextButton(exitBtnClick, STR_EXIT, panel.x + panel.outline.scaledWidth - JS.getTextWidth(EXITBTN_SIZE, STR_EXIT) - EXITBTN_PAD_SIDE, panel.y + EXITBTN_PAD_TOP, { size: EXITBTN_SIZE }, Game.OPTIONSBASELAYER - 2);
		
		
		private var guiList:Array = [getRoomNumsAsList(), screenTint, panel, line, exitBtn, levelText, roomText, orbsTitle, bestTimeTitle, movesBestText, medalText, arrowUp, arrowDown];
		private var textToTweenConst:Array = [guiList[0], exitBtn, levelText, roomText, orbsTitle, bestTimeTitle, movesBestText, medalText];
		public var objectsToTween:Array = [this, panel, line, arrowUp, arrowDown];
		
		
		private const DURATION:Number = .3;
		private var ease:Function = TitleScreenWorld.navEase;
		private var tweens:Array = new Array;
		
		
		
		public function Stats() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.STATSBASELAYER - 2;
			name = Game.NAME_Stats;
			
			
			movesQualGoldData = RoomData.getMovesQualGoldData();
			orbsPossibleData = RoomData.getOrbsPossibleData();
			var data:Array = SaveFileData.loadStatsData(SaveFileData.getSaveFileInUse());
			
			roomNamesData = data[0];
			movesBestData = data[1];
			medalsData = data[2];
			bestTimeData = data[3];
			orbsCollectedData = data[4];
			
			
			objectsToTween = objectsToTween.concat(textToTweenConst);
			buildStats();
			guiList.push(statsText, medals);
			line.setHomeXY(line.x, line.y);
			setStartY(objectsToTween);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			tsm = world.getInstance(Game.NAME_TitleScreenManager) as TitleScreenManager;
			
			epAddList(guiList);
			arrowUp.epCollidableAndVisible(false);
			if (roomCompleteCount < levelNum * 10) arrowDown.epCollidableAndVisible(false);
			tweenIn();
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			tsm = null;
			statsText.length = 0;
			medals.length = 0;
			guiList.length = 0;
			textToTweenConst.length = 0;
			objectsToTween.length = 0;
			tweens.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			pageChange();
		}
		// ------------------------------------------------------------------------
		
		
		public function tweenIn():void
		{
			state = TWEENING;
			JS.cancelTweens(tweens);
			tweens.push(FP.tween(screenTint.image, { alpha: .4 }, DURATION, { tweener: screenTint } ));
			tweenEntities(objectsToTween, 0, 0, onTweenInComplete);
			
			Sounds.openOptions2();
		}
		
		public function tweenOut():void
		{
			state = TWEENING;
			JS.cancelTweens(tweens);
			tweens.push(FP.tween(screenTint.image, { alpha: 0 }, DURATION, { tweener: screenTint } ));
			tweenEntities(objectsToTween, 0, YOFFSET, onTweenOutComplete);
			
			Sounds.knock1();
		}
		
		private function onTweenInComplete():void
		{
			epRemoveList([arrowUp, arrowDown]);
			if (roomCompleteCount > 9) epAdd(arrowDown);
			setStateIdle();
		}
		
		private function onTweenOutComplete():void
		{
			removeThis();
		}
		
		private function tweenEntities(entities:Array, xOffset:int = 0, yOffset:int = 0, _onComplete:Function=null):void
		{
			var onComplete:Function;
			entities = JS.getArrayAsFlat(entities);
			for each (var e:EntityPlus in entities)
			{
				onComplete = null;
				if (e == entities[entities.length - 1]) onComplete = _onComplete;
				tweens.push(FP.tween(e, { x: e.homeCoords.x + xOffset, y: e.homeCoords.y + yOffset }, DURATION, { complete: onComplete, ease: ease, tweener: e } ));
			}
		}
		// -------------------------------------------------------------------------
		
		
		public function pageChange(val:int = 0):void
		{
			if (state == IDLE)
			{
				if (Input.keys(Keys.UP).indexOf(val) != -1)
				{
					if (levelNum - 1 > 0)
					{
						levelNum--;
						changeLevelNum();
						addStats();
						
						
						epAdd(arrowDown);
						if (levelNum == 1) epRemove(arrowUp);
						else epAdd(arrowUp);
						
						arrowUp.onKeyPressed();
						
						Sounds.tick3();
					}
				}
				else if (Input.keys(Keys.DOWN).indexOf(val) != -1)
				{
					if (roomCompleteCount >= levelNum * 10) // If user has made it to the next level
					{
						if (levelNum <= (roomNamesData.length - 1) / 10)
						{
							levelNum++;
							changeLevelNum();
							addStats();
							
							
							var finalLevelNum:uint = ((roomNamesData.length - 1) / 10) + 1;
							
							arrowUp.epCollidableAndVisible(true);
							epAdd(arrowUp);
							if (levelNum < finalLevelNum && roomCompleteCount >= levelNum * 10) epAdd(arrowDown);
							else epRemove(arrowDown);
							
							arrowDown.onKeyPressed();
							
							Sounds.tick3();
						}
					}
				}
			}
		}
		
		private function changeLevelNum():void
		{
			levelText.changeText("LEVEL " + levelNum.toString());
			levelText.setHomeXY(levelText.x, levelText.y);
		}
		// -------------------------------------------------------------------------
		
		
		private function addStats():void
		{
			clearStats();
			buildStats();
			epAddList([statsText, medals]);
		}
		
		private function clearStats():void
		{
			epRemoveList([statsText, medals]);
			statsText.length = 0, medals.length = 0;
		}
		
		private function buildStats():void
		{
			var centerY:Number;
			var roomIndex:uint;
			var roomName:String;
			var movesBestNumStr:String;
			var movesQualGold:uint;
			var bestTimeStr:String;
			var orbStat:String;
			
			
			for (var i:uint = 0; i < 10; i++)
			{
				centerY = Math.round(statsAreaY + ((i + 1) * STATSPACING));
				roomIndex = ((levelNum - 1) * 10) + i;
				
				// Room name
				if (roomIndex < roomNamesData.length) roomName = roomNamesData[roomIndex];
				else roomName = "Not Created";
				
				statsText.push(new StatsText(roomName, ROOMNUMRIGHTALIGNX + 10, 0, { alignCenterY: centerY } ));
				
				
				// Moves best
				movesBestNumStr = "~";
				if (movesBestData[roomIndex] > -1) movesBestNumStr = movesBestData[roomIndex].toString();
				statsText.push(new StatsText(movesBestNumStr, 0, 0, { alignCenterX: MOVESBEST_COLUMN_CENTERX, alignCenterY: centerY } ));
				
				
				// Medal
				if (movesBestData[roomIndex] > -1) // If room has been completed
				{
					movesQualGold = movesQualGoldData[roomIndex];
					
					if (movesBestData[roomIndex] <= movesQualGold + Game.DIFF_BRONZE) // If qualified for any medal
					{
						var medalIndex:uint = 0; // 0 for bronze, 1 for silver, 2 for gold
						
						if (movesBestData[roomIndex] <= movesQualGold) medalIndex = 2; // Gold
						else if (movesBestData[roomIndex] <= movesQualGold + Game.DIFF_SILVER) medalIndex = 1; // Silver
						
						medals.push(new StatsMedal(medalIndex, MEDALCENTERX, centerY));
					}
				}
				
				
				// Best time
				bestTimeStr = "~";
				if (bestTimeData[roomIndex] > 0) bestTimeStr = JS.getTimerStr(bestTimeData[roomIndex]);
				statsText.push(new StatsText(bestTimeStr, 0, 0, { alignCenterX: BESTTIME_COLUMN_CENTERX, alignCenterY: centerY } ));
				
				
				// Orbs
				orbStat = "~";
				if (roomIndex < orbsPossibleData.length) orbStat = orbsCollectedData[roomIndex].toString() + "/" + orbsPossibleData[roomIndex];
				statsText.push(new StatsText(orbStat, 0, 0, { alignCenterX: ORBS_COLUMN_CENTERX, alignCenterY: centerY } ));
			}
			
			
			objectsToTween = objectsToTween.concat(statsText, medals);
		}
		// -------------------------------------------------------------------------
		
		
		private function getRoomNumsAsList():Array
		{
			var list:Array = new Array;
			
			for (var i:uint = 0; i < 10; i++)
			{
				list.push(new StatsText((i + 1).toString() + ".", 0, 0, { alignCenterY: statsAreaY + ((i + 1) * STATSPACING), alignRight: ROOMNUMRIGHTALIGNX } ));
			}
			
			
			return list;
		}
		
		private function setStartY(list:Array):void
		{
			var e:EntityPlus;
			
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) setStartY(list[i]);
				else
				{
					e = list[i];
					e.y = e.homeCoords.y + YOFFSET;
				}
			}
		}
		// -------------------------------------------------------------------------
		
		
		private function setStateIdle():void
		{
			state = IDLE;
		}
		
		private function widestStr(list:Array):uint
		{
			var widest:uint;
			for (var i:uint = 0; i < list.length; i++)
			{
				if (JS.getTextWidth(16, list[i]) > widest) widest = JS.getTextWidth(16, list[i]);
			}
			
			
			return widest;
		}
		// -------------------------------------------------------------------------
		
		
		private function exitBtnClick():void
		{
			tsm.exitStats(this);
		}
		// -------------------------------------------------------------------------
		
	}

}