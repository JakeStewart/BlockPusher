package game_pieces.blocks.push_blocks 
{
	import net.flashpunk.graphics.Image;
	
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PushBlockHighlighter extends EntityGame 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		
		private var image:Image = new Image(Images.BLOCKHIGHLIGHTER);
		
		private var highlightedBlock:PushBlock;
		public var movedHistory:Array = new Array;
		
		private var _blocks:Array = new Array;
		
		private var highlightList_Hor:Array = new Array;
		private var highlightList_Ver:Array = new Array;
		
		private var visibleStates:Array = new Array;
		
		
		
		public function PushBlockHighlighter() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_PushBlockHighlighter;
			layer = -2;
			graphic = image;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
			
			visibleStates.push(gpm.im.IDLE);
			
			if (room.pushBlocks[0].length > 0) highlightedBlock = room.pushBlocks[0][0];
			else highlightedBlock = room.pushBlocks[1][0];
			setPosition();
			refreshHighlightLists();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			highlightedBlock = null;
			movedHistory.length = 0;
			_blocks.length = 0;
			highlightList_Hor.length = 0;
			highlightList_Ver.length = 0;
		}
		// ------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisibility();
		}
		
		private function updateVisibility():void
		{
			visible = false;
			if (visibleStates.indexOf(gpm.im.state) != -1) visible = true;
		}
		// ------------------------------------------------------------------------
		
		
		public function selectBlock():void
		{
			highlightedBlock.toggleSelectBlock();
		}
		// ------------------------------------------------------------------------
		
		
		// When a move is done, should the next highlighted block default to the 
		// lastMovedBlue or the lastMoved? (Which could be a Red)
		// Have an array with a history of blocks that were moved so if a Red is
		// moved, then another Red, there's something to tell what the moved Red
		// before the lastMovedRed was
		public function onFinishMove():void
		{
			refreshBlocks();
			updateMovedHistory();
			highlightedBlock = getNextHighlightedBlock();
			setPosition();
			refreshHighlightLists();
		}
		
		private function refreshBlocks():void
		{
			_blocks.length = 0;
			_blocks = room.pushBlocks[0].concat(room.pushBlocks[1]);
		}
		
		private function updateMovedHistory():void
		{
			for each (var block:PushBlock in movedHistory)
			{
				if (!block.world) movedHistory.splice(movedHistory.indexOf(block), 1);
			}
		}
		
		private function getNextHighlightedBlock():PushBlock
		{
			var block:PushBlock;
			
			
			if (_blocks.length == 1) return _blocks[0];
			
			if (movedHistory.length > 0)
			{
				for (var i:int = 0; i < movedHistory.length; i++)
				{
					block = movedHistory[i];
					
					if (block is BlueBlock) return block; // Blue
					else if (block is RedBlock && block.roomIndex == block.homeSpace) return block; // Red
				}
			}
			
			if (room.pushBlocks[0].length > 0) return room.pushBlocks[0][0]; // Blue
			else return room.pushBlocks[1][0]; // Red
			
			
			return null;
		}
		// ------------------------------------------------------------------------
		
		
		
		private function refreshHighlightLists():void
		{
			refreshBlocks();
			filterMovedReds();
			highlightList_Hor.length = 0, highlightList_Ver.length = 0;
			
			if (_blocks.length == 1)
			{
				highlightList_Hor.length = 1, highlightList_Ver.length = 1;
				highlightList_Hor[0] = _blocks[0], highlightList_Ver[0] = _blocks[0];
			}
			else
			{
				highlightList_Hor.length = _blocks.length, highlightList_Ver.length = _blocks.length;
				
				var blocksCopy:Array = _blocks.concat();
				var control:PushBlock;
				var canidate:PushBlock;
				var index:uint;
				
				for (var i:uint = 0; i < _blocks.length; i++)
				{
					index = getNextIndex_Hor();
					highlightList_Hor[i] = _blocks[_blocks.indexOf(blocksCopy[index])];
					blocksCopy.splice(blocksCopy.indexOf(blocksCopy[index]), 1);
				}
				
				
				blocksCopy = _blocks.concat();
				
				for (var j:uint = 0; j < _blocks.length; j++)
				{
					index = getNextIndex_Ver();
					highlightList_Ver[j] = _blocks[_blocks.indexOf(blocksCopy[index])];
					blocksCopy.splice(blocksCopy.indexOf(blocksCopy[index]), 1);
				}
			}
			
			
			
			function getNextIndex_Hor():uint
			{
				var index:uint = 0;
				control = blocksCopy[0];
				
				for (var k:uint = 0; k < blocksCopy.length; k++)
				{
					canidate = blocksCopy[k];
					
					if (
						canidate.x < control.x ||
						(canidate.x == control.x && canidate.y < control.y)
						) control = blocksCopy[k], index = k;
				}
				
				return index;
			}
			
			function getNextIndex_Ver():uint
			{
				var index:uint = 0;
				control = blocksCopy[0];
				
				for (var k:uint = 0; k < blocksCopy.length; k++)
				{
					canidate = blocksCopy[k];
					
					if (
						canidate.y < control.y ||
						(canidate.y == control.y && canidate.x < control.x)
						) control = blocksCopy[k], index = k;
				}
				
				return index;
			}
		}
		
		public function changeBlock(dirVal:uint):void
		{
			if (_blocks.length > 1)
			{
				switch (dirVal)
				{
					case 0: // UP
						
						if (highlightList_Ver.indexOf(highlightedBlock) - 1 < 0) highlightedBlock = highlightList_Ver[highlightList_Ver.length - 1];
						else highlightedBlock = highlightList_Ver[highlightList_Ver.indexOf(highlightedBlock) - 1];
						
						
						break;
						
					case 1: // RIGHT
						
						if (highlightList_Hor.indexOf(highlightedBlock) + 1 == highlightList_Hor.length) highlightedBlock = highlightList_Hor[0];
						else highlightedBlock = highlightList_Hor[highlightList_Hor.indexOf(highlightedBlock) + 1];
						
						
						break;
						
					case 2: // DOWN
						
						if (highlightList_Ver.indexOf(highlightedBlock) + 1 == highlightList_Ver.length) highlightedBlock = highlightList_Ver[0];
						else highlightedBlock = highlightList_Ver[highlightList_Ver.indexOf(highlightedBlock) + 1];
						
						
						break;
						
					case 3: // LEFT
						
						if (highlightList_Hor.indexOf(highlightedBlock) - 1 < 0) highlightedBlock = highlightList_Hor[highlightList_Hor.length - 1];
						else highlightedBlock = highlightList_Hor[highlightList_Hor.indexOf(highlightedBlock) - 1];
						
						
						break;
				}
				
				
				Sounds.tick3();
			}
			else highlightedBlock = _blocks[0];
			
			
			setPosition();
		}
		
		private function filterMovedReds():void
		{
			for each (var redBlock:RedBlock in room.pushBlocks[1])
			{
				if (redBlock.roomIndex != redBlock.homeSpace) _blocks.splice(_blocks.indexOf(redBlock), 1);
			}
		}
		// ------------------------------------------------------------------------
		
		
		private function setPosition():void
		{
			x = highlightedBlock.x + Game.HALFSPACESIZE - (image.width * .5);
			y = highlightedBlock.y + Game.HALFSPACESIZE - (image.height * .5);
		}
		
		
		public function setSelectedBlock(block:PushBlock):void
		{
			highlightedBlock = block;
			setPosition();
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}