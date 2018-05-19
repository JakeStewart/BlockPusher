package net.jacob_stewart 
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class WorldPlus extends World 
	{
		public var children:Array = new Array;
		
		
		
		public function WorldPlus() 
		{
			init();
		}
		
		public function init():void
		{
			
		}
		
		override public function end():void 
		{
			super.end();
			
			
			children.length = 0;
		}
		// ------------------------------------------------------------------------------
		
		
		/**
		 * Adds an Entity to the world and this.children
		 * @param	e	The Entity to add
		 */
		public function wpAdd(e:Entity):Entity
		{
			if (children.indexOf(e) == -1) children.push(e);
			return add(e);
		}
		
		
		/**
		 * Adds an array of Entity to the world and this.children
		 * @param	e	The array of Entity to add
		 */
		public function wpAddList(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) wpAddList(list[i]);
				else if (list[i] is Entity) wpAdd(list[i]);
			}
		}
		
		/**
		 * Removes an Entity from the world and this.children
		 * @param	e	The Entity to remove
		 */
		public function wpRemove(e:Entity):Entity
		{
			JS.splice(children, e);
			return remove(e);
		}
		
		
		/**
		 * Removes an array of Entity from the world and this.children
		 * @param	e	The array of Entity to remove
		 */
		public function wpRemoveList(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) wpRemoveList(list[i]);
				else if (list[i] is Entity) wpRemove(list[i]);
			}
		}
		
		
		/**
		 * Adds an Entity to the world via World.create() and adds it to this.children
		 * @param	_class		The class of the Entity
		 */
		public function wpCreate(_class:Class):Entity
		{
			var e:Entity = create(_class);
			if (children.indexOf(e) == -1) children.push(e);
			return e;
		}
		
		
		/**
		 * Removes an Entity from the world via World.recycle() and removes it from this.children
		 * @param	e	The Entity to recycle
		 */
		public function wpRecycle(e:Entity):Entity
		{
			JS.splice(children, e);
			return recycle(e);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}