package net.jacob_stewart.other
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RunFunctionOnAdd extends Entity 
	{
		private var onAdd:Function;
		
		
		
		public function RunFunctionOnAdd(onAdd:Function = null) 
		{
			this.onAdd = onAdd;
		}
		
		override public function added():void 
		{
			if (onAdd != null) onAdd();
			world.remove(this);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}