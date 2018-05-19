package gui 
{
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ConfirmOrCancelText extends EntityGame 
	{
		private const LEADING:uint = 6;
		private var baseY:Number;
		private const STR_ENTER:String = "ENTER to confirm";
		private const STR_ESC:String = "ESC to cancel";
		private var enterText:TextPlus = new TextPlus(STR_ENTER, 0, 0, { size: 24 } );
		private var escText:TextPlus = new TextPlus(STR_ESC, 0, 0, { size: 24 } );
		
		
		
		public function ConfirmOrCancelText(layer:int = Game.TEXTLAYER, baseY:Number = 420) 
		{
			setLayer(layer)
			this.baseY = baseY;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			enterText.setXY(enterText.centerHor(enterText.textWidth), baseY);
			escText.setXY(escText.centerHor(escText.textWidth), enterText.y + enterText.textHeight + LEADING);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([enterText, escText]);
		}
		// ---------------------------------------------------------------------------------
		
		
		private function setLayer(layer:int):void
		{
			this.layer = layer;
			enterText.layer = layer;
			escText.layer = layer;
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}