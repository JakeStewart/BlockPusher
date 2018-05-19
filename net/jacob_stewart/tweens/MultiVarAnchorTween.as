package net.jacob_stewart.tweens 
{
	import net.flashpunk.Tween;
	
	/**
	 * Tweens multiple numeric public properties of an Object simultaneously, and anchors that tween to another object.
	 * @author net.flashpunk.tweens.misc.MultiVarTween, modified by Jacob Stewart
	 */
	public class MultiVarAnchorTween extends Tween 
	{
		/**
		 * Constructor.
		 * @param	complete		Optional completion callback.
		 * @param	type			Tween type.
		 */
		public function MultiVarAnchorTween(complete:Function = null, type:uint = 0)
		{
			super(0, type, complete);
		}
		
		/**
		 * Tweens multiple numeric public properties of an object and anchors that tween to another object.
		 * @param	object		The object containing the properties.
		 * @param	anchor		The anchor containing the properties to follow.
		 * @param	values		An object containing key/value pairs of properties and target values.
		 * @param	duration	Duration of the tween.
		 * @param	ease		Optional easer function.
		 */
		public function tween(object:Object, anchor:Object, values:Object, duration:Number, ease:Function = null, delay:Number = 0):void
		{
			_object = object;
			_anchor = anchor;
			_vars.length = 0;
			_range.length = 0;
			_offset.length = 0;
			_target = duration;
			this.delay = delay;
			_ease = ease;
			for (var p:String in values)
			{
				if (!object.hasOwnProperty(p) || !anchor.hasOwnProperty(p)) throw new Error("An Object provided does not have the property\"" + p + "\", or it is not accessible.");
				var a:* = _object[p] as Number;
				var b:* = _anchor[p] as Number;
				if (a == null) throw new Error("The property \"" + p + "\" of _object is not numeric.");
				if (b == null) throw new Error("The property \"" + p + "\" of _anchor is not numeric.");
				_vars.push(p);
				_range.push(values[p] - a);
				_offset.push(b - a);
			}
			start();
		}
		
		/** @private Updates the Tween. */
		override public function update():void
		{
			super.update();
			if (delay > 0) return;
			var i:int = _vars.length;
			while (i --) _object[_vars[i]] = (_anchor[_vars[i]] + (_offset[i] * -1)) + _range[i] * _t;
		}
		
		// Tween information.
		/** @private */ private var _object:Object;
		/** @private */ private var _anchor:Object;
		/** @private */ private var _vars:Vector.<String> = new Vector.<String>;
		/** @private */ private var _range:Vector.<Number> = new Vector.<Number>;
		/** @private */ private var _offset:Vector.<Number> = new Vector.<Number>;
		
	}

}