package gui 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Button;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MenuArrow extends Button 
	{
		private var onClick:Function;
		private var directionVal:uint; // 0: Up, 1: Right, 2: Down, 3: Left
		private var _centerX:Number;
		private var _centerY:Number;
		public var image:Image;
		private var clickVal:int;
		private var clickVals:Array = [Key.UP, Key.RIGHT, Key.DOWN, Key.LEFT];
		
		
		private const ALPHA_NORMAL:Number = .6;
		private const ALPHA_HOVER:Number = 1;
		private const ALPHA_DOWN:Number = ALPHA_NORMAL;
		
		private var alphaNormal:Number = ALPHA_NORMAL;
		private var alphaHover:Number = ALPHA_HOVER;
		private var alphaDown:Number = ALPHA_DOWN;
		private var alphas:Array = [alphaNormal, alphaHover, alphaDown];
		
		
		
		public function MenuArrow(onClick:Function, directionVal:uint, centerX:Number, centerY:Number, layer:int=0) 
		{
			this.onClick = onClick;
			this.directionVal = directionVal;
			this._centerX = centerX;
			this._centerY = centerY;
			
			
			super(0, 0, null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			image = new Image(Images.arrowSources[directionVal]);
			clickVal = clickVals[directionVal];
			
			graphic = image;
			state = NORMAL, changeState();
			
			
			centerOnPoint(image.width, image.height, _centerX, _centerY);
			setHomeXY(x, y);
			epSetHitboxTo(image);
		}
		
		override public function changeState(state:int = -1):void 
		{
			if (state == -1) state = this.state;
			image.alpha = alphas[state];
		}
		
		override public function click():void 
		{
			super.click();
			
			
			if (onClick != null) onClick(clickVal);
		}
		
		public function onKeyPressed():void
		{
			if (Input.check(clickVal)) state = HOVER, changeState();
		}
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
	}

}