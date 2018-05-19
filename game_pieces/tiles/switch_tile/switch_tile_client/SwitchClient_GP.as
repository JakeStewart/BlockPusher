package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_GP;
	import game_pieces.blocks.push_blocks.PushBlock;
	import game_pieces.blocks.push_blocks.PushBlockHitbox2;
	import game_pieces.tiles.switch_tile.SwitchTile_GP;
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchClient_GP extends SwitchClient 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		private var host:SwitchTile_GP;
		
		public var isActive:Boolean = false;
		public var isPendingActivation:Boolean = false;
		public var currentTypeNum:uint;
		private var activatedMoveNum:uint;
		
		private var movesLeftText:MovesRemainingText_GP;
		
		
		
		public function SwitchClient_GP() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			movesLeftText = new MovesRemainingText_GP(this, "0");
		}
		
		override public function setDefaults():void 
		{
			super.setDefaults();
			
			
			isActive = false;
			isPendingActivation = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
			
			epAdd(movesLeftText);
			
			// At the start of a room, if a block is on a Switch, the SwitchClient inactive
			// state will flash for one frame unless this line of code is here.
			setDefaults();
			host = room.spaces[hostRoomIndex];
			if (host.collideTypes([Game.TYPE_SequenceBlock, Game.TYPE_PushBlockHitbox2], host.x, host.y)) activate();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			host = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateGraphic();
			updateVisibility();
		}
		
		private function updateGraphic():void
		{
			graphic = Images.imgs[inactiveNum];
			if (isActive) graphic = Images.imgs[activeNum]; // When playing the room
		}
		
		private function updateVisibility():void
		{
			// For hole
			visible = true;
			if (isActive && activeNum == Game.ID_HOLE) visible = false;
			else if (!isActive && inactiveNum == Game.ID_HOLE) visible = false;
		}
		// -----------------------------------------------------------------------------
		
		
		public function activate():void
		{
			if (!isActive)
			{
				isActive = true;
				isPendingActivation = false;
				
				currentTypeNum = activeNum;
				
				activatedMoveNum = gpm.movesMade;
				movesLeft = moves;
				updateMovesLeftText(moves);
				
				if (inactiveNum == Game.ID_GOAL) room.goalIndices.splice(room.goalIndices.indexOf(roomIndex), 1);
				else if (activeNum == Game.ID_GOAL) room.goalIndices.push(roomIndex);
				
				// Check if a Block will fall in a hole
				if (activeNum == Game.ID_HOLE) blockFallInHole();
			}
		}
		
		private function deactivate():void
		{
			isActive = false;
			currentTypeNum = inactiveNum;
			
			if (activeNum == Game.ID_GOAL) room.goalIndices.splice(room.goalIndices.indexOf(roomIndex), 1);
			else if (inactiveNum == Game.ID_GOAL) room.goalIndices.push(roomIndex);
			
			
			// Check if a Block will fall in a hole
			if (inactiveNum == Game.ID_HOLE) blockFallInHole();
		}
		// -----------------------------------------------------------------------------
		
		
		public function onFinishMove():void
		{
			if (isActive && moves != SwitchClient.INFINITY_MOVES)
			{
				if (movesLeft > 0 && gpm.movesMade > activatedMoveNum) movesLeft--;
				if (movesLeft > 0) updateMovesLeftText(movesLeft);
				
				if (movesLeft == 0 && !collideBlock(host))
				{
					if (!collideBlock(this) || inactiveNum != Game.ID_WALL) deactivate();
				}
			}
		}
		
		private function collideBlock(e:EntityGame):EntityGame
		{
			return e.collideTypes([Game.TYPE_SequenceBlock, Game.TYPE_PushBlockHitbox2], e.x, e.y) as EntityGame;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function updateMovesLeftText(movesLeft:int):void 
		{
			super.updateMovesLeftText(movesLeft);
			
			
			movesLeftText.changeText(movesLeft.toString());
			movesLeftText.centerOnPoint(movesLeftText.textWidth, movesLeftText.textHeight, x + (width * .5), y + (height * .5));
		}
		// -----------------------------------------------------------------------------
		
		
		private function blockFallInHole():void
		{
			var e:EntityGame = collideBlock(this);
			if (e)
			{
				if (e is PushBlockHitbox2)
				{
					var hb2:PushBlockHitbox2 = e as PushBlockHitbox2;
					hb2.host.fallInHole();
				}
				else if (e is SequenceBlock_GP)
				{
					var sb:SequenceBlock_GP = e as SequenceBlock_GP;
					sb.fallInHole();
				}
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}