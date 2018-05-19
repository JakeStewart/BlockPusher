package worlds.room_designer.space_selector 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpacesSelectorGamePiece extends EntityGame 
	{
		public var image:Image;
		public var imageIndex:uint;
		
		
		
		public function SpacesSelectorGamePiece(imageIndex:uint) 
		{
			this.imageIndex = imageIndex;
			
			
			super(0, 0, null, Game.SPACESELECTOR_LAYER);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SpacesSelectorGamePiece;
			image = new Image(Images.gamePieceSourceImages[imageIndex]);
			graphic = image;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}