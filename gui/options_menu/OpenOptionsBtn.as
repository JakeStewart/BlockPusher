package gui.options_menu 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OpenOptionsBtn extends TextButton 
	{
		public const ALPHA_INACTIVE:Number = .3;
		
		
		
		public function OpenOptionsBtn(onClick:Function=null, text:String="OPTIONS", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			centerHor(textWidth, Game.TEXTCENXL);
			centerVer(textHeight, Game.BOTTOMAREAVERCEN);
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}