package net.jacob_stewart.other 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.Button;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RunFunctionButton extends Button 
	{
		private var onClick:Function;
		
		
		
		public function RunFunctionButton(onClick:Function, x:Number=0, y:Number=0, hbWidth:uint=0, hbHeight:uint=0) 
		{
			this.onClick = onClick;
			this.hbWidth = hbWidth;
			this.hbHeight = hbHeight;
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			if (hbWidth == 0) hbWidth = FP.width;
			if (hbHeight == 0) hbHeight = FP.height;
			epSetHitbox(hbWidth, hbHeight);
		}
		// -------------------------------------------------------------------
		
		
		override public function click():void 
		{
			super.click();
			
			
			onClick();
		}
		// -------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------
		
	}

}