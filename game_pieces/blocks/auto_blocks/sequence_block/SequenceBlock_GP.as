package game_pieces.blocks.auto_blocks.sequence_block 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	import game_pieces.tiles.hole_tile.HoleTile;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SequenceBlock_GP extends SequenceBlock 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		private var switchClients:Array;
		private var sequenceIndex:uint = 0;
		private var lastToMove:Boolean = false;
		
		
		
		public function SequenceBlock_GP(homeSpaceNum:uint, sequenceRoomIndices:Array = null) 
		{
			this.homeSpaceNum = homeSpaceNum;
			
			
			super();
			
			
			this.sequenceRoomIndices = sequenceRoomIndices;
		}
		
		override public function init():void 
		{
			super.init();
			
			
			roomIndex = homeSpaceNum;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
			
			x = room.spaces[homeSpaceNum].x;
			y = room.spaces[homeSpaceNum].y;
			
			for (var j:uint = 0; j < 4; j++)
			{
				if (sequenceRoomIndices.indexOf(999) != -1) sequenceRoomIndices.splice(sequenceRoomIndices.indexOf(999), 1);
			}
			
			var sequenceTextList:Array = new Array(sequenceRoomIndices.length);
			for (var i:uint = 0; i < sequenceRoomIndices.length; i++) sequenceTextList[i] = new SequenceNumberText_GP(sequenceRoomIndices[i], (i + 1).toString());
			
			epAddList(sequenceTextList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			switchClients.length = 0;
		}
		// ------------------------------------------------------------------------------------------
		
		
		public function makeMove(lastToMove:Boolean = false):void
		{
			this.lastToMove = lastToMove;
			var toX:Number = x;
			var toY:Number = y;
			
			
			if (roomIndex == homeSpaceNum) // will move to a sequence space
			{
				roomIndex = sequenceRoomIndices[sequenceIndex];
				setToCoords(roomIndex);
				
				sequenceIndex++;
				if (sequenceIndex > sequenceRoomIndices.length - 1) sequenceIndex = 0;
			}
			else // will move to home space
			{
				setToCoords(homeSpaceNum);
				roomIndex = homeSpaceNum;
			}
			
			
			FP.tween(this, { x: toX, y: toY }, Game.PUSHBLOCK_MOVERATE, { complete: onTweenComplete, ease: Game.PUSHBLOCK_MOVEEASE, tweener: this } );
			
			
			function setToCoords(spaceIndex:uint):void
			{
				if (room.spaces[homeSpaceNum].x == room.spaces[roomIndex].x) toY = room.spaces[spaceIndex].y;
				else toX = room.spaces[spaceIndex].x;
			}
		}
		
		public function willMove():Boolean
		{
			if (sequenceRoomIndices.length > 0) // It's possible no sequence indices were added
			{
				switchClients = new Array;
				world.getClass(SwitchClient_GP, switchClients);
				var space:Entity;
				
				// Determine what the next move-to space will be
				if (roomIndex == homeSpaceNum) space = room.spaces[sequenceRoomIndices[sequenceIndex]];
				else space = room.spaces[homeSpaceNum];
				
				// Check if a SequenceBlock or a Block is on the move to tile
				if (space.collideTypes([Game.TYPE_SequenceBlock, Game.TYPE_PushBlockHitbox2], space.x, space.y)) return false;
				
				
				
				// Check if the move-to space is a SwitchClient & if it's in an obstructed state
				if (roomIndex == homeSpaceNum) // will be moving to a sequence space
				{
					var unobstructedTypeNums:Array = [Game.ID_FLOOR, Game.ID_GOAL, Game.ID_HOLE];
					var sc:SwitchClient_GP;
					
					for (var i:uint = 0; i < switchClients.length; i++)
					{
						sc = switchClients[i];
						if (sc.roomIndex == sequenceRoomIndices[sequenceIndex])
						{
							if (unobstructedTypeNums.indexOf(sc.currentTypeNum) == -1) return false;
							else i = switchClients.length;
						}
					}
				}
				
				
				return true;
			}
			
			
			return false;
		}
		// ------------------------------------------------------------------------------------------
		
		
		private function onTweenComplete():void
		{
			if (willFallInHole()) fallInHole();
			if (lastToMove)
			{
				lastToMove = false;
				gpm.finishMovePhase3();
			}
		}
		
		private function willFallInHole():Boolean
		{
			if (room.spaces[roomIndex] is HoleTile) return true;
			
			if (room.spaces[roomIndex] is SwitchClient_GP)
			{
				var sc:SwitchClient_GP = room.spaces[roomIndex];
				if (sc.currentTypeNum == Game.ID_HOLE) return true;
			}
			
			
			return false;
		}
		
		public function fallInHole():void
		{
			room.sequenceBlocks.splice(room.sequenceBlocks.indexOf(this), 1);
			removeThis();
		}
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
	}

}