package worlds.title_screen.menu 
{
	import flash.system.fscommand;
	
	import net.flashpunk.FP;
	
	import net.jacob_stewart.graphics.OverlayFadeIn;
	
	import worlds.WorldGame;
	import worlds.game_play.GamePlayWorld;
	import worlds.room_designer.RoomDesignerWorld;
	import worlds.room_select.RoomSelectWorld;
	import worlds.title_screen.TitleScreenSection;
	import worlds.title_screen.menu.options.OptionsMenu_TS;
	import worlds.title_screen.menu.stats.Stats;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TitleScreenMenu extends TitleScreenSection 
	{
		public var fromGame:Boolean;
		private var startRoomNum:uint = 1;
		
		private var option:TitleMenuButton;
		public var selector:MenuListSelector;
		
		private const BTNAREAHEIGHT:uint = Math.round(FP.height -  Game.TSTAH);
		private const BTNAREAY:uint = Math.round(FP.height - BTNAREAHEIGHT);
		private var spacing:uint;
		
		private var startGameBtn:TitleMenuButton = new TitleMenuButton(0, startGame, "NEW GAME");
		private var continueBtn:ContinueBtn_TS = new ContinueBtn_TS(1, continueGame, "CONTINUE");
		private var roomSelectorBtn:RoomSelectorBtn_TS = new RoomSelectorBtn_TS(2, runRoomSelector, "ROOM SELECT");
		private var roomDesignerBtn:TitleMenuButton = new TitleMenuButton(3, runRoomDesigner, "ROOM DESIGNER");
		private var statsBtn:TitleMenuButton = new TitleMenuButton(4, runStats, "STATS");
		private var optionsBtn:TitleMenuButton = new TitleMenuButton(5, runOptions, "OPTIONS");
		private var fileSelectBtn:TitleMenuButton = new TitleMenuButton(6, navFileSelect, "FILE SELECT");
		// private var exitGameBtn:TitleMenuButton = new TitleMenuButton(6, exitGame, "EXIT GAME");
		public var btns:Array = [startGameBtn, continueBtn, roomSelectorBtn, roomDesignerBtn, statsBtn, optionsBtn, fileSelectBtn];
		
		private var _class:Class;
		
		
		
		public function TitleScreenMenu(fromGame:Boolean = false) 
		{
			this.fromGame = fromGame;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_TitleScreenMenu;
			
			spacing = Math.round(BTNAREAHEIGHT / (btns.length + 1));
			
			for (var i:uint = 0; i < btns.length; i++)
			{
				option = btns[i];
				
				// set x
				if (!fromGame) option.centerHor(option.textWidth, FP.halfWidth + FP.width);
				
				// set y
				option.centerVer(option.textHeight, BTNAREAY + ((i + 1) * spacing));
				option.setHomeXY(FP.halfWidth - option.textHalfWidth, option.y);
				
				if (fromGame) option.setXY(option.x, option.y + FP.height);
			}
			
			objectsToTween.push(btns);
			
			
			
			selector = new MenuListSelector(this);
			objectsToTween.push(selector);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			sectionNum = tsm.TITLEMENU;
			epAddList(btns);
			epAdd(selector);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			option = null;
			btns.length = 0;
		}
		// -------------------------------------------------------------------------------------
		
		
		public function optionSelected():void
		{
			selector.option.click();
		}
		
		private function navToGame():void
		{
			tsm.navToGame();
			epAdd(new OverlayFadeIn(Game.OVERLAYDURATION, runChoice, Game.SCREENCOLOR));
		}
		
		private function runChoice():void
		{
			if (_class == GamePlayWorld) FP.world = new GamePlayWorld(startRoomNum, RoomData.XMLFILEPREFIX);
			else FP.world = new _class;
		}
		// -------------------------------------------------------------------------------------
		
		
		private function startGame():void
		{
			_class = GamePlayWorld;
			navToGame();
		}
		
		private function continueGame():void
		{
			startRoomNum = SaveFileData.getCurrentRoomNum(SaveFileData.getSaveFileInUse());
			_class = GamePlayWorld;
			navToGame();
		}
		
		private function runRoomSelector():void
		{
			_class = RoomSelectWorld;
			navToGame();
		}
		
		private function runRoomDesigner():void
		{
			_class = RoomDesignerWorld;
			navToGame();
		}
		
		private function runStats():void
		{
			var stats:Stats = world.getInstance(Game.NAME_Stats) as Stats;
			if (!stats) world.add(new Stats); // No epAdd, Stats will remove itself from the world
			else stats.tweenIn();
			
			tsm.currentSectionNum = tsm.STATS;
		}
		
		private function runOptions():void
		{
			var options:OptionsMenu_TS = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_TS;
			if (!options) world.add(new OptionsMenu_TS); // No epAdd, OptionsMenu_TS will remove itself from the world
			else options.tweenIn();
			
			tsm.currentSectionNum = tsm.OPTIONS;
		}
		
		private function navFileSelect():void
		{
			tsm.navFileSelect();
		}
		
		private function exitGame():void
		{
			Game.quitSWF();
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}