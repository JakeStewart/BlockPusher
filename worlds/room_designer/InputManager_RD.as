package worlds.room_designer 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlockCreator;
	import worlds.room_designer.gold_medal_moves.SetGoldMedalMoves;
	import worlds.room_designer.new_room.NewRoom;
	import worlds.room_designer.options_menu.OptionsMenu_RD;
	import worlds.room_designer.room_namer.RoomNamer;
	import worlds.room_designer.saving.AddRoomToPlaylist;
	import worlds.room_designer.switch_tile_editor.SwitchTileEditor;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class InputManager_RD extends InputManager 
	{
		private var rd:RoomDesigner;
		private var optionsMenu:OptionsMenu_RD;
		private var roomNamer:RoomNamer;
		private var newRoom:NewRoom;
		private var addRoom:AddRoomToPlaylist;
		private var ste:SwitchTileEditor;
		private var sbc:SequenceBlockCreator;
		private var setGoldMedalMoves:SetGoldMedalMoves;
		
		public const HUB:uint = 0; 		// RoomDesigner
		public const OPTIONS:uint = 1; 	// OptionsMenu_RD
		public const NAMER:uint = 2; 	// RoomNamer
		public const NEWROOM:uint = 3; 	// NewRoom GUI
		public const ADDROOM:uint = 4; 	// AddRoom GUI
		public const STE:uint = 5; 		// SwitchTileEditor
		public const SBC:uint = 6; 		// SequenceBlockCreator
		public const MEDAL:uint = 7; 	// SetGoldMedalMoves
		public var state:int = HUB;
		
		
		
		public function InputManager_RD(mp:MousePointerGame, rd:RoomDesigner) 
		{
			this.rd = rd;
			
			
			super(mp);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			optionsMenu = null;
			roomNamer = null;
			newRoom = null;
			addRoom = null;
			ste = null;
			sbc = null;
			setGoldMedalMoves = null;
		}
		
		override public function keyboard():void 
		{
			if (Input.pressed(Key.ANY)) keyPressed(Input.lastKey);
			// check: TAB, SHIFT
			// pressed: CONTROL, X, Z, S, A, Numerical keys
		}
		// -----------------------------------------------------------------------------
		
		
		private function keyPressed(key:int):void
		{
			switch (state)
			{
				case HUB:
					
					
					if (Input.check(Key.CONTROL) && !Input.mouseDown)
					{
						
					}
					else if (Input.pressed(Key.ESCAPE) && !Input.mouseDown) rd.runOptionsMenu();
					else if (Input.pressed(Keys.RD_INFO_TOGGLE)) rd.toggleInfo(Input.pressed(Key.F4), Input.pressed(Key.F8));
					else if (Input.pressed(Key.N)) rd.roomNamerBtn.click();
					
					break;
					
				case OPTIONS:
					
					optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_RD;
					
					if (optionsMenu)
					{
						if (Input.pressed(Keys.SELECT)) optionsMenu.optionSelected();
						else if (Input.pressed(Keys.CANCEL)) optionsMenu.exit();
						else if (Input.pressed(Keys.DIR))
						{
							if (Input.pressed(Keys.VER) && optionsMenu.state != optionsMenu.STATE_TWEENING) optionsMenu.selector.changeSelection(key);
							else if (Input.pressed(Keys.HOR)) optionsMenu.changeSetting(key);
						}
					}
					
					
					break;
					
				case NAMER:
					
					roomNamer = world.getInstance(Game.NAME_RoomNamer) as RoomNamer;
					
					if (roomNamer)
					{
						if (Input.pressed(Key.ENTER)) roomNamer.finishNaming();
						if (Input.pressed(Key.ESCAPE)) roomNamer.cancelNaming();
						if (Input.pressed(Key.ANY) && roomNamer.isQualifiedKey(Input.lastKey)) roomNamer.updateName();
					}
					
					
					break;
					
				case NEWROOM:
					
					newRoom = world.getInstance(Game.NAME_NewRoom) as NewRoom;
					
					if (newRoom) newRoom.keyPressed();
					
					
					break;
					
				case ADDROOM:
					
					addRoom = world.getInstance(Game.NAME_AddRoomToPlaylist) as AddRoomToPlaylist;
					
					if (addRoom)
					{
						if (Input.pressed(Keys.SELECT)) addRoom.addRoom();
						else if (Input.pressed(Key.ESCAPE)) addRoom.cancelAddRoom();
					}
					
					
					break;
					
				case STE:
					
					sccInput(key);
					
					
					break;
					
				case SBC:
					
					sbc = world.getInstance(Game.NAME_SequenceBlockCreator) as SequenceBlockCreator;
					
					if (sbc)
					{
						if (Input.pressed(Key.ESCAPE)) sbc.cancelCreator();
						else if (Input.pressed(Keys.SELECT)) sbc.finishCreating();
					}
					
					
					break;
					
				case MEDAL:
					
					setGoldMedalMoves = world.getInstance(Game.NAME_SetGoldMedalMoves) as SetGoldMedalMoves;
					
					if (setGoldMedalMoves)
					{
						if (Input.pressed(Keys.SELECT)) setGoldMedalMoves.confirmChange();
						if (Input.pressed(Key.ESCAPE)) setGoldMedalMoves.cancelChange();
						if (Input.pressed(Keys.NUMERIC) || Input.pressed(Key.BACKSPACE)) setGoldMedalMoves.updateMoves(Input.lastKey);
					}
					
					
					break;
			}
		}
		// ------------------------------------------------------------------------
		
		
		private function sccInput(key:int):void
		{
			ste = world.getInstance(Game.NAME_SwitchTileEditor) as SwitchTileEditor;
			
			if (ste)
			{
				if (Input.pressed(Keys.SELECT) && !Input.mouseDown) ste.finishEditing();
				else if (Input.pressed(Key.ESCAPE) && !Input.mouseDown) ste.cancelCreator();
				else if (Input.pressed(Keys.DIR))
				{
					
				}
			}
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}