package game_pieces.blocks.auto_blocks.sequence_block 
{
	import net.flashpunk.Entity;
	
	import net.jacob_stewart.text.TextPlus;
	
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SequenceNumberText_GP extends TextPlus 
	{
		private var spaceNum:uint;
		private var sc:SwitchClient_GP;
		
		
		
		public function SequenceNumberText_GP(spaceNum:uint, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.spaceNum = spaceNum;
			
			
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -2;
			epSetHitbox(textWidth, textHeight);
			changeColor(Game.BLUECOLOR1);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			var room:Room = world.getInstance(Game.NAME_Room) as Room;
			var e:Entity = room.spaces[spaceNum];
			centerOnPoint(textWidth, textHeight, e.x + Game.HALFSPACESIZE, e.y + Game.HALFSPACESIZE);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			sc = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			visible = false;
			
			sc = collide(Game.TYPE_SwitchClient, x, y) as SwitchClient_GP;
			if (sc)
			{
				if (!sc.isActive) visible = true;
			}
			else visible = true;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}