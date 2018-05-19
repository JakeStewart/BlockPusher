package worlds.game_play 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	
	import collectables.Orb_GP;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_GP;
	import game_pieces.blocks.push_blocks.PushBlock;
	import game_pieces.blocks.push_blocks.move_arrows.MoveArrow;
	import game_pieces.tiles.switch_tile.SwitchTile_GP;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import worlds.WorldGame;
	import worlds.game_play.Room;
	import worlds.game_play.options_menu.OpenOptionsBtn_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GamePlayManager extends EntityGame 
	{
		public var room:Room;
		private var mp:MousePointer_GP = new MousePointer_GP([JS.TYPE_Button, JS.TYPE_TextButton, Game.TYPE_MoveArrow]);
		public var im:InputManager_GP = new InputManager_GP(mp);
		private var optionsBtn:OpenOptionsBtn_GP = new OpenOptionsBtn_GP(runOptionsMenu);
		private var screenTint:ScreenTint = new ScreenTint(Game.SCREENTINT_LAYER, .4);
		public var gameText:GamePlayText = new GamePlayText;
		
		public var fileNameIndex:uint;
		public var fileNamePrefix:String;
		public var movesMade:uint = 0;
		public var blockPendingMove:PushBlock = null;
		
		/**
		 * The number of rooms for either story mode or player designed
		 */
		private var roomCount:uint;
		
		
		
		public function GamePlayManager(fileNameIndex:uint = 1, fileNamePrefix:String = null) 
		{
			this.fileNameIndex = fileNameIndex;
			this.fileNamePrefix = fileNamePrefix;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_GamePlayManager;
			
			if (fileNamePrefix == RoomData.XMLFILEPREFIX && !Game.developer) roomCount = RoomData.roomDataClasses.length;
			else roomCount = RoomData.getRoomCount(fileNamePrefix);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([mp, im, gameText, optionsBtn]);
			newPuzzle();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			room = null;
			blockPendingMove = null;
		}
		// ------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			checkOutOfTime();
			// testing();
		}
		
		private function checkOutOfTime():void
		{
			if (im.state == im.IDLE || im.state == im.PENDINGMOVE)
			{
				room = world.getInstance(Game.NAME_Room) as Room;
				
				if (room)
				{
					if (room.roomTimer.timer.currentCount >= Game.MAXROOMTIME)
					{
						roomFailed(RoomFailedScreen.OUTOFTIME);
					}
				}
			}
		}
		// ------------------------------------------------------------------------
		
		
		private function setMoveArrowValues():void
		{
			room = world.getInstance(Game.NAME_Room) as Room;
			
			for each (var pushBlocks:Array in room.pushBlocks)
			{
				for each (var pb:PushBlock in pushBlocks)
				{
					if (pb.world) pb.setMoveArrowValues();
				}
			}
		}
		
		public function setBlockPendingMove(pb:PushBlock):void
		{
			if (pb != null)
			{
				epAdd(screenTint);
				world.bringToFront(screenTint);
			}
			else
			{
				if (blockPendingMove != null)
				{
					for each (var arrow:MoveArrow in blockPendingMove.arrows) arrow.deactivate();
				}
				
				epRemove(screenTint);
			}
			
			
			blockPendingMove = pb;
		}
		
		
		public function incrementMovesMade():void
		{
			movesMade++;
			gameText.updateMovesMadeNum(movesMade);
		}
		// ------------------------------------------------------------------------
		
		
		public function finishMove():void
		{
			room = world.getInstance(Game.NAME_Room) as Room;
			
			finishMovePhase1();
			if (room.sequenceBlocks.length > 0) finishMovePhase2();
			else finishMovePhase3();
		}
		
		private function finishMovePhase1():void
		{
			var pushBlocks:Array = room.pushBlocks[0].concat(room.pushBlocks[1]);
			for each (var pb:PushBlock in pushBlocks) pb.onFinishMove();
		}
		
		private function finishMovePhase2():void
		{
			var sb:SequenceBlock_GP;
			var movableSequenceBlocks:Array = new Array;
			for each (sb in room.sequenceBlocks)
			{
				if (sb.willMove()) movableSequenceBlocks.push(sb);
			}
			
			if (movableSequenceBlocks.length > 0)
			{
				for (var i:uint = 0; i < movableSequenceBlocks.length; i++)
				{
					sb = movableSequenceBlocks[i];
					if (i == movableSequenceBlocks.length - 1) sb.makeMove(true);
					else sb.makeMove();
				}
			}
			else finishMovePhase3();
		}
		
		public function finishMovePhase3():void
		{
			// Calls onFinishMove for all SwitchClients
			// More Blocks may fall in holes
			for (var i:uint = 0; i < room.spaces.length; i++)
			{
				if (room.spaces[i] is SwitchTile_GP)
				{
					var st:SwitchTile_GP = room.spaces[i];
					st.onFinishMove();
				}
			}
			
			
			// More Blocks may have fallen in holes
			if (room.pushBlocks[0].concat(room.pushBlocks[1]).length == 0) // All blocks have fallen in holes or off grid
			{
				roomFailed(RoomFailedScreen.NOBLOCKS);
			}
			else
			{
				setMoveArrowValues();
				room.blockHighlighter.onFinishMove();
				
				
				
				if (isCompletedRoom())
				{
					if (fileNameIndex > 0)
					{
						roomComplete();
						
						if (fileNameIndex == roomCount) fileNameIndex = 1;
						else fileNameIndex++;
					}
					else
					{
						FP.alarm(.4, newPuzzle); // RoomTester
					}
				}
				else if (movesMade >= Game.MAXGAMEMOVES)
				{
					roomFailed(RoomFailedScreen.TOOMANYMOVES);
				}
				else if (room.roomTimer.timer.currentCount >= Game.MAXROOMTIME)
				{
					roomFailed(RoomFailedScreen.OUTOFTIME);
				}
				else
				{
					im.state = im.IDLE;
				}
			}
		}
		// ------------------------------------------------------------------------
		
		
		private function isCompletedRoom():Boolean
		{
			// There are SwitchClients with hiddent goals
			if (room.goalIndices.length == 0) return false;
			
			
			var _blocks:Array = JS.getArrayAsFlat([room.pushBlocks, room.sequenceBlocks]);
			for (var i:uint = 0; i < room.goalIndices.length; i++)
			{
				if (!hasBlock(room.goalIndices[i])) return false;
			}
			
			
			
			return true;
			
			
			
			function hasBlock(roomIndexInCheck:uint):Boolean
			{
				for each (var block:EntityGame in _blocks)
				{
					if (block.roomIndex == roomIndexInCheck) return true;
				}
				
				return false;
			}
		}
		
		private function roomComplete():void
		{
			world.add(new RoomCompleteScreen(gameText.roomName.text, ((fileNameIndex - 1) / 10) + 1, ((fileNameIndex - 1) % 10) + 1, movesMade, room.roomTimer.timer.currentCount, orbsCollectedCount(), room.orbs.length, room.roomData[12], fileNameIndex));
		}
		
		private function roomFailed(reason:String):void
		{
			world.add(new RoomFailedScreen(reason, gameText.roomName.text, ((fileNameIndex - 1) / 10) + 1, ((fileNameIndex - 1) % 10) + 1, fileNameIndex));
		}
		// ------------------------------------------------------------------------
		
		
		public function newPuzzle():void
		{
			room = world.getInstance(Game.NAME_Room) as Room;
			
			if (room)
			{
				world.remove(room);
				FP.alarm(.8, newPuzzle);
			}
			else
			{
				world.add(new Room(fileNameIndex, fileNamePrefix));
				gameText.updateLevelOrRoomNum(fileNameIndex);
				gameText.updateMovesBestText(fileNameIndex);
				
				im.state = im.IDLE;
			}
		}
		// ------------------------------------------------------------------------
		
		
		public function roomGUIToggle(list:Array, state:Boolean):void
		{
			var ep:EntityPlus;
			for (var i:uint = 0; i < list.length; i++)
			{
				ep = list[i];
				ep.epCollidableAndVisible(state);
			}
		}
		
		private function runOptionsMenu():void
		{
			im.openOptionsMenu();
		}
		// -------------------------------------------------------------
		
		
		public function orbsCollectedCount():uint
		{
			var count:uint;
			var orb:Orb_GP;
			
			room = world.getInstance(Game.NAME_Room) as Room;
			for each (orb in room.orbs)
			{
				if (orb.collected) count++;
			}
			
			
			return count;
		}
		// -------------------------------------------------------------
		
		
		private function testing():void
		{
			test1();
		}
		
		private function test1():void
		{
			if (Input.pressed(Key.T))
			{
				room = world.getInstance(Game.NAME_Room) as Room;
				trace("room.active: ", room.active);
			}
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}