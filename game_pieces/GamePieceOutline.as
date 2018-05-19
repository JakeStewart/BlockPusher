package game_pieces 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ... 
	 * @author Jacob Stewart
	 */
	public class GamePieceOutline extends EntityGame 
	{
		public var image:Image = new Image(Images.GAMEPIECE_OUTLINE);
		public var host:Entity;
		public var layerOffset:int;
		public var scaleX:Number;
		public var scaleY:Number;
		public var color:uint;
		public var alpha:Number;
		
		
		
		public function GamePieceOutline(host:Entity, layerOffset:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, alpha:Number=1) 
		{
			this.host = host;
			this.layerOffset = layerOffset;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.color = color;
			this.alpha = alpha;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			image.scaleX = scaleX;
			image.scaleY = scaleY;
			image.color = color;
			image.alpha = alpha;
			graphic = image;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			centerOnPoint(image.width, image.height, host.x + Game.HALFSPACESIZE, host.y + Game.HALFSPACESIZE);
			layer = host.layer + layerOffset;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// --------------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------------
		
	}

}