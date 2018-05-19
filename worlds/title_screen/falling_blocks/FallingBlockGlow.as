package worlds.title_screen.falling_blocks 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FallingBlockGlow extends EntityGame 
	{
		public var host:FallingBlock;
		private var img:Image = new Image(Images.FALLINGBLOCKGLOW);
		
		
		
		public function FallingBlockGlow() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			graphic = img;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			centerOnTarget(host);
			img.alpha = 1;
			tween = FP.tween(img, { alpha: 0 }, 1, { complete: recycleThis, ease: Ease.quintOut, tweener: this } );
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			if (tween) tween.cancel();
		}
		// ---------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------
		
	}

}