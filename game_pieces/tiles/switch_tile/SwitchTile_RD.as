package game_pieces.tiles.switch_tile 
{
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	import game_pieces.tiles.switch_tile.SwitchOutline;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchTile_RD extends SwitchTile 
	{
		private var rd:RoomDesigner;
		private var gs:GridSpace;
		
		private const BASELAYER:int = -2;
		
		private var clientGridIndices:Array = new Array;
		private var worldClients:Array = new Array;
		
		public var outlineColor:uint;
		public var outlineColor2:uint = 0;
		public var outlineIndices:Array = new Array(2);
		private var outline:SwitchOutline;
		
		private var highlightImg:Image = new Image(Images.BLOCKHIGHLIGHTER2);
		private var highlight:EntityPlus = new EntityPlus(0, 0, highlightImg);
		
		/**
		 * So that RoomDesigner.updateRoomData() isn't called in SwitchTile_RD.added()
		 * when multiple SwitchTile_RD's are added to the world on the same frame when 
		 * loading a room into RoomDesigner. RoomDesigner.updateRoomData() leads to 
		 * RoomData.saveRoomData() and slows the loading of a room in RoomDesigner when
		 * there are multiple SwitchTile_RD's.
		 */
		private var isSCEAdd:Boolean = false;
		
		
		
		public function SwitchTile_RD(x:Number=0, y:Number=0) 
		{
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
			layer = BASELAYER;
			
			highlight.layer = BASELAYER - 1;
			highlightImg.alpha = .6;
			highlight.visible = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			
			worldClients.length = 0;
			
			outline = new SwitchOutline(this, 2, 1, 1, outlineColor, outlineColor2);
			highlight.x = x, highlight.y = y;
			epAddList([outline, highlight]);
			
			getNewClients(clientGridIndices);
			if (isSCEAdd) rd.updateRoomData();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			gs = null;
			worldClients.length = 0;
		}
		// ----------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			highlight.x = x, highlight.y = y;
			highlightVisibility();
		}
		
		private function highlightVisibility():void
		{
			highlight.epVisible(false);
			
			if (rd.ste.world)
			{
				if (rd.ste.gridIndex == gridIndex)
				{
					if (collidePoint(x, y, world.mouseX, world.mouseY)) // If 'this' is colliding with the mouse
					{
						gs = rd.gridSpaces[gridIndex];
						if (x == gs.x && y == gs.y) highlight.epVisible(true);
					}
				}
			}
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function getNewClients(clientGridIndices:Array):void
		{
			worldClients.length = 0;
			world.getType(Game.TYPE_SwitchClient, worldClients);
			
			var sc:SwitchClient_RD;
			for (var i:uint = 0; i < clientGridIndices.length; i++)
			{
				for (var j:uint = 0; j < worldClients.length; j++)
				{
					sc = worldClients[j];
					if (clientGridIndices[i] == sc.gridIndex)
					{
						clients.push(sc);
						children.push(sc);
						j = worldClients.length;
					}
				}
			}
		}
		
		public function setStackOrder(layerOffset:int = 0):void
		{
			layer = BASELAYER + layerOffset;
			outline.layer = layer + 1; // Under SwitchTile
			highlight.layer = layer - 1; // Over SwitchTile
			world.bringToFront(this), world.bringToFront(highlight);
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function _SwitchTile_RD(x:Number, y:Number, gridIndex:uint, clientGridIndices:Array = null, outlineIndex1:uint = 0, outlineIndex2:int = -1, isSCEAdd:Boolean = false):SwitchTile_RD
		{
			this.isSCEAdd = isSCEAdd;
			
			this.x = x, this.y = y;
			this.gridIndex = gridIndex;
			
			outlineIndices[0] = outlineIndex1, outlineIndices[1] = outlineIndex2;
			
			outlineColor = SwitchOutline.outlineColors[outlineIndex1];
			if (outlineIndex2 != -1) outlineColor2 = SwitchOutline.outlineColors[outlineIndex2];
			else outlineColor2 = 0;
			
			for (var i:uint = 0; i < clientGridIndices.length; i++) this.clientGridIndices.push(clientGridIndices[i]);
			
			
			return this;
		}
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
	}

}