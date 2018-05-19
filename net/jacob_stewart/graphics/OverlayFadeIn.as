package net.jacob_stewart.graphics 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.JS;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OverlayFadeIn extends Entity 
	{
		private var duration:Number;
		private var color:uint = Game.SCREENCOLOR;
		private var onComplete:Function;
		
		
		
		public function OverlayFadeIn(duration:Number, onComplete:Function=null, color:uint=0, layer:Number=NaN) 
		{
			this.duration = duration;
			this.onComplete = onComplete;
			if (color == 0) this.color = 0x000000;
			else this.color = color;
			if (isNaN(layer)) this.layer = FP.world.layerNearest - 1;
			else this.layer = new int(layer);
			
			init();
		}
		
		public function init():void 
		{
			type = JS.TYPE_OverlayFadeIn;
			name = JS.NAME_OverlayFadeIn;
			graphic = Image.createRect(FP.width, FP.height, color, 0);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			FP.tween(graphic as Image, { alpha: 1 }, duration, { complete: onComplete, tweener: this } );
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}