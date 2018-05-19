package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceNumberText;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MovesRemainingText_RD extends MovesRemainingText 
	{
		private var rd:RoomDesigner;
		private var host:SwitchClient_RD;
		private var infinityIcon:InfinityIcon;
		private var sequenceNumberText:SequenceNumberText;
		
		
		
		public function MovesRemainingText_RD(host:SwitchClient_RD, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.host = host;
			
			
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeAlpha(NaN, .5);
			visible = false;
			infinityIcon = new InfinityIcon(host);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			if (host.moves == -1) changeToInfinityIcon();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			host = null;
			sequenceNumberText = null;
		}
		// ----------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			
			if (!rd.f4Info)
			{
				if (rd.ste.world) epVisible(true);
				else
				{
					sequenceNumberText = host.collide(Game.TYPE_SequenceNumberText, host.x, host.y) as SequenceNumberText;
					if (sequenceNumberText)
					{
						if (!sequenceNumberText.visible && rd.f8Info) epVisible(true);
					}
					else if (rd.f8Info) epVisible(true);
				}
				
				if (rd.ss.gs)
				{
					// For when !rd.f8Info
					if (rd.ss.gs.gridIndex == host.hostGridIndex) epVisible(true);
				}
			}
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function changeLayer(layer:int):void 
		{
			this.layer = layer;
			infinityIcon.layer = layer;
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function changeToText(text:String):void
		{
			if (infinityIcon.world) epRemove(infinityIcon);
			
			changeAlpha(1, 1);
			changeText(text);
			centerOnPoint(textWidth, textHeight, host.x + Game.HALFSPACESIZE, host.y + Game.HALFSPACESIZE);
		}
		
		private function changeToInfinityIcon():void
		{
			changeAlpha(0, 0);
			epAdd(infinityIcon);
		}
		// ----------------------------------------------------------------------------------------
		
	}

}