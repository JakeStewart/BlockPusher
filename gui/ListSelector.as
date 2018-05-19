package gui 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ListSelector extends EntityPlus 
	{
		public var size:uint;
		public var color:uint;
		
		public var alphaOffset:Number;
		private const ALPHA_FILL:Number = .4;
		private const ALPHA_OUTLINE:Number = .8;
		
		
		
		public function ListSelector(x:Number=0, y:Number=0, layer:int=0, size:uint=12, color:uint=0xFFFFFF, alphaOffset:Number=1) 
		{
			this.size = size;
			this.color = color;
			this.alphaOffset = alphaOffset;
			
			
			super(x, y, null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			// fill
			addGraphic(Image.createRect(size, size, color, ALPHA_FILL * alphaOffset));
			
			// outline
			var outline:Image;
			outline = addGraphic(new Image(Images.MENULISTSELECTOR_OUTLINE)) as Image;
			outline.alpha = ALPHA_OUTLINE * alphaOffset;
			outline.x = -1, outline.y = -1;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}