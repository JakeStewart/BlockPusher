package net.jacob_stewart.other 
{
	import flash.utils.Timer;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class DisplayTimer extends TextPlus
	{
		public var timer:Timer = new Timer(1000);
		
		/**
		 * Keeps the text center aligned when it updates.
		 * Default is true. If false, text will anchor align left.
		 */
		public var anchorCenter:Boolean = true;
		
		/**
		 * Keeps the text right aligned when it updates.
		 * Default is false. If anchorCenter is true, it will override anchorRight.
		 */
		public var anchorRight:Boolean;
		
		
		
		public function DisplayTimer(startSeconds:int=0, x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER, anchorCenter:Boolean=true, anchorRight:Boolean=false) 
		{
			this.anchorCenter = anchorCenter;
			this.anchorRight = anchorRight;
			
			
			super(JS.getTimerStr(startSeconds), x, y, options, layer);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			timer.start();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			timer.stop();
		}
		// ------------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateText();
		}
		
		private function updateText():void
		{
			changeText(JS.getTimerStr(timer.currentCount), anchorCenter, anchorRight);
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
	}

}