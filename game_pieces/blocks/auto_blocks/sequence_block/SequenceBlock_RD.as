package game_pieces.blocks.auto_blocks.sequence_block 
{
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SequenceBlock_RD extends SequenceBlock 
	{
		public var sequenceGridIndices:Array = new Array;
		
		
		
		public function SequenceBlock_RD(sequenceGridIndices:Array = null, gridIndex:uint = 999) 
		{
			this.sequenceGridIndices = sequenceGridIndices;
			
			
			super();
			
			
			this.gridIndex = gridIndex;
		}
		
		override public function init():void 
		{
			super.init();
			
			
			for (var i:uint = 0; i < sequenceGridIndices.length; i++) sequenceRoomIndices.push(sequenceGridIndices[i]);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			var rd:RoomDesigner = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			var gs:GridSpace = rd.gridSpaces[gridIndex];
			x = gs.x, y = gs.y;
			
			for (var j:uint = 0; j < 4; j++)
			{
				if (sequenceGridIndices.indexOf(999) != -1) sequenceGridIndices.splice(sequenceGridIndices.indexOf(999), 1);
			}
			
			for (var i:uint = 0; i < sequenceGridIndices.length; i++) epAdd(new SequenceNumberText(this, sequenceGridIndices[i], (i + 1).toString()));
		}
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
	}

}