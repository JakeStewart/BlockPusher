package worlds.room_designer 
{
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AutoDesign extends EntityGame 
	{
		private var rd:RoomDesigner;
		private var gs:GridSpace;
		
		// coorisponding elements in rowCounts & columnCounts refer to 
		// the column count and row count of each land mass
		private var rowCounts:Array = new Array;
		private var columnCounts:Array = new Array;
		
		private const XTRA_LAND_MASS_CHANCE:uint = 15;
		
		
		
		public function AutoDesign() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			a1();
		}
		// ------------------------------------------------------------------------------------------------
		
		
		private function a1():void
		{
			columnCounts.push(FP.rand(Game.MAXCOLUMNCOUNT) + 1);
			rowCounts.push(FP.rand(Game.MAXROWCOUNT) + 1);
			
			newLandMass();
			fillTiles();
			rd.updateRoomData();
		}
		// ------------------------------------------------------------------------------------------------
		
		
		private function fillTiles():void
		{
			const STARTSPACENUM:uint = 0;
			var spaceNum:uint = STARTSPACENUM;
			
			for (var i:uint = 0; i < rowCounts[0]; i++)
			{
				for (var j:uint = 0; j < columnCounts[0]; j++)
				{
					gs = rd.gridSpaces[spaceNum];
					gs.imgNum = 0, gs.imgIndexHistory.push(gs.imgNum);
					gs.graphic = Images.imgs[gs.imgNum], gs.state0Alpha = 0;
					
					spaceNum++;
				}
				
				
				spaceNum = STARTSPACENUM + (Game.MAXCOLUMNCOUNT * (i + 1));
			}
		}
		// ------------------------------------------------------------------------------------------------
		
		
		private function newLandMass():void
		{
			if (columnCounts[0] < Game.MAXCOLUMNCOUNT - 1 || rowCounts[0] < Game.MAXROWCOUNT - 1)
			{
				if (FP.rand(XTRA_LAND_MASS_CHANCE) == 0)
				{
					if (columnCounts[0] < Game.MAXCOLUMNCOUNT - 1 && rowCounts[0] < Game.MAXROWCOUNT - 1)
					{
						if (FP.rand(2) == 0) // next land mass will be to the left or right of the first land mass
						{
							newLandMassDimensions(columnCounts, Game.MAXCOLUMNCOUNT, rowCounts, Game.MAXROWCOUNT);
						}
						else // next land mass will be above or below the first land mass
						{
							newLandMassDimensions(rowCounts, Game.MAXROWCOUNT, columnCounts, Game.MAXCOLUMNCOUNT);
						}
					}
					else if (columnCounts[0] < Game.MAXCOLUMNCOUNT - 1)  // next land mass will be to the left or right of the first land mass
					{
						newLandMassDimensions(columnCounts, Game.MAXCOLUMNCOUNT, rowCounts, Game.MAXROWCOUNT);
					}
					else if (rowCounts[0] < Game.MAXROWCOUNT - 1) // next land mass will be above or below the first land mass
					{
						newLandMassDimensions(rowCounts, Game.MAXROWCOUNT, columnCounts, Game.MAXCOLUMNCOUNT);
					}
				}
			}
			
			
			function newLandMassDimensions(aList:Array, aMax:uint, bList:Array, bMax:uint):void
			{
				aList.push(FP.rand(aMax - aList[0] - 1) + 1);
				bList.push(FP.rand(bMax) + 1);
			}
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
	}

}