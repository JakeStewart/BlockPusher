package gui 
{
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AlphaPulseText extends TextPlus 
	{
		private const DURATION:Number = .5;
		
		private const ALPHALOW:Number = .4;
		private const ALPHAHIGH:Number = 1;
		private var alphaTo:Number = ALPHAHIGH;
		
		private var tweens:Array;
		
		
		
		public function AlphaPulseText(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(text, x, y, options, layer);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			tweenAlpha();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			JS.cancelTweens(tweens);
			tweens.length = 0;
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function tweenAlpha(toAlpha:Number = 1, duration:Number = 0, ease:Function = null, onComplete:Function = null, delay:Number = 0):Array 
		{
			tweens = super.tweenAlpha(getAlphaTo(), DURATION, ease, tweenAlpha, delay);
			return tweens;
		}
		
		private function getAlphaTo():Number
		{
			if (alphaTo == ALPHALOW) alphaTo = ALPHAHIGH;
			else alphaTo = ALPHALOW;
			return alphaTo;
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}