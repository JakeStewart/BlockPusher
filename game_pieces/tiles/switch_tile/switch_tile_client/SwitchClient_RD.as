package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.EntityPlus;
	
	import game_pieces.tiles.switch_tile.SwitchOutline;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchClient_RD extends SwitchClient 
	{
		private var rd:RoomDesigner;
		private var gs:GridSpace;
		
		private var outline:SwitchOutline;
		private var outlineColor:uint;
		private var outlineColor2:uint = 0;
		
		private var movesLeftText:MovesRemainingText_RD;
		
		private var highlightImg:Image = new Image(Images.BLOCKHIGHLIGHTER2);
		public var highlight:EntityPlus = new EntityPlus(0, 0, highlightImg);
		
		private const BASELAYER:int = -2;
		
		
		
		public function SwitchClient_RD() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			highlightImg.alpha = .6;
			movesLeftText = new MovesRemainingText_RD(this, "0");
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			
			highlight.x = x, highlight.y = y;
			
			outline = new SwitchOutline(this, 2, 1, 1, outlineColor, outlineColor2);
			epAdd(outline);
			
			epAdd(movesLeftText);
			
			if (rd.im.state == rd.im.STE) setStackOrder( -4);
			else setStackOrder(0);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			gs = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			
			/*
			public const HUB:uint = 0; // RoomDesigner
			public const OPTIONS:uint = 1; // OptionsMenu_RD
			public const NAMER:uint = 2; // RoomNamer
			public const NEWROOM:uint = 3; // NewRoom GUI
			public const ADDROOM:uint = 4; // AddRoom GUI
			public const SCC:uint = 5; // SwitchClientCreator_RD
			public const STE:uint = 6; // SwitchClientEditor
			public const BFC:uint = 7; // BFTileCreator
			*/
			
			
			
			graphic = Images.imgs[inactiveNum];
			
			switch (rd.im.state)
			{
				case rd.im.HUB:
					
					
					if (rd.ss.gs)
					{
						if (rd.ss.gs.gridIndex == hostGridIndex) graphic = Images.imgs[activeNum];
					}
					
					if (highlight.world) epRemove(highlight);
					
					break;
					
				case rd.im.STE:
					
					
					graphic = Images.imgs[activeNum];
					
					if (Input.mouseUp && highlight.world) epRemove(highlight);
					highlight.visible = false;
					
					if (layer < -2)
					{
						if (collideRect(x, y, rd.ste.ss.dragData[0], rd.ste.ss.dragData[1], rd.ste.ss.dragData[2], rd.ste.ss.dragData[3]) || collidePoint(x, y, world.mouseX, world.mouseY))
						{
							if (!highlight.world) epAdd(highlight);
							highlight.visible = true;
						}
						else if (highlight.world) epRemove(highlight);
					}
					
					break;
			}
		}
		
		override public function updateMovesLeftText(movesLeft:int):void 
		{
			super.updateMovesLeftText(movesLeft);
			
			
			this.movesLeft = movesLeft;
			
			var thisImg:Image = Images.imgs[activeNum];
			if (movesLeftText != null) movesLeftText.changeToText(movesLeft.toString());
		}
		
		public function setStackOrder(layerOffset:int):void
		{
			outline.layer = layerOffset + (BASELAYER + 2);
			
			layer = layerOffset + BASELAYER;
			highlight.layer =  layerOffset + BASELAYER;
			movesLeftText.changeLayer(layerOffset + BASELAYER);
		}
		// -------------------------------------------------------------------------------------------
		
		
		override public function _SwitchClient(x:Number = 0, y:Number = 0, activeNum:uint = 99, inactiveNum:uint = 99, gridIndex:uint = 0, hostGridIndex:uint = 0, roomIndex:uint = 999, hostRoomIndex:uint = 999, moves:int = 0, outlineIndex1:uint = 0, outlineIndex2:int = -1):SwitchClient 
		{
			outlineColor = SwitchOutline.outlineColors[outlineIndex1];
			if (outlineIndex2 != -1) outlineColor2 = SwitchOutline.outlineColors[outlineIndex2];
			else outlineColor2 = 0;
			
			
			return super._SwitchClient(x, y, activeNum, inactiveNum, gridIndex, hostGridIndex, roomIndex, hostRoomIndex, moves);
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
	}

}