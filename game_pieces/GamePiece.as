package game_pieces 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GamePiece extends EntityGame 
	{
		public var img:Image = new Image(Images.BLOCK1);
		
		
		
		public function GamePiece(x:Number=0, y:Number=0, graphic:Graphic=null) 
		{
			super(x, y, graphic);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -2;
		}
		// ------------------------------------------------------------------------------
		
		
		override public function _EntityGame(x:Number, y:Number, spaceNum:int = -1):EntityGame 
		{
			gridIndex = spaceNum;
			roomIndex = spaceNum;
			
			
			return super._EntityGame(x, y, spaceNum);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}