package worlds.title_screen 
{
	import flash.system.fscommand;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.title_screen.InputManager_TS;
	import worlds.title_screen.file_select.DeleteSaveFile;
	import worlds.title_screen.file_select.FileSelectManager;
	import worlds.title_screen.menu.MenuListSelector;
	import worlds.title_screen.menu.TitleScreenMenu;
	import worlds.title_screen.menu.options.OptionsMenu_TS;
	import worlds.title_screen.menu.stats.Stats;
	import worlds.title_screen.press_space_screen.PressSpaceScreen;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TitleScreenManager extends EntityGame 
	{
		private var fromGame:Boolean;
		
		public var mp:MousePointer_TS = new MousePointer_TS([JS.TYPE_Button, JS.TYPE_TextButton]);
		private var im:InputManager_TS;
		
		private var ps:PressSpaceScreen;
		private var fs:FileSelectManager;
		private var tm:TitleScreenMenu;
		private var options:OptionsMenu_TS;
		private var stats:Stats;
		private var menuSelector:MenuListSelector;
		private var dsf:DeleteSaveFile;
		
		private var title:TextPlus = new TextPlus("BLOCK PUSHER", 0, 0, { size: 64, alignCenterX: FP.halfWidth, alignCenterY: (Game.TSTAH + 40) * .5 } );
		
		private var tweens:Array = new Array;
		private const DURATION:Number = TitleScreenWorld.navDuration;
		
		
		public const SPACESCREEN:uint = 0;
		public const FILESELECT:uint = 1;
		public const TITLEMENU:uint = 2;
		public const STATS:uint = 3;
		public const OPTIONS:uint = 4;
		public const DELETESAVEFILE:uint = 5;
		public var currentSectionNum:uint = SPACESCREEN;
		
		
		
		public function TitleScreenManager(fromGame:Boolean = false) 
		{
			this.fromGame = fromGame;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_TitleScreenManager;
			name = Game.NAME_TitleScreenManager;
			
			im = new InputManager_TS(mp, this);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([mp, im, title]);
			
			if (fromGame) navTitleMenu();
			else world.add(new PressSpaceScreen);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			ps = null;
			fs = null;
			tm = null;
			options = null;
			stats = null;
			dsf = null;
			menuSelector = null;
			tweens.length = 0;
		}
		// -----------------------------------------------------------------------------
		
		
		public function keyPressed(key:int):void
		{
			switch (currentSectionNum)
			{
				case SPACESCREEN: // PressSpaceScreen
					
					
					ps = world.getInstance(Game.NAME_PressSpaceScreen) as PressSpaceScreen;
					
					if (Input.pressed(Keys.SELECT)) navFileSelect();
					else if (Input.pressed(Keys.CANCEL) && ps.x >= -FP.halfWidth) Game.quitSWF();
					
					
					break;
					
				case FILESELECT: // FileSelect
					
					
					fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
					
					if (Input.pressed(Keys.SELECT)) navTitleMenu();
					else if (Input.pressed(Keys.CANCEL)) navPressSpaceScreen();
					else if (Input.pressed(Keys.HOR)) fs.changeFileHighlighted(key);
					
					
					break;
					
				case TITLEMENU: // TitleScreenMenu
					
					
					tm = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
					menuSelector = world.getInstance(Game.NAME_MenuListSelector) as MenuListSelector;
					
					if (Input.pressed(Keys.SELECT) && tm)
					{
						if (menuSelector.option.text == "STATS") currentSectionNum = STATS;
						else if (menuSelector.option.text == "OPTIONS") currentSectionNum = OPTIONS;
						
						tm.optionSelected();
					}
					else if (Input.pressed(Keys.CANCEL)) navFileSelect();
					else if (Input.pressed(Keys.VER) && tm) menuSelector.keyPressed(key);
					
					
					break;
					
				case STATS: // Stats
					
					
					stats = world.getInstance(Game.NAME_Stats) as Stats;
					
					if (Input.pressed(Keys.CANCEL) && stats) exitStats(stats);
					else if (Input.pressed(Keys.VER) && stats) stats.pageChange(key);
					
					
					break;
					
				case OPTIONS: // Options
					
					
					options = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_TS;
					
					if (Input.pressed(Keys.SELECT) && options)
					{
						if (options.selector.option.onSelect != null && options.state != options.STATE_TWEENING) options.selector.option.select();
						// if (options.selector.option.onSelect != null && !options.selector.tween.active) options.selector.option.select();
					}
					else if (Input.pressed(Keys.CANCEL) && options) options.exit();
					else if (Input.pressed(Keys.DIR))
					{
						if (Input.pressed(Keys.VER) && options.state != options.STATE_TWEENING) options.selector.changeSelection(key);
						else if (Input.pressed(Keys.HOR)) options.changeSetting(key);
					}
					
					
					break;
					
				case DELETESAVEFILE: // DeleteSaveFile
					
					
					dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
					dsf.keyPressed();
					
					
					break;
			}
		}
		// -----------------------------------------------------------------------------
		
		
		public function clickButton():void
		{
			switch (currentSectionNum)
			{
				case SPACESCREEN: // PressSpaceScreen
				{
					navFileSelect();
					
					break;
				}
				
				case FILESELECT: // FileSelect
				{
					
					
					break;
				}
				
				case TITLEMENU: // TitleScreenMenu
				{
					
					
					break;
				}
				
				case STATS: // Stats
				{
					
					
					break;
				}
				
				case OPTIONS: // Options
				{
					
					
					break;
				}
				
				case DELETESAVEFILE: // DeleteSaveFile
				{
					
					
					break;
				}
			}
		}
		
		public function mousePressed():void
		{
			switch (currentSectionNum)
			{
				case SPACESCREEN: // PressSpaceScreen
				{
					
					
					break;
				}
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		private function tweenEntities(entities:Array, xOffset:int = 0, yOffset:int = 0, delay:Number = 0, onComplete:Function = null):void
		{
			var e:EntityPlus;
			var _onComplete:Function;
			entities = JS.getArrayAsFlat(entities);
			
			for (var i:uint = 0; i < entities.length; i++)
			{
				e = entities[i];
				_onComplete = null;
				if (onComplete != null && e is TitleScreenSection) _onComplete = onComplete;
				e.tween = FP.tween(e, { x: e.homeCoords.x + xOffset, y: e.homeCoords.y + yOffset }, DURATION, { complete: _onComplete, ease: TitleScreenWorld.navEase, tweener: e, delay: delay } );
				tweens.push(e.tween);
			}
		}
		// -----------------------------------------------------------------------------
		
		
		private function navPressSpaceScreen():void
		{
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			if (fs.x + FP.halfWidth >= 0 && fs.x + FP.halfWidth <= FP.width)
			{
				ps = world.getInstance(Game.NAME_PressSpaceScreen) as PressSpaceScreen;
				if (!ps || ps.tween.percent == 1) ps = world.add(new PressSpaceScreen(true)) as PressSpaceScreen;
				
				
				Sounds.knock1();
				JS.cancelTweens(tweens);
				
				
				// OUT
				tweenEntities([title]); // In case not done tweening in from game
				tweenEntities(fs.objectsToTween, FP.width, 0, 0, fs.removeThis);
				
				tm = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
				if (tm) tweenEntities(tm.objectsToTween, FP.width, 0, 0, tm.removeThis);
				
				// IN
				tweenEntities(ps.objectsToTween);
				
				
				currentSectionNum = SPACESCREEN;
			}
		}
		
		public function navFileSelect():void
		{
			if (currentSectionNum == SPACESCREEN)
			{
				ps = world.getInstance(Game.NAME_PressSpaceScreen) as PressSpaceScreen;
				if (ps.x >= -FP.halfWidth)
				{
					fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
					if (!fs || fs.tween.percent == 1) fs = world.add(new FileSelectManager) as FileSelectManager;
					
					
					Sounds.tick1();
					JS.cancelTweens(tweens);
					
					
					// OUT
					tweenEntities(ps.objectsToTween, -FP.width, 0, 0, ps.removeThis);
					
					// IN
					tweenEntities(fs.objectsToTween);
					
					
					currentSectionNum = FILESELECT;
				}
			}
			else if (currentSectionNum == TITLEMENU)
			{
				tm = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
				if (tm.x + FP.halfWidth <= FP.width && tm.y == tm.homeCoords.y)
				{
					fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
					if (!fs || fs.tween.percent == 1) fs = world.add(new FileSelectManager(true)) as FileSelectManager;
					
					
					Sounds.knock1();
					JS.cancelTweens(tweens);
					
					
					// OUT
					tweenEntities([title]); // In case not done tweening in from game
					tweenEntities(tm.objectsToTween, FP.width, 0, 0, tm.removeThis);
					
					// IN
					tweenEntities(fs.objectsToTween);
					
					
					currentSectionNum = FILESELECT;
				}
			}
		}
		
		public function navTitleMenu():void
		{
			if (currentSectionNum == FILESELECT)
			{
				fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
				if (fs.x + FP.halfWidth >= 0 && fs.x + FP.halfWidth <= FP.width)
				{
					var delay:Number = 0;
					if (SaveFileData.getSaveFileState(fs.fileHighlighted) == -1) delay = 1;
					
					if (delay == 0 || !fs.tween.active)
					{
						tm = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
						if (!tm || tm.tween.percent == 1) tm = world.add(new TitleScreenMenu) as TitleScreenMenu;
						
						
						if (delay == 1) im.epActive(false), FP.alarm(delay, im.activate);
						fs.fileSelected();
						JS.cancelTweens(tweens);
						
						
						// OUT
						tweenEntities(fs.objectsToTween, -FP.width, 0, delay, fs.removeThis);
						
						ps = world.getInstance(Game.NAME_PressSpaceScreen) as PressSpaceScreen;
						if (ps) tweenEntities(ps.objectsToTween, -FP.width, 0, delay, ps.removeThis);
						
						// IN
						tweenEntities(tm.objectsToTween, 0, 0, delay);
						
						
						currentSectionNum = TITLEMENU;
					}
				}
			}
			else // From game
			{
				title.setXY(title.x, title.y - FP.halfHeight);
				tweenEntities([title]);
				
				
				tm = world.add(new TitleScreenMenu(true)) as TitleScreenMenu;
				tweenEntities(tm.objectsToTween);
				
				
				currentSectionNum = TITLEMENU;
			}
		}
		
		public function navToGame():void
		{
			im.epActive(false);
			JS.cancelTweens(tweens);
			
			Sounds.select1();
			
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			if (fs) tweenEntities(fs.objectsToTween, -FP.width);
			
			
			tweenEntities([title], 0, -FP.halfHeight);
			
			tm = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
			tweenEntities(tm.objectsToTween, 0, FP.height);
		}
		// -----------------------------------------------------------------------------
		
		
		public function exitStats(stats:Stats):void
		{
			stats.tweenOut();
			currentSectionNum = TITLEMENU;
		}
		// -----------------------------------------------------------------------------
		
	}
	
}