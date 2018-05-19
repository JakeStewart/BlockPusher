package net.jacob_stewart 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class EntityPlus extends Entity 
	{
		public var hbWidth:uint = 0;
		public var hbHeight:uint = 0;
		public var hbOriginX:int = 0;
		public var hbOriginY:int = 0;
		
		public var homeCoords:Point = new Point;
		
		/**
		 * An array of objects to be added to the world
		 */
		public var addList:Array = new Array;
		
		/**
		 * An array of objects in the world that were added by this Entity
		 */
		public var children:Array = new Array;
		
		/**
		 * The current tween object for this Entity
		 */
		public var tween:Tween;
		
		
		
		public function EntityPlus(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int = 0) 
		{
			super(x, y, graphic);
			
			
			this.layer = layer;
			init();
		}
		
		public function init():void
		{
			type = JS.TYPE_EntityPlus;
		}
		
		public function setDefaults():void
		{
			
		}
		
		override public function added():void 
		{
			super.added();
			
			
			if (!name) name = toString() + world.classCount(getClass()).toString();
			// if (!name) name = type + world.typeCount(type).toString();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			world.removeList(children);
			clearReferences();
		}
		
		public function clearReferences():void
		{
			children.length = 0;
			// addList.length = 0;
			tween = null;
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Used to pass data to an EntityPlus instance via world.create()
		 * Example: var myInstance:MyClass = EntityPlus(world.create(MyClass))._EntityPlus(xVal, yVal, graphicObj, layerVal) as MyClass;
		 */
		public function _EntityPlus(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int = 0):EntityPlus
		{
			this.x = x, this.y = y;
			if (graphic) this.graphic = graphic;
			this.layer = layer;
			
			
			return this;
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Sets the hitbox and stores those values in hbWidth, hbHeight, hbOriginX, hbOriginY
		 */
		public function epSetHitbox(width:uint = 0, height:uint = 0, originX:int = 0, originY:int = 0):void
		{
			hbWidth = width;
			hbHeight = height;
			hbOriginX = originX;
			hbOriginY = originY;
			
			setHitbox(width, height, originX, originY);
		}
		
		/**
		 * Sets the Entity's hitbox to match that of the provided object.
		 * Also stores the dimension values and origin values in hbWidth, hbHeight, hbOriginX, hbOriginY
		 * @param	o		The object defining the hitbox (eg. an Image or Rectangle).
		 */
		public function epSetHitboxTo(o:Object):void
		{
			if (o is Image || o is Rectangle) epSetHitbox(o.width, o.height, -o.x, -o.y);
			else
			{
				if (o.hasOwnProperty("width")) width = o.width;
				if (o.hasOwnProperty("height")) height = o.height;
				if (o.hasOwnProperty("originX") && !(o is Graphic)) originX = o.originX;
				else if (o.hasOwnProperty("x")) originX = -o.x;
				if (o.hasOwnProperty("originY") && !(o is Graphic)) originX = o.originY;
				else if (o.hasOwnProperty("y")) originX = -o.y;
				
				
				hbWidth = width;
				hbHeight = height;
				hbOriginX = originX;
				hbOriginY = originY;
			}
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Changes the values of the x and y properties for this Entity
		 * @param	x	The x coordinate
		 * @param	y	The y coordinate
		 */
		public function setXY(x:Number, y:Number):void
		{
			this.x = x, this.y = y;
		}
		
		/**
		 * Changes the values of the x and y properties of homeCoords
		 * @param	x	The x home coordinate
		 * @param	y	The y home coordinate
		 */
		public function setHomeXY(x:Number, y:Number):void
		{
			homeCoords.x = x, homeCoords.y = y;
		}
		
		/**
		 * Centers this Entity along the x axis of the stage or a given coordinate
		 * @param	width		The width of this Entity's hitbox or graphic
		 * @param	alignValX	Optional x coordinate to center the Entity on
		 */
		public function centerHor(width:uint, alignValX:Number = NaN):Number
		{
			if (isNaN(alignValX)) alignValX = FP.halfWidth;
			x = alignValX - (width * .5);
			return x;
		}
		
		/**
		 * Centers this Entity along the y axis of the stage or a given coordinate
		 * @param	height		The height of this Entity's hitbox or graphic
		 * @param	alignValY	Optional y coordinate to center the Entity on
		 */
		public function centerVer(height:uint, alignValY:Number = NaN):Number
		{
			if (isNaN(alignValY)) alignValY = FP.halfHeight;
			y = alignValY - (height * .5);
			return y;
		}
		
		/**
		 * Centers this Entity on a point
		 * @param	width		The width of this Entity's hitbox or graphic
		 * @param	height		The height of this Entity's hitbox or graphic
		 * @param	pX			The x coordinate of the point
		 * @param	pY			The y coordinate of the point
		 */
		public function centerOnPoint(width:uint, height:uint, pX:Number, pY:Number):void
		{
			x = pX - (width * .5);
			y = pY - (height * .5);
		}
		
		/**
		 * Centers this Entity's graphic on another Entity's graphic
		 * @param	target		The target Entity to center on
		 */
		public function centerOnTarget(target:Entity):void
		{
			var thisWidth:uint,
				thisHeight:uint,
				targetWidth:uint,
				targetHeight:uint;
			
			if (thisWidth == 0 && graphic)
			{
				var thisImg:Image = graphic as Image;
				thisWidth = thisImg.width, thisHeight = thisImg.height;
			}
			
			if (targetWidth == 0 && target.graphic)
			{
				var targetImg:Image = target.graphic as Image;
				targetWidth = targetImg.width, targetHeight = targetImg.height;
			}
			
			
			centerOnPoint(thisWidth, thisHeight, target.x + (targetWidth * .5), target.y + (targetHeight * .5));
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Adds an array of objects to the 'children' array
		 * @param	list	The array of objects
		 */
		public function addToChildren(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) addToChildren(list[i]);
				else if (children.indexOf(list[i]) == -1) children.push(list[i]);
			}
		}
		
		/**
		 * Removes an array of objects to the 'children' array
		 * @param	list	The array of objects
		 */
		public function removeFromChildren(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) removeFromChildren(list[i]);
				else if (list[i] is Entity) children.splice(children.indexOf(list[i]), 1);
			}
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Adds an Entity to the world and this.children
		 * @param	e	The Entity to add
		 */
		public function epAdd(e:Entity):Entity
		{
			if (children.indexOf(e) == -1) children.push(e);
			return world.add(e);
		}
		
		/**
		 * Adds an array of Entity to the world and this.children
		 * @param	e	The array of Entity to add
		 */
		public function epAddList(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) epAddList(list[i]);
				else if (list[i] is Entity) epAdd(list[i]);
			}
		}
		
		/**
		 * Removes an Entity from the world and this.children
		 * @param	e	The Entity to remove
		 */
		public function epRemove(e:Entity):Entity
		{
			JS.splice(children, e);
			return world.remove(e);
		}
		
		/**
		 * Removes an array of Entity from the world and this.children
		 * @param	e	The array of Entity to remove
		 */
		public function epRemoveList(list:Array):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) epRemoveList(list[i]);
				else if (list[i] is Entity) epRemove(list[i]);
			}
		}
		
		/**
		 * Adds an Entity to the world via World.create() and adds it to this.children
		 * @param	_class		The class of the Entity
		 */
		public function epCreate(_class:Class):Entity
		{
			var e:Entity = world.create(_class);
			if (children.indexOf(e) == -1) children.push(e);
			return e;
		}
		
		/**
		 * Removes an Entity from the world via World.recycle() and removes it from this.children
		 * @param	e	The Entity to recycle
		 */
		public function epRecycle(e:Entity):Entity
		{
			JS.splice(children, e);
			return world.recycle(e);
		}
		
		/**
		 * Removes this Entity from the world. Used for situations that pass funtions to tweens
		 * that are called on completion of the tween.
		 */
		public function removeThis():Entity
		{
			return world.remove(this);
		}
		
		/**
		 * Removes this Entity from the world. Used for situations that pass funtions to tweens
		 * that are called on completion of the tween.
		 */
		public function recycleThis():Entity
		{
			return world.recycle(this);
		}
		// -------------------------------------------------------------
		
		
		/**
		 * Turns the update on or off for 'this' and all EntityPlus in this.children excluding ones specified
		 * @param	state			The active state for each EntityPlus
		 * @param	includeThis		Optional Boolean if 'this' should be included on not
		 * @param	exclude			Optional one or multidimensional array of children to exclude
		 * @return	An array of EntityPlus (excluding 'this') that had their update state changed
		 */
		public function epActive(state:Boolean, includeThis:Boolean = true, exclude:Array = null):Array
		{
			var entities:Array = stateChangeList(exclude);
			if (includeThis) active = state;
			for each (var ep:EntityPlus in entities) ep.epActive(state, true, exclude);
			
			return entities;
		}
		
		/**
		 * Turns the render on or off for 'this' and all EntityPlus in this.children excluding ones specified
		 * @param	state			The render state for each EntityPlus
		 * @param	includeThis		Optional Boolean if 'this' should be included on not
		 * @param	exclude			Optional one or multidimensional array of children to exclude
		 * @return	An array of EntityPlus (excluding 'this') that had their render state changed
		 */
		public function epVisible(state:Boolean, includeThis:Boolean = true, exclude:Array = null):Array
		{
			var entities:Array = stateChangeList(exclude);
			if (includeThis) visible = state;
			for each (var ep:EntityPlus in entities) ep.epVisible(state, true, exclude);
			
			return entities;
		}
		
		/**
		 * Turns the collision on or off for 'this' and all EntityPlus in this.children excluding ones specified
		 * @param	state			The collision state for each EntityPlus
		 * @param	includeThis		Optional Boolean if 'this' should be included on not
		 * @param	exclude			Optional one or multidimensional array of children to exclude
		 * @return	An array of EntityPlus (excluding 'this') that had their collision state changed
		 */
		public function epCollidable(state:Boolean, includeThis:Boolean = true, exclude:Array = null):Array
		{
			var entities:Array = stateChangeList(exclude);
			if (includeThis) collidable = state;
			for each (var ep:EntityPlus in entities) ep.epCollidable(state, true, exclude);
			
			return entities;
		}
		
		/**
		 * Turns the collision and render on or off for 'this' and all EntityPlus in this.children excluding ones specified
		 * @param	state			The collision and render state for each EntityPlus
		 * @param	includeThis		Optional Boolean if 'this' should be included on not
		 * @param	exclude			Optional one or multidimensional array of children to exclude
		 * @return	An array of EntityPlus (excluding 'this') that had their collision and render states changed
		 */
		public function epCollidableAndVisible(state:Boolean, includeThis:Boolean = true, exclude:Array = null):Array
		{
			var entities:Array = stateChangeList(exclude);
			if (includeThis) collidable = state, visible = state;
			for each (var ep:EntityPlus in entities) ep.epCollidableAndVisible(state, true, exclude);
			
			return entities;
		}
		
		/**
		 * Returns an array of EntityPlus that will have the state of their update, render, or collision changed
		 */
		private function stateChangeList(exclude:Array = null):Array
		{
			var entities:Array = JS.classArray(children, EntityPlus);
			if (exclude)
			{
				exclude = JS.classArray(exclude, EntityPlus);
				for each (var ep:EntityPlus in exclude) entities.splice(entities.indexOf(ep), 1);
			}
			
			
			return entities;
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// Game specific:
		// public var subType:String;
		
		/**
		 * The space number in RoomDesigner this Entity represents
		 */
		// public var gridIndex:uint = 999;
		
		/**
		 * The space number in Room this Entity represents
		 */
		// public var roomIndex:int;
		
		/**
		 * Used to pass game specific data to an EntityPlus instance via world.create()
		 * Example: var myInstance:MyClass = EntityPlus(world.create(MyClass))._EntityPlus(xVal, yVal, spaceNumVal, layerVal) as MyClass;
		 */
		/*
		public function _EntityGame(x:Number, y:Number, spaceNum:int = -1):EntityGame
		{
			this.x = x, this.y = y;
			if (spaceNum != -1) roomIndex = spaceNum;
			
			
			return this;
		}
		*/
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}