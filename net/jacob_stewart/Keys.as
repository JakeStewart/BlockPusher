package net.jacob_stewart 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Keys 
	{
		
		public static function defineKeys():void
		{
			Input.define(SELECT, Key.SPACE, Key.ENTER);
			Input.define(CANCEL, Key.ESCAPE, Key.BACKSPACE);
			
			Input.define(DIR, Key.UP, Key.RIGHT, Key.DOWN, Key.LEFT, Key.W, Key.D, Key.S, Key.A);
			Input.define(VER, Key.UP, Key.DOWN, Key.W, Key.S);
			Input.define(HOR, Key.RIGHT, Key.LEFT, Key.D, Key.A);
			Input.define(UP, Key.UP, Key.W);
			Input.define(RIGHT, Key.RIGHT, Key.D);
			Input.define(DOWN, Key.DOWN, Key.S);
			Input.define(LEFT, Key.LEFT, Key.A);
			
			
			Input.define(NUMERIC, 
			Key.DIGIT_0, Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3, Key.DIGIT_4, Key.DIGIT_5, Key.DIGIT_6, Key.DIGIT_7, Key.DIGIT_8, Key.DIGIT_9,
			Key.NUMPAD_0, Key.NUMPAD_1, Key.NUMPAD_2, Key.NUMPAD_3, Key.NUMPAD_4, Key.NUMPAD_5, Key.NUMPAD_6, Key.NUMPAD_7, Key.NUMPAD_8, Key.NUMPAD_9);
			
			Input.define(NUMERIC_DIGIT, 
			Key.DIGIT_0, Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3, Key.DIGIT_4, Key.DIGIT_5, Key.DIGIT_6, Key.DIGIT_7, Key.DIGIT_8, Key.DIGIT_9);
			
			Input.define(NUMERIC_NUMPAD, 
			Key.NUMPAD_0, Key.NUMPAD_1, Key.NUMPAD_2, Key.NUMPAD_3, Key.NUMPAD_4, Key.NUMPAD_5, Key.NUMPAD_6, Key.NUMPAD_7, Key.NUMPAD_8, Key.NUMPAD_9);
			
			Input.define(RD_INFO_TOGGLE, Key.F4, Key.F8);
			
			Input.define(CHANGE_TILE_TYPE, Key.A, Key.S, Key.Z, Key.X);
		}
		
		
		/**
		 * A String representing keys that select things. Key.SPACE, Key.ENTER
		 */
		public static const SELECT:String = "Select";
		
		
		/**
		 * A String representing keys that cancel or back out things. Key.ESCAPE, Key.BACKSPACE
		 */
		public static const CANCEL:String = "Cancel";
		
		
		/**
		 * A String representing keys that execute a player character attack. Key.CONTROL
		 */
		public static const ATTACK:String = "Attack";
		
		
		/**
		 * A String representing the directional keys. Arrow keys and WASD keys
		 */
		public static const DIR:String = "Directional";
		
		
		/**
		 * A String representing the UP, DOWN, W, and S keys
		 */
		public static const VER:String = "Directional_Vertical";
		
		
		/**
		 * A String representing the RIGHT, LEFT, A, and D keys
		 */
		public static const HOR:String = "Directional_Horizontal";
		
		
		/**
		 * A String representing the UP, and W keys
		 */
		public static const UP:String = "Directional_Up";
		
		
		/**
		 * A String representing the RIGHT, and D keys
		 */
		public static const RIGHT:String = "Directional_Right";
		
		
		/**
		 * A String representing the DOWN, and S keys
		 */
		public static const DOWN:String = "Directional_Down";
		
		
		/**
		 * A String representing the LEFT, and A keys
		 */
		public static const LEFT:String = "Directional_Left";
		
		
		/**
		 * A String representing the numerical keys
		 */
		public static const NUMERIC:String = "Numerical";
		
		
		/**
		 * A String representing the numerical keys above letters
		 */
		public static const NUMERIC_DIGIT:String = "Numerical_Digits";
		
		
		/**
		 * A String representing the numerical keys on the numpad
		 */
		public static const NUMERIC_NUMPAD:String = "Numerical_Numpad";
		// -----------------------------------------------------------------------------
		
		
		/* RoomDesigner */
		/**
		 * A String representing the F4 & F8 keys
		 */
		public static const RD_INFO_TOGGLE:String = "RoomDesigner_InfoToggle";
		
		/* SwitchClientCreator & SwitchClientEditor */
		/**
		 * A String representing the A, S, Z, and X keys
		 */
		public static const CHANGE_TILE_TYPE:String = "Change_TileType";
		// -----------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}