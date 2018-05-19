package gui 
{
	import flash.geom.Rectangle;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MouseProximityAlphaAdjust extends EntityGame 
	{
		private var ep:EntityPlus;
		private var ready:Boolean = false;
		private var checking:Boolean = false;
		
		public var eList:Array = new Array;
		public var gList:Array = new Array;
		
		private var mouseCoords:EntityPlus = new EntityPlus;
		public var rect:Rectangle = new Rectangle;
		private var distance:Number;
		
		
		
		public function MouseProximityAlphaAdjust(_eList:Array = null, x:Number=0, y:Number=0, _width:Number = 0, _height:Number = 0, graphic:Graphic=null) 
		{
			if (_eList != null)
			{
				eList = _eList;
				checking = true;
			}
			
			rect.x = x, rect.y = y, rect.width = _width, rect.height = _height;
			
			
			super(x, y, graphic);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ep = null;
			eList.length = 0;
			gList.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			// children isn't populated until an EntityPlus is added to the world
			// so gList can't be populated until every EntityPlus in eList has been added to the world
			if (checking)
			{
				for (var i:uint = 0; i < eList.length; i++)
				{
					ep = eList[i];
					if (!ep.world) i = eList.length;
					if (i == eList.length - 1)
					{
						for each (var epA:EntityPlus in eList)
						{
							if (epA.graphic != null)
							{
								gList.push(epA.graphic);
								for each (var epB:EntityPlus in epA.children)
								{
									if (epB.graphic != null) gList.push(epB.graphic);
								}
							}
						}
						
						checking = false, ready = true;
					}
				}
			}
			
			
			if (ready)
			{
				mouseCoords.x = world.mouseX, mouseCoords.y = world.mouseY;
				distance = mouseCoords.distanceToRect(rect.x, rect.y, rect.width, rect.height);
				
				if (distance < 100) for each (var img1:Image in gList) img1.alpha = distance / 100;
				else for each (var img2:Image in gList) img2.alpha = 1;
			}
		}
		
		public function newEList(_eList:Array):void
		{
			eList.length = 0, gList.length = 0;
			eList = _eList;
			checking = true, ready = false;
		}
		
	}

}