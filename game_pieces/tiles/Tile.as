package game_pieces.tiles 
{
	import net.flashpunk.Graphic;
	
	import game_pieces.GamePiece;
	import worlds.game_play.SpaceIndexText_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Tile extends GamePiece 
	{
		public var indexText:SpaceIndexText_GP;
		
		
		
		public function Tile(x:Number=0, y:Number=0, graphic:Graphic=null) 
		{
			super(x, y, graphic);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -1;
			graphic = img;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			if (indexText) epAdd(indexText);
		}
		// ---------------------------------------------------------------------------------------
		
		
		override public function _EntityGame(x:Number, y:Number, index:int = -1):EntityGame 
		{
			gridIndex = index;
			roomIndex = index;
			visible = true;
			
			indexText = new SpaceIndexText_GP(this, index);
			
			
			return super._EntityGame(x, y, roomIndex);
		}
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
	}

}