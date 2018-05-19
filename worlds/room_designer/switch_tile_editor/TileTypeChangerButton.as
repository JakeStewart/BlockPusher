package worlds.room_designer.switch_tile_editor 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TileTypeChangerButton extends Button 
	{
		private var ss:SpaceSelector_STE;
		private var forward:Boolean;
		
		private var normal:Image;
		private var hover:Image;
		
		
		
		public function TileTypeChangerButton(forward:Boolean, x:Number=0, y:Number=0) 
		{
			this.forward = forward;
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			epSetHitbox(12, 20);
			
			
			if (forward)
			{
				normal = new Image(Images.MOVEARROWRIGHTNORMAL);
				hover = new Image(Images.MOVEARROWRIGHTHOVER);
			}
			else
			{
				normal = new Image(Images.MOVEARROWLEFTNORMAL);
				hover = new Image(Images.MOVEARROWLEFTHOVER);
			}
			
			normal.alpha = .7;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			ss = world.getInstance(Game.NAME_SpaceSelector_STE) as SpaceSelector_STE;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ss = null;
		}
		// --------------------------------------------------------------------------------
		
		
		override public function click():void 
		{
			super.click();
			
			
			if (x < FP.halfWidth)
			{
				if (forward)
				{
					ss.imgIndexA = ss.imgIndexForward(ss.imgIndexA);
					if (ss.imgIndexA == ss.imgIndexB) ss.imgIndexB = ss.imgIndexForward(ss.imgIndexB);
				}
				else
				{
					ss.imgIndexA = ss.imgIndexBackward(ss.imgIndexA);
					if (ss.imgIndexA == ss.imgIndexB) ss.imgIndexB = ss.imgIndexBackward(ss.imgIndexB);
				}
			}
			else
			{
				if (forward)
				{
					ss.imgIndexB = ss.imgIndexForward(ss.imgIndexB);
					if (ss.imgIndexB == ss.imgIndexA) ss.imgIndexA = ss.imgIndexForward(ss.imgIndexA);
				}
				else
				{
					ss.imgIndexB = ss.imgIndexBackward(ss.imgIndexB);
					if (ss.imgIndexB == ss.imgIndexA) ss.imgIndexA = ss.imgIndexBackward(ss.imgIndexA);
				}
			}
		}
		// --------------------------------------------------------------------------------
		
		
		override public function changeStateNormal():void 
		{
			graphic = normal;
		}
		
		override public function changeStateHover():void 
		{
			graphic = hover;
		}
		
		override public function changeStateDown():void 
		{
			graphic = hover;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}