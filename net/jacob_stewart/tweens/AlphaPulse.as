package net.jacob_stewart.tweens 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AlphaPulse extends Entity
	{
		private var image:Image;
		private var alphaHigh:Number;
		private var alphaLow:Number;
		private var duration:Number;
		private var limit:int;
		private var ease:Ease;
		private var delay:Number;
		
		private var count:int;
		private var alphaTo:Number;
		private var tween:Tween;
		
		
		
		public function AlphaPulse(image:Image, alphaHigh:Number = 1, alphaLow:Number = 0, duration:Number = 1, limit:int = -1, ease:Ease = null, delay:Number = 0)
		{
			this.image = image;
			this.alphaHigh = alphaHigh;
			this.alphaLow = alphaLow;
			this.duration = duration;
			this.limit = limit;
			this.ease = ease;
			this.delay = delay;
		}
		
		override public function added():void 
		{
			if (image.alpha == alphaLow || image.alpha == alphaHigh)
			{
				if (image.alpha == alphaLow)
				{
					alphaTo = alphaLow;
				}
				else
				{
					alphaTo = alphaHigh;
				}
			}
			else if (image.alpha < alphaLow || image.alpha > alphaHigh)
			{
				if (image.alpha < alphaLow)
				{
					alphaTo = alphaLow;
				}
				else
				{
					alphaTo = alphaHigh;
				}
			}
			else
			{
				if (image.alpha - alphaLow >= (alphaHigh - alphaLow) * .5)
				{
					alphaTo = alphaHigh;
				}
				else
				{
					alphaTo = alphaLow;
				}
			}
			
			
			
			tweenAlpha();
		}
		
		override public function removed():void 
		{
			tween.cancel();
		}
		// -------------------------------------------------------------------------------------
		
		
		private function tweenAlpha():void
		{
			if (limit == -1 || uint(count * .5) < limit)
			{
				tween = FP.tween(image, { alpha: getAlphaTo() }, duration, { complete: tweenAlpha, ease: ease, tweener: this, delay: delay } );
				count++;
			}
			else world.remove(this);
		}
		
		private function getAlphaTo():Number
		{
			if (alphaTo == alphaLow) alphaTo = alphaHigh;
			else alphaTo = alphaLow;
			return alphaTo;
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}