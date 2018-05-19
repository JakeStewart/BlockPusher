package game_pieces.tiles.switch_tile 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import game_pieces.GamePieceOutline;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchOutline extends GamePieceOutline 
	{
		private var rd:RoomDesigner;
		private var color2:uint;
		private const DASH_LENGTH:uint = Math.round(Game.SPACESIZE * .3125); // 10
		private var dashThick:uint;
		
		private var offset:uint; // 12
		
		
		// For colorTesting()
		private var indices:Array = new Array;
		private var c1Index:uint = 0;
		private var c2Index:uint = 0;
		
		
		
		public function SwitchOutline(host:Entity, layerOffset:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, color2:uint = 0, alpha:Number=1) 
		{
			this.color2 = color2;
			
			
			super(host, layerOffset, scaleX, scaleY, color, alpha);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			
			offset = Math.round((image.width - DASH_LENGTH) / 2);
			dashThick = Math.round((image.width - Game.SPACESIZE) / 2);
			
			if (color2 != 0) addDashes();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// --------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
			// colorTesting();
		}
		
		private function updateVisible():void
		{
			visible = false;
			
			if (!rd.f4Info)
			{
				if (rd.f8Info || rd.ste.world) visible = true;
				
				if (rd.ss.st)
				{
					if (rd.ss.st.outlineColor == color && rd.ss.st.outlineColor2 == color2) visible = true;
				}
			}
		}
		// --------------------------------------------------------------------------------------------
		
		
		private function addDashes():void
		{
			var dash:Image;
			
			// Top
			dash = addGraphic(Image.createRect(DASH_LENGTH, dashThick, color2)) as Image;
			dash.x = offset;
			
			// Bottom
			dash = addGraphic(Image.createRect(DASH_LENGTH, dashThick, color2)) as Image;
			dash.x = offset, dash.y = image.height - dashThick;
			
			// Left
			dash = addGraphic(Image.createRect(dashThick, DASH_LENGTH, color2)) as Image;
			dash.y = offset;
			
			// Right
			dash = addGraphic(Image.createRect(dashThick, DASH_LENGTH, color2)) as Image;
			dash.x = image.width - dashThick, dash.y = offset;
		}
		// --------------------------------------------------------------------------------------------
		
		
		private function colorTesting():void
		{
			if (Input.pressed(Key.F) || Input.pressed(Key.D) || Input.pressed(Key.V) || Input.pressed(Key.C))
			{
				// Main color (color)
				if (Input.pressed(Key.F)) // Next
				{
					c1Index = nextIndex(c1Index);
					color = outlineColors[c1Index];
				}
				else if (Input.pressed(Key.D)) // Prev
				{
					c1Index = prevIndex(c1Index);
					color = outlineColors[c1Index];
				}
				
				// Dash color (color2)
				if (Input.pressed(Key.V)) // Next
				{
					c2Index = nextIndex(c2Index);
					color2 = outlineColors[c2Index];
				}
				else if (Input.pressed(Key.C)) // Prev
				{
					c2Index = prevIndex(c2Index);
					color2 = outlineColors[c2Index];
				}
				
				
				trace("c1Index:", c1Index, "- color:", color);
				trace("c2Index:", c2Index, "- color2:", color2);
				trace("---------------------------------------------");
			}
			
			if (Input.pressed(Key.P)) indices.push(c2Index);
			if (Input.pressed(Key.T)) trace("indices:", indices);
			
			
			
			function nextIndex(cIndex:uint):uint
			{
				cIndex++;
				if (cIndex > outlineColors.length - 1) cIndex = 0;
				
				return cIndex;
			}
			
			function prevIndex(cIndex:uint):uint
			{
				if (cIndex - 1 < 0) return outlineColors.length - 1;
				else return cIndex - 1;
			}
		}
		// --------------------------------------------------------------------------------------------
		
		
		/**
		 * A list of colors used for SwitchTile and SwitchClient outlines in RoomDesigner
		 */
		public static var outlineColors:Array = [0xff0000, 0xff7800, 0xf6ff00, 0x24ff00, 0x003cff, 0x8a00ff, 0xe400ff, 0xffffff, 0xfaabff, 0x295020, 0x00d2ff];
		
		/**
		 * A 2 dimensional array containing arrays of uint values that represent an index of 
		 * outlineColors. Each index value of the first dimension represents an 
		 * element of outlineColors.
		 */
		public static var dashColorIndexVals:Array = 
		[
			/*  0: 0xff0000 */	[2, 3, 4, 7, 9, 10],
			/*  1: 0xff7800 */	[2, 3, 4, 6, 7, 9, 10],
			/*  2: 0xf6ff00 */	[0, 1, 4, 6, 9, 10],
			/*  3: 0x24ff00 */	[0, 1, 4, 6, 9],
			/*  4: 0x003cff */	[0, 1, 2, 3, 6, 7, 8, 10],
			/*  5: 0x8a00ff */	[0, 1, 2, 3, 7, 8, 10],
			/*  6: 0xe400ff */	[2, 3, 4, 7, 8, 9, 10],
			/*  7: 0xffffff */	[0, 4, 6, 9, 10],
			/*  8: 0xfaabff */	[0, 2, 3, 4, 6, 7, 9],
			/*  9: 0x295020 */	[0, 1, 2, 3, 6, 7, 8, 10],
			/* 10: 0x00d2ff */	[0, 1, 2, 4, 6, 7, 9]
		];
		
		/**
		 * The maximum number of outline color combinations for SwitchTile/SwitchClient
		 */
		public static const MAX_OUTLINECOLORCOMBOS:uint = maxOutlineColorCombos();
		
		/**
		 * The maximum number of outline color combinations for SwitchTile/SwitchClient
		 * @return	The maximum number of outline color combinations for SwitchTile/SwitchClient
		 */
		public static function maxOutlineColorCombos():uint
		{
			var total:uint = outlineColors.length;
			for each (var list:Array in dashColorIndexVals) total += list.length;
			
			return total;
		}
		
		/**
		 * A color index list of all possible color combos
		 */
		public static var outlineColorCombos:Array = getOutlineColorCombos();
		
		/**
		 * Populates the outlineColorCombos Array
		 */
		public static function getOutlineColorCombos():Array
		{
			var combos:Array = new Array(maxOutlineColorCombos());
			
			for (var i:uint = 0; i < outlineColors.length; i++)
			{
				combos[i] = new Array(2);
				combos[i][0] = i, combos[i][1] = -1;
			}
			
			var index:uint = outlineColors.length;
			for (var j:uint = 0; j < dashColorIndexVals.length; j++)
			{
				for (var k:uint = 0; k < dashColorIndexVals[j].length; k++)
				{
					combos[index] = new Array(2);
					combos[index][0] = j, combos[index][1] = dashColorIndexVals[j][k];
					index++;
				}
			}
			
			
			return combos;
		}
		
		
		/**
		 * A color index list of all possible color combos
		 */
		public static var outlineColorCombos_Old1:Array = new Array(maxOutlineColorCombos());
		
		/**
		 * Populates the outlineColorCombos Array
		 */
		public static function setOutlineColorCombos_Old1():void
		{
			for (var i:uint = 0; i < outlineColors.length; i++)
			{
				outlineColorCombos[i] = new Array(2);
				outlineColorCombos[i][0] = outlineColors[i], outlineColorCombos[i][1] = -1;
			}
			
			var index:uint = outlineColors.length;
			for (var j:uint = 0; j < dashColorIndexVals.length; j++)
			{
				for (var k:uint = 0; k < dashColorIndexVals[j].length; k++)
				{
					outlineColorCombos[index] = new Array(2);
					outlineColorCombos[index][0] = outlineColors[j], outlineColorCombos[index][1] = dashColorIndexVals[j][k];
					index++;
				}
			}
		}
		
		
		/**
		 * A list of colors used for SwitchTile and SwitchClient outlines in RoomDesigner
		 */
		public static var outlineColors_Old1:Array = 
		[
		/* 1st choice */ 0xff0000, 0xff7800, 0xf6ff00, 0x24ff00, 0x00a2ff, 0x003cff, 0x8a00ff, 0xe400ff, 0xffffff,
		/* 2nd choice */ 0xf9bbfd, 0xffc000, 0xa8ff00, 0x00ffd8, 0x6600ff, 0xb400ff, 0xff0096,
		/* 3rd choice */ 0xd6a4a4, 0x295020, 0x00d2ff, 0x006cff, 0x3c00ff
		];
		
		/**
		 * A list of colors used for SwitchTile and SwitchClient outlines in RoomDesigner
		 */
		public static var dashColorIndexVals_Old1:Array = 
		[
			/* 0xff0000 */	[2, 3, 5, 8, 12],
			/* 0xff7800 */	[0, 2, 3, 5, 6, 7, 8, 12, 17],
			/* 0xf6ff00 */	[0, 1, 3, 5, 6, 7, 19],
			/* 0x24ff00 */	[0, 1, 5, 7, 19],
			/* 0x00a2ff */	[0, 1, 2, 3, 5, 7, 8, 9],
			/* 0x003cff */	[0, 1, 2, 3, 7, 8, 9, 12],
			/* 0x8a00ff */	[1, 2, 3, 8, 12],
			/* 0xe400ff */	[2, 3, 8, 12, 17, 20],
			/* 0xffffff */	[0, 1, 5, 7, 13, 15, 17, 19],
			/* 0xf9bbfd */	[0, 5, 7, 15, 17, 19],
			/* 0xffc000 */	[0, 4, 5, 7, 17],
			/* 0xa8ff00 */	[0, 1, 5, 7, 14, 17, 19],
			/* 0x00ffd8 */	[0, 1, 5, 7, 19],
			/* 0x6600ff */	[0, 1, 2, 3, 7, 8, 12, 18],
			/* 0xb400ff */	[1, 2, 3, 8, 11, 12, 17, 18],
			/* 0xff0096 */	[2, 3, 4, 5, 8, 12, 13, 17, 18],
			/* 0xd6a4a4 */	[0, 2, 3, 5, 6, 7, 8, 11, 12, 13, 14, 17, 19, 20],
			/* 0x295020 */	[0, 1, 2, 3, 7, 8, 9, 10, 11, 12, 15, 18],
			/* 0x00d2ff */	[0, 1, 2, 5, 7, 8, 13, 17, 19],
			/* 0x006cff */	[0, 1, 2, 3, 7, 8, 12],
			/* 0x3c00ff */	[0, 1, 2, 3, 7, 8, 9, 12]
		];
		// --------------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------------
		
	}

}