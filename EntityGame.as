package  
{
	import net.flashpunk.Graphic;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class EntityGame extends EntityPlus 
	{
		public var subType:String;
		
		/**
		 * The space number in RoomDesigner this Entity represents
		 */
		public var gridIndex:uint = 999;
		
		/**
		 * The space number in Room this Entity represents
		 */
		public var roomIndex:int;
		
		
		
		public function EntityGame(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int=0) 
		{
			super(x, y, graphic, layer);
		}
		// ------------------------------------------------------------------------------------
		
		
		public function _EntityGame(x:Number, y:Number, spaceNum:int = -1):EntityGame
		{
			this.x = x, this.y = y;
			if (spaceNum != -1) roomIndex = spaceNum;
			
			
			return this;
		}
		// ------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------
		
	}

}