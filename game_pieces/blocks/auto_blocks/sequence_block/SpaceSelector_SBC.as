package game_pieces.blocks.auto_blocks.sequence_block 
{
	import net.flashpunk.Entity;
	
	import net.jacob_stewart.EntityPlus;
	
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.space_selector.SpaceSelector;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceSelector_SBC extends SpaceSelector 
	{
		private var sbc:SequenceBlockCreator;
		
		private var reservedIndices:Array;
		private var qualifiedGridIndices:Array;
		private var pressedGridIndex:uint = 999;
		
		
		
		public function SpaceSelector_SBC() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			sbc = world.getInstance(Game.NAME_SequenceBlockCreator) as SequenceBlockCreator;
			
			
			reservedIndices = new Array;
			qualifiedGridIndices = new Array;
			
			setQualifiedGridIndices();
			addSpaceHighlights();
			// showOfferedSpaces( -3);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			Images.gamePieceOutline1.alpha = 1; // In case an Entity somewhere else in the game is using Images.gamePieceOutline1
			// showOfferedSpaces();
			
			sbc = null;
		}
		
		override public function update():void 
		{
			gs = collide(Game.TYPE_GridSpace, world.mouseX, world.mouseY) as GridSpace;
			
			if (gs) whenOverASpace();
			else whenNotOverASpace();
			
			
			super.update();
		}
		
		override public function whenOverASpace():void 
		{
			super.whenOverASpace();
			
			
			isQualifiedSpace = false;
			isQualifiedSpace = _isQualifiedSpace(gs);
		}
		
		override public function whenNotOverASpace():void 
		{
			super.whenNotOverASpace();
			
			
			isQualifiedSpace = false;
		}
		
		override public function onMousePressed():void 
		{
			pressedGridIndex = 999;
			
			if (gs)
			{
				if (_isQualifiedSpace(gs)) pressedGridIndex = gs.gridIndex;
			}
			
			
			// super.onMousePressed();
		}
		
		override public function onMouseDown():void 
		{
			// super.onMouseDown();
		}
		
		override public function onMouseReleased():void 
		{
			super.onMouseReleased();
			
			
			if (gs)
			{
				if (gs.gridIndex == pressedGridIndex)
				{
					Sounds.tick2();
					sbc.addSequenceIndex(pressedGridIndex);
					updateQualifiedGridIndices(pressedGridIndex);
				}
			}
		}
		
		public function _isQualifiedSpace(gs:GridSpace):Boolean
		{
			if (qualifiedGridIndices.indexOf(gs.gridIndex) != -1) return true;
			return false;
		}
		
		private function updateQualifiedGridIndices(gridIndex:uint):void
		{
			var gs:GridSpace;
			var count:uint = qualifiedGridIndices.length;
			
			for (var i:uint = 0; i < count; i++)
			{
				if (qualifiedGridIndices[i] == gridIndex)
				{
					gs = rd.gridSpaces[qualifiedGridIndices[i]];
					gs.setLayers();
					
					qualifiedGridIndices.splice(i, 1);
					i = count;
				}
			}
		}
		// ----------------------------------------------------------------------------------------
		
		
		private function addSpaceHighlights():void
		{
			var e:Entity;
			for (var i:uint = 0; i < qualifiedGridIndices.length; i++)
			{
				e = rd.gridSpaces[qualifiedGridIndices[i]];
				epAdd(new EntityPlus((e.x + Game.HALFSPACESIZE) - (Images.gamePieceOutline1.scaledWidth * .5), (e.y + Game.HALFSPACESIZE) - (Images.gamePieceOutline1.scaledHeight * .5), Images.gamePieceOutline1, sbc.screenTint.layer - 1));
				if (i == qualifiedGridIndices.length - 1) Images.gamePieceOutline1.alpha = .8;
			}
		}
		
		private function showOfferedSpaces(layerOffset:int = 0):void
		{
			var gs:GridSpace;
			for (var i:uint = 0; i < qualifiedGridIndices.length; i++)
			{
				gs = rd.gridSpaces[qualifiedGridIndices[i]];
				st = gs.collide(Game.TYPE_SwitchTile, gs.x, gs.y) as SwitchTile_RD;
				if (st) st.setStackOrder(layerOffset);
				else gs.setLayers(layerOffset);
			}
		}
		
		private function setQualifiedGridIndices():void
		{
			var qualTileTypes:Array = [0, 2, 3, 4];
			
			setReservedIndices();
			
			
			// Up
			if (sbc.gridIndex - Game.MAXCOLUMNCOUNT > -1) addIndex(sbc.gridIndex - Game.MAXCOLUMNCOUNT);
			
			// Right
			if ((sbc.gridIndex + 1) % Game.MAXCOLUMNCOUNT > 0) addIndex(sbc.gridIndex + 1);
			
			// Down
			if (sbc.gridIndex + Game.MAXCOLUMNCOUNT < Game.MAXCOLUMNCOUNT * Game.MAXROWCOUNT) addIndex(sbc.gridIndex + Game.MAXCOLUMNCOUNT);
			
			// Left
			if ((sbc.gridIndex + Game.MAXCOLUMNCOUNT) % Game.MAXCOLUMNCOUNT > 0) addIndex(sbc.gridIndex - 1);
			
			
			
			function addIndex(index:uint):void
			{
				gs = rd.gridSpaces[index];
				
				if (
					qualTileTypes.indexOf(gs.imgNum) != -1			// 1. The grid space's tile/block type must be a qualified type for a sequence move
					&& reservedIndices.indexOf(gs.gridIndex) == -1	// 2. The grid space isn't already being used by another SequenceBlock
					&& switchClientCheck()  						// 3. The grid space either does not contain a SwitchClient or its SwitchClient has a qualified state
					) qualifiedGridIndices.push(index);
			}
			
			function switchClientCheck():Boolean
			{
				if (gs.sc)
				{
					if (qualTileTypes.indexOf(gs.sc.activeNum) != -1) return true;
					if (qualTileTypes.indexOf(gs.sc.inactiveNum) != -1) return true;
					return false;
				}
				
				
				return true;
			}
		}
		
		private function setReservedIndices():void
		{
			var sb:SequenceBlock_RD;
			for (var i:uint = 0; i < rd.sequenceBlocks.length; i++)
			{
				sb = rd.sequenceBlocks[i];
				for (var j:uint = 0; j < sb.sequenceGridIndices.length; j++) reservedIndices.push(sb.sequenceGridIndices[j]);
			}
		}
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
	}

}