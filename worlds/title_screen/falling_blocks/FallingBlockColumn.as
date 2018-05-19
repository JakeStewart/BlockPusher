package worlds.title_screen.falling_blocks 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FallingBlockColumn extends EntityGame 
	{
		public var host:FallingBlockManager;
		private var fb:FallingBlock;
		
		public var fbList:Array = new Array;
		private var blockCount:uint;
		
		public var baseTargetCoords:Point = new Point;
		public var deathTargetCoords:Point = new Point;
		
		private const DELAYMAX:uint = 2;
		private const DELAYMIN:Number = .1;
		private const DELAYKILLSEQ:uint = 2;
		private const DELAYNEXTKILL:uint = 1;
		
		
		
		public function FallingBlockColumn() 
		{
			super();
		}
		
		override public function setDefaults():void 
		{
			fbList.length = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			setDefaults();
			FP.alarm(getDelay(DELAYMAX * (FP.rand(10) + 1), DELAYMIN), addBlock);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			recycleAll();
			host = null;
			fb = null;
			fbList.length = 0;
		}
		// -----------------------------------------------------------------------
		
		
		private function addBlock():void
		{
			fbList.push(FallingBlock(world.create(FallingBlock))._FallingBlock(this));
		}
		
		private function killBlock():void
		{
			if (fbList.length == blockCount)
			{
				for (var i:uint = 0; i < fbList.length; i++)
				{
					fb = fbList[i];
					if (!fb.deathFall)
					{
						if (i == fbList.length - 1)
						{
							fb.runDeathFall(true);
						}
						else
						{
							fb.runDeathFall();
							FP.alarm(DELAYNEXTKILL, killBlock);
						}
						
						i = fbList.length;
					}
				}
			}
		}
		// -----------------------------------------------------------------------
		
		
		private function getDelay(max:uint, min:Number = .1):Number
		{
			return (FP.rand(max) + (FP.rand(100) * .01)) + min;
		}
		// -----------------------------------------------------------------------
		
		
		public function targetReached(fb:FallingBlock):void
		{
			if (fb.deathFall) // Only deathFall FallingBlock that will call targetReached() is last one that starts new stack
			{
				fbList.reverse();
				recycleAll(1);
				fbList.length = 1;
				this.fb = fbList[0], this.fb.deathFall = false, this.fb.blockNum = 0;
				FP.alarm(getDelay(DELAYMAX, DELAYMIN), addBlock);
			}
			else
			{
				if (fbList.length < blockCount) FP.alarm(getDelay(DELAYMAX, DELAYMIN), addBlock);
				else FP.alarm(getDelay(DELAYKILLSEQ, DELAYMIN), killBlock); // start kill sequence
			}
		}
		// -----------------------------------------------------------------------
		
		
		public function glowCascade():void
		{
			var delay:Number = .05;
			for (var i:uint = fbList.length; i > 0; i--)
			{
				fb = fbList[i - 1];
				if (i == fbList.length)
				{
					fb.addGlow();
				}
				else
				{
					FP.alarm(delay, fb.addGlow);
					delay += .05;
				}
			}
		}
		
		private function recycleAll(startIndex:uint = 0):void
		{
			for (var i:uint = startIndex; i < fbList.length; i++)
			{
				fb = fbList[i];
				world.recycle(fb);
			}
		}
		// ----------------------------------------------------------------------------------
		
		
		public function _FallingBlockColumn(host:FallingBlockManager, constCord:Number):FallingBlockColumn
		{
			this.host = host;
			
			x = constCord;
			y = constCord;
			baseTargetCoords.x = constCord;
			baseTargetCoords.y = constCord;
			deathTargetCoords.x = constCord;
			deathTargetCoords.y = constCord;
			
			setCoords();
			
			
			return this;
			
			
			function setCoords():void
			{
				switch (host.dirVal)
				{
					case 0: // Spawn from Top
						
						y = host.baseCoords.y - 38;
						baseTargetCoords.y = host.baseCoords.y + (38 * (host.groupCounts[1] - 1));
						deathTargetCoords.y = baseTargetCoords.y + 38;
						
						blockCount = host.groupCounts[1];
						
						break;
						
					case 1: // Spawn from Right
						
						x = host.baseCoords.x + (38 * host.groupCounts[0]);
						baseTargetCoords.x = host.baseCoords.x;
						deathTargetCoords.x = host.baseCoords.x - 38;
						
						blockCount = host.groupCounts[0];
						
						break;
						
					case 2: // Spawn from Bottom
						
						y = host.baseCoords.y + (38 * host.groupCounts[1]);
						baseTargetCoords.y = host.baseCoords.y;
						deathTargetCoords.y = host.baseCoords.y - 38;
						
						blockCount = host.groupCounts[1];
						
						break;
						
					case 3: // Spawn from Left
						
						x = host.baseCoords.x - 38;
						baseTargetCoords.x = host.baseCoords.x + (38 * (host.groupCounts[0] - 1));
						deathTargetCoords.x = baseTargetCoords.x + 38;
						
						blockCount = host.groupCounts[0];
						
						break;
				}
			}
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}