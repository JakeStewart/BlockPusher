package worlds.title_screen.falling_blocks 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FallingBlock extends EntityGame 
	{
		private var img:Image = new Image(Images.BLOCK1);
		
		private var host:FallingBlockColumn;
		private var fb:FallingBlock;
		
		private var targetCoords:Point;
		
		public var deathFall:Boolean = false;
		
		private var speed:Number = 0;
		private var gravity:Number = .3;
		private var termVel:uint = 20;
		
		public var blockNum:uint;
		
		
		
		public function FallingBlock() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = 0;
			type = Game.TYPE_FallingBlock;
			graphic = img;
			img.color = 0x706d6b;
		}
		
		override public function setDefaults():void 
		{
			deathFall = false;
			speed = 0, gravity = .3;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			setDefaults();
			
			
			gravity += (FP.rand(2) * .1);
			
			if (blockNum > 0)
			{
				fb = host.fbList[blockNum - 1];
				if (gravity > fb.gravity) gravity = fb.gravity;
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
			fb = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (FP.distance(x, y, targetCoords.x, targetCoords.y) > 0)
			{
				if (FP.distance(x, y, targetCoords.x, targetCoords.y) - speed <= 0)
				{
					x = targetCoords.x, y = targetCoords.y;
					
					if (!deathFall) host.targetReached(this); // No need to notify parent of targetReached if on deathFall unless this is the last block
					else if (x == host.baseTargetCoords.x && y == host.baseTargetCoords.y) host.targetReached(this);
					
					
					if ((deathFall && (x == host.baseTargetCoords.x && y == host.baseTargetCoords.y)) || !deathFall)
					{
						if (FP.rand(10) < 2) host.glowCascade();
						// if (FP.rand(10) < 2) addGlow();
					}
				}
				else moveBlock();
				
				
				if (speed < termVel)
				{
					speed += gravity;
					if (speed > termVel) speed = termVel;
				}
			}
		}
		// ------------------------------------------------------------------------------
		
		
		private function moveBlock():void
		{
			if (x == targetCoords.x) y += (speed * posOrNeg(host.baseTargetCoords.y, FP.halfHeight)); // Moving up or down
			else if (y == targetCoords.y) x += (speed * posOrNeg(host.baseTargetCoords.x, FP.halfWidth)); // Moving left or right
			else if (host == host.host.groups[host.host.hostNum]) trace(host.x, name, "- blockNum:", blockNum, "x: " + x, "y: " + y, "targetCoords: " + targetCoords, "death: " + host.deathTargetCoords);
		}
		
		private function posOrNeg(targetCoord:Number, halfScreen:Number):int
		{
			if (targetCoord > halfScreen) return 1;
			else return -1;
		}
		
		public function runDeathFall(lastBlock:Boolean = false):void
		{
			speed = 0, gravity = .3, deathFall = true;
			
			if (!lastBlock) targetCoords = host.deathTargetCoords;
			else targetCoords = host.baseTargetCoords;
		}
		
		public function addGlow():void
		{
			FallingBlockGlow(world.create(FallingBlockGlow)).host = this;
		}
		// ------------------------------------------------------------------------------
		
		
		public function _FallingBlock(host:FallingBlockColumn):FallingBlock
		{
			this.host = host;
			x = host.x, y = host.y;
			
			if (name == null)
			{
				name = type + host.host.fbIds.length.toString();
				host.host.fbIds.push(name);
			}
			
			
			targetCoords = new Point(host.x, host.y);
			blockNum = host.fbList.length;
			
			setTargetCoords();
			
			
			return this;
			
			
			function setTargetCoords():void
			{
				switch (host.host.dirVal)
				{
					case 0: // Spawn from Top
						
						targetCoords.y = host.baseTargetCoords.y - (38 * host.fbList.length);
						break;
						
					case 1: // Spawn from Right
						
						targetCoords.x = host.baseTargetCoords.x + (38 * host.fbList.length);
						break;
						
					case 2: // Spawn from Bottom
						
						targetCoords.y = host.baseTargetCoords.y + (38 * host.fbList.length);
						break;
						
					case 3: // Spawn from Left
						
						targetCoords.x = host.baseTargetCoords.x - (38 * host.fbList.length);
						break;
				}
			}
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}