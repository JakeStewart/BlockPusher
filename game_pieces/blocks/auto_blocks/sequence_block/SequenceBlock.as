package game_pieces.blocks.auto_blocks.sequence_block 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * 
	 * 
	 * SequenceBlock will move one space after the user has made a move.
	 * 
	 * - Has a home space
	 * - Upon user move completion: 
		 * if on home space, moves one space away from home space
		 * if not on home space, moves back to home space
	 * - Can move up, down, left, or right from home space
	 * - Spaces it moves to are in sequence, not random
	 * 
	 */
	public class SequenceBlock extends EntityGame 
	{
		public var homeSpaceNum:uint;
		public var sequenceRoomIndices:Array = new Array;
		
		
		
		public function SequenceBlock() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SequenceBlock;
			layer = Game.PUSHBLOCK_LAYER;
			graphic = Images.sequenceBlockImg;
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}