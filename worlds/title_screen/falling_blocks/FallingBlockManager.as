package worlds.title_screen.falling_blocks 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FallingBlockManager extends EntityGame 
	{
		private const COLUMN_COUNT:uint = 22;
		private const ROW_COUNT:uint = 17;
		
		public var groups:Array = new Array;
		public var groupCounts:Array = [COLUMN_COUNT, ROW_COUNT];
		
		// x -15, y -20: coords of Top Left block
		public const baseCoords:Point = new Point( -15, -20);
		
		public var dirVal:uint;
		
		public var fbIds:Array = new Array;
		public var hostNum:uint;
		
		
		
		public function FallingBlockManager() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_FallingBlockManager;
		}
		
		override public function setDefaults():void 
		{
			groups.length = 0;
			fbIds.length = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			setDefaults();
			
			
			var groupCount:uint;
			var baseCoord:Number;
			
			dirVal = FP.rand(4);
			
			if (dirVal == 0 || dirVal == 2) groupCount = groupCounts[0], baseCoord = baseCoords.x;
			else groupCount = groupCounts[1], baseCoord = baseCoords.y;
			
			hostNum = FP.rand(groupCount);
			
			for (var i:uint = 0; i < groupCount; i++) groups.push(FallingBlockColumn(world.create(FallingBlockColumn))._FallingBlockColumn(this, baseCoord + (38 * groups.length)));
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			for each (var fbc:FallingBlockColumn in groups) world.recycle(fbc);
			groups.length = 0;
		}
		// ----------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------
		
	}

}