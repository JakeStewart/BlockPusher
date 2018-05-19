package game_pieces.blocks.push_blocks 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PushBlockMoveManager extends EntityGame 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		
		private var movingBlock:PushBlock;
		
		
		
		public function PushBlockMoveManager() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_PushBlockMoveManager;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			movingBlock = null;
		}
		// ----------------------------------------------------------------------------------
		
		
		public function makeMove(movingBlock:PushBlock, destinationCoords:Point, duration:Number):void
		{
			this.movingBlock = movingBlock;
			tweenBlock(movingBlock, destinationCoords.x, destinationCoords.y, duration, onFinishMove);
		}
		
		private function tweenBlock(block:PushBlock, toX:Number, toY:Number, duration:Number, onComplete:Function = null):void
		{
			FP.tween(block, { x: toX, y: toY }, duration, { complete: onComplete, ease: Game.PUSHBLOCK_MOVEEASE, tweener: block } );
			FP.tween(block.hb2, { x: toX, y: toY }, duration, { ease: Game.PUSHBLOCK_MOVEEASE, tweener: block.hb2 } );
		}
		// ----------------------------------------------------------------------------------
		
		
		private function onFinishMove():void
		{
			movingBlock.onFinishMove();
			
			
			var list:Array = getPendingMovePieces();
			if (list.length > 0)
			{
				var redBlock:RedBlock;
				var destinationCoord:Number;
				var onComplete:Function = null;
				
				for (var i:uint = 0; i < list.length; i++)
				{
					redBlock = list[i];
					
					if (i == list.length - 1) onComplete = gpm.finishMove;
					tweenBlock(redBlock, redBlock.homeCoords.x, redBlock.homeCoords.y, Game.PUSHBLOCK_MOVERATE, onComplete);
					
					redBlock.moveNum = 99;
					redBlock.roomIndex = redBlock.homeSpace;
				}
			}
			else if (room.pushBlocks[0].length == 0 && room.pushBlocks[1].length == 1)
			{
				// Check if there's no BlueBlocks and just 1 RedBlock left in the world.
				// If so, what happens when it makes a move, will it go back to homeSpace
				// w/out waiting for another Block to make a move?
				redBlock = room.pushBlocks[1][0];
				if (redBlock.roomIndex != redBlock.homeSpace)
				{
					tweenBlock(redBlock, redBlock.homeCoords.x, redBlock.homeCoords.y, Game.PUSHBLOCK_MOVERATE, gpm.finishMove);
					redBlock.roomIndex = redBlock.homeSpace;
				}
				else gpm.finishMove();
			}
			else gpm.finishMove();
		}
		// ----------------------------------------------------------------------------------
		
		
		private function getPendingMovePieces():Array
		{
			var list:Array = new Array;
			var redBlock:RedBlock;
			
			for (var i:uint = 0; i < room.pushBlocks[1].length; i++)
			{
				redBlock = room.pushBlocks[1][i];
				if (!redBlock.willFallinHole && !redBlock.willFallOffGrid)
				{
					if (redBlock.moveNum < gpm.movesMade && homeSpaceIsClear(redBlock)) list.push(redBlock);
				}
			}
			
			
			return list;
		}
		
		private function homeSpaceIsClear(redBlock:RedBlock):Boolean
		{
			for each (var pb:PushBlock in room.pushBlocks[0].concat(room.pushBlocks[1]))
			{
				if (pb.roomIndex == redBlock.homeSpace) return false;
			}
			
			return true;
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}