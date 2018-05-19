package game_pieces.blocks.auto_blocks.sequence_block 
{
	import net.flashpunk.Entity;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SequenceNumberText extends TextPlus 
	{
		private var gridIndex:uint = 999;
		private var rd:RoomDesigner;
		private var host:EntityGame;
		
		
		
		public function SequenceNumberText(host:EntityGame, gridIndex:uint, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.host = host;
			// this.gridIndex = gridIndex; // resets to default value 999 in init() for some reason. This line needs to go after super()
			
			
			super(text, x, y, options, layer);
			
			
			this.gridIndex = gridIndex;
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SequenceNumberText;
			epSetHitbox(textWidth, textHeight);
			changeBackOffset(2);
			changeColor(Game.BLUECOLOR1);
		}
		
		override public function added():void 
		{
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			
			var e:Entity = rd.gridSpaces[gridIndex];
			centerOnPoint(textWidth, textHeight, e.x + Game.HALFSPACESIZE, e.y + Game.HALFSPACESIZE);
			
			
			super.added();
			
			
			epVisible(false);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			host = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			
			if (rd.ss.world) // While designing the room
			{
				if (rd.ss.gs) // While rd.ss.gs is colliding with mouse pointer
				{
					if (rd.ss.gs.gridIndex == host.gridIndex && !rd.f4Info) epVisible(true);
				}
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}