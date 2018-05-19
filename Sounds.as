package  
{
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * Contains all the sounds.
	 * Each sound has the embed code, the Sfx var and a function to play the Sfx.
	 * This is so it plays it at the correct volume for the current save file in use.
	 */
	public class Sounds 
	{
		/* SFX */
		[Embed(source = "../assets/sounds/menu_selection/Pickup_Coin_Main.mp3")] public static const MENUSELECT_MAIN:Class;
		public static var menuSelectMain_SFX:Sfx = new Sfx(MENUSELECT_MAIN);
		public static function menuSelectMain():void { menuSelectMain_SFX.play(getVolSFX()); }
		
		
		[Embed(source = "../assets/sounds/ticks/tick1.mp3")] public static const TICK1:Class;
		public static var tick1_SFX:Sfx = new Sfx(TICK1);
		public static function tick1():void { tick1_SFX.play(getVolSFX()); }
		
		[Embed(source = "../assets/sounds/ticks/tick2.mp3")] public static const TICK2:Class;
		public static var tick2_SFX:Sfx = new Sfx(TICK2);
		public static function tick2():void { tick2_SFX.play(getVolSFX()); }
		
		[Embed(source = "../assets/sounds/ticks/tick3.mp3")] public static const TICK3:Class;
		public static var tick3_SFX:Sfx = new Sfx(TICK3);
		public static function tick3():void { tick3_SFX.play(getVolSFX()); }
		
		[Embed(source = "../assets/sounds/ticks/tick4.mp3")] public static const TICK4:Class;
		public static var tick4_SFX:Sfx = new Sfx(TICK4);
		public static function tick4():void { tick4_SFX.play(getVolSFX()); }
		
		
		
		[Embed(source = "../assets/sounds/knocks/back_out1.mp3")] public static const KNOCK1:Class;
		public static var knock1_SFX:Sfx = new Sfx(KNOCK1);
		public static function knock1():void { knock1_SFX.play(getVolSFX()); }
		
		
		
		[Embed(source = "../assets/sounds/selection/new_save_file.mp3")] public static const NEWSAVEFILE1:Class;
		public static var newSaveFile1_SFX:Sfx = new Sfx(NEWSAVEFILE1);
		public static function newSaveFile1():void { newSaveFile1_SFX.play(getVolSFX()); }
		
		
		
		[Embed(source="../assets/sounds/open_options/open_options1.mp3")] public static const OPENOPTIONS1:Class;
		public static var openOptions1_SFX:Sfx = new Sfx(OPENOPTIONS1);
		public static function openOptions1():void { openOptions1_SFX.play(getVolSFX()); }
		
		[Embed(source="../assets/sounds/open_options/open_options2.mp3")] public static const OPENOPTIONS2:Class;
		public static var openOptions2_SFX:Sfx = new Sfx(OPENOPTIONS2);
		public static function openOptions2():void { openOptions2_SFX.play(getVolSFX()); }
		
		
		
		[Embed(source="../assets/sounds/selection/select1.mp3")] public static const SELECT1:Class;
		public static var select1_SFX:Sfx = new Sfx(SELECT1);
		public static function select1():void { select1_SFX.play(getVolSFX()); }
		
		
		[Embed(source = "../assets/sounds/warnings/warning1.mp3")] public static const WARNING1:Class;
		public static var warning1_SFX:Sfx = new Sfx(WARNING1);
		public static function warning1():void { warning1_SFX.play(getVolSFX()); }
		
		
		[Embed(source="../assets/sounds/other/Randomize4_1.mp3")] public static const WAVE1:Class;
		public static var wave1_SFX:Sfx = new Sfx(WAVE1);
		public static function wave1():void { wave1_SFX.play(getVolSFX()); }
		
		
		
		[Embed(source = "../assets/sounds/collect/collect1.mp3")] public static const COLLECT1:Class;
		public static var collect1_SFX:Sfx = new Sfx(COLLECT1);
		public static function collect1():void { collect1_SFX.play(getVolSFX()); }
		
		
		
		/* MUSIC */
		
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		public static function getVolSFX():Number
		{
			if (isMute()) return 0;
			return SaveFileData.getSFXLevel() / 10;
		}
		
		public static function getVolMusic():Number
		{
			if (isMute()) return 0;
			return SaveFileData.getMusicLevel() / 10;
		}
		
		public static function isMute():Boolean
		{
			var saveFileNumInUse:uint = SaveFileData.getSaveFileInUse();
			if (saveFileNumInUse == 0) return false; // There are no save files created
			Data.load("SaveFile" + saveFileNumInUse.toString());
			if (Data.readBool("Mute")) return true;
			return false;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}