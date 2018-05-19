package worlds.game_play 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	
	import game_pieces.blocks.push_blocks.move_arrows.MoveArrow;
	import worlds.game_play.options_menu.OptionsMenu_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class InputManager_GP extends InputManager 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		private var rc:RoomCompleteScreen;
		private var rf:RoomFailedScreen;
		private var options:OptionsMenu_GP;
		
		
		public const IDLE:uint = 0;
		public const PENDINGMOVE:uint = 1;
		public const MOVING:uint = 2;
		public const ROOMCOMPLETE:uint = 3;
		public const ROOMFAILED:uint = 4;
		public const OPTIONS:uint = 5;
		public var state:uint = IDLE;
		
		
		private var dirVal:uint;
		
		
		
		public function InputManager_GP(mp:MousePointerGame) 
		{
			super(mp);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			rc = null;
			rf = null;
			options = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			// testing();
		}
		// ------------------------------------------------------------------------
		
		
		public function keyPressed(key:int):void
		{
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			
			
			switch (state)
			{
				case IDLE:
					
					room = world.getInstance(Game.NAME_Room) as Room;
					
					if (room)
					{
						if (Input.pressed(Keys.SELECT))
						{
							room.blockHighlighter.selectBlock();
							state = PENDINGMOVE;
						}
						else if (Input.pressed(Keys.CANCEL)) openOptionsMenu();
						else if (Input.pressed(Keys.DIR)) room.blockHighlighter.changeBlock(dirVal);
					}
					
					
					break;
					
				case PENDINGMOVE:
					
					if (Input.pressed(Keys.SELECT))
					{
						gpm.setBlockPendingMove(null);
						Sounds.tick2();
						
						state = IDLE;
					}
					else if (Input.pressed(Keys.CANCEL))
					{
						gpm.setBlockPendingMove(null);
						Sounds.tick2();
						
						state = IDLE;
					}
					else if (Input.pressed(Keys.DIR))
					{
						if (gpm.blockPendingMove.directionIsAvailable[dirVal])
						{
							var arrow:MoveArrow = gpm.blockPendingMove.arrows[dirVal];
							arrow.moveBlock();
						}
					}
					
					
					break;
					
				case MOVING:
					
					
					
					
					break;
					
				case ROOMCOMPLETE:
					
					rc = world.getInstance(Game.NAME_RoomCompleteScreen) as RoomCompleteScreen;
					
					if (rc)
					{
						if (rc.pressEnterText.world)
						{
							if (Input.pressed(Keys.SELECT)) rc.nextRoom();
							else if (Input.pressed(Key.R)) rc.retryRoom();
						}
					}
					
					
					break;
					
				case ROOMFAILED:
					
					rf = world.getInstance(Game.NAME_RoomFailedScreen) as RoomFailedScreen;
					
					if (rf)
					{
						if (rf.pressEnterText.world)
						{
							if (Input.pressed(Keys.SELECT)) rf.retryRoom();
						}
					}
					
					
					break;
					
				case OPTIONS:
					
					options = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_GP;
					
					if (options)
					{
						if (Input.pressed(Keys.SELECT))
						{
							if (options.selector.option.onSelect != null && options.state != options.STATE_TWEENING) options.selector.option.select();
						}
						else if (Input.pressed(Keys.CANCEL)) options.exit();
						else if (Input.pressed(Keys.DIR))
						{
							if (Input.pressed(Keys.VER))
							{
								if (options.state != options.STATE_TWEENING) options.selector.changeSelection(key);
							}
						}
					}
					
					
					break;
			}
		}
		
		override public function selectKeys():void 
		{
			super.selectKeys();
			keyPressed(Input.lastKey);
		}
		
		override public function escapeKey():void 
		{
			super.escapeKey();
			keyPressed(Input.lastKey);
		}
		
		override public function arrowKeys(key:int):void 
		{
			super.arrowKeys(key);
			dirVal = getDirVal();
			keyPressed(key);
		}
		
		override public function anyKey(key:int):void 
		{
			super.anyKey(key);
			keyPressed(key);
		}
		
		private function getDirVal():int
		{
			if (Input.pressed(Keys.UP)) return 0;
			else if (Input.pressed(Keys.RIGHT)) return 1;
			else if (Input.pressed(Keys.DOWN)) return 2;
			else if (Input.pressed(Keys.LEFT)) return 3;
			
			
			return -1;
		}
		// ------------------------------------------------------------------------
		
		
		public function openOptionsMenu():void
		{
			options = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_GP;
			
			if (options) options.tweenIn();
			else
			{
				gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
				
				if (gpm.fileNameIndex > 0) world.add(new OptionsMenu_GP);
				else world.add(new OptionsMenu_GP(true)); // Room Tester
			}
			
			state = OPTIONS;
		}
		// ------------------------------------------------------------------------
		
		
		private function testing():void
		{
			test1();
		}
		
		private function test1():void
		{
			if (Input.pressed(Key.T)) trace(state);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}