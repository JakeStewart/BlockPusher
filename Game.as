package  
{
	import flash.display.Stage;
	import flash.system.fscommand;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * Global variables and functions specific to the game
	 */
	public class Game 
	{
		/* DEVELOPER */
		/**
		 * If true, allows user to do developer things when game is running
		 */
		public static var developer:Boolean = false;
		
		/**
		 * If true, starting a blank design in RoomDesigner will
		 * auto build a design
		 */
		public static var autoDesign:Boolean = false;
		
		
		
		/* RESOLUTION */
		public static const RES_WIDTH_DEF:uint = 800;
		public static const RES_HEIGHT_DEF:uint = 600;
		public static const RES_WIDTH_ALT:uint = RES_WIDTH_DEF * 2;
		public static const RES_HEIGHT_ALT:uint = RES_HEIGHT_DEF * 2;
		
		
		
		/* COLORS */
		/**
		 * The background screen color for the game
		 */
		public static const SCREENCOLOR:uint = 0x686462;
		
		public static const BLUECOLOR1:uint = 0x84E7FF;
		
		
		
		/* INPUT */
		
		
		
		
		/* GUI */
		/**
		 * The outline thickness for the Draw.rectPlus GUI panel in PanelBackground class
		 */
		public static const PANELTHICK:uint = 4;
		
		/**
		 * The roundness value for Draw.rectPlus GUI panel in PanelBackground class
		 */
		public static const PANELRADIUS:uint = 12;
		
		/**
		 * The duration of the overlay fade in when changing worlds
		 */
		public static const OVERLAYDURATION:Number = .4;
		
		/**
		 * The layer for ScreenTint
		 */
		public static const SCREENTINT_LAYER:int = -3;
		
		public static const TEXTCENXL:uint = 115;
		public static const TEXTCENXR:uint = 685; // 0.14375, 0.35625
		
		public static const TOPAREACEILING:uint = 4;
		public static const TOPAREAVERCEN:uint = 30;
		public static const TOPAREAFLOOR:uint = 60;
		
		public static const BOTTOMAREACEILING:uint = 540;
		public static const BOTTOMAREAVERCEN:uint = 570;
		public static const BOTTOMAREAFLOOR:uint = 596;
		
		
		
		/* TEXT */
		/**
		 * The base layer value for text
		 */
		public static const TEXTLAYER:int = -4;
		
		/**
		 * The text size for a room name
		 */
		public static const SIZE_ROOMNAME:uint = 24;
		
		/**
		 * The ceiling/floor pad for a room name
		 */
		public static const ROOMNAME_PADY:uint = 12;
		
		
		
		/* PUZZLE SPACE */
		/**
		 * The default width and height for the game's spaces and game pieces
		 */
		public static const SPACESIZE:uint = 32;
		
		/**
		 * Half the amount of SPACESIZE
		 */
		public static const HALFSPACESIZE:uint = SPACESIZE * .5;
		
		/**
		 * The distance between two spaces
		 */
		public static const SPACEPADDING:uint = 6;
		
		/**
		 * The width and height of a space plus the distance between two spaces
		 * Space Size Plus Space Padding
		 */
		public static const SSPSP:uint = SPACESIZE + SPACEPADDING;
		
		/**
		 * The maximum number of columns
		 */
		public static const MAXCOLUMNCOUNT:uint = 16;
		
		/**
		 * The maximum number of rows
		 */
		public static const MAXROWCOUNT:uint = 12;
		
		/**
		 * Width of the maximum game board area
		 * Distance between the left edge of the left-most space and right edge 
		 * of the right-most space when the maximum number of spaces are used
		 */
		public static const GRIDWIDTH:uint = ((SPACESIZE + SPACEPADDING) * MAXCOLUMNCOUNT) - SPACEPADDING;
		
		/**
		 * Height of the maximum game board area
		 * Distance between the top of the top-most space and the bottom 
		 * of the bottom-most space when the maximum number of spaces are used
		 */
		public static const GRIDHEIGHT:uint = ((SPACESIZE + SPACEPADDING) * MAXROWCOUNT) - SPACEPADDING;
		
		/**
		 * Height of the area between the maximum game board area and 
		 * the top or bottom of the screen (the game board area is centered)
		 */
		public static function get textAreaHeight():uint { return Math.round(FP.halfHeight - (GRIDHEIGHT * .5)); }
		
		/**
		 * Half of textAreaHeight
		 */
		public static function get textAreaHalfHeight():uint { return Math.round(textAreaHeight * .5); }
		
		/**
		 * Width of the area between the maximum game board area and 
		 * the side of the screen (the game board area is centered)
		 */
		public static function get textAreaWidth():uint { return Math.round(FP.halfWidth - (GRIDWIDTH * .5)); }
		
		/**
		 * Half of textAreaHalfHeight
		 */
		public static function get textAreaHalfWidth():uint { return Math.round(textAreaWidth * .5); }
		
		
		
		/* SAVE FILE */
		/**
		 * The maximum number of save files for the game
		 */
		public static const MAXSAVEFILECOUNT:uint = 3;
		
		
		
		/* TITLE SCREEN */
		/**
		 * TSTAHP: Title Screen Title Area Height Percentage
		 */
		public static const TSTAHP:Number = .2;
		
		/**
		 * TSTAH: Title Screen Title Area Height
		 * TSTAHP: Title Screen Title Area Height Percentage
		 */
		// public static const TSTAH:uint = Math.round(FP.height * TSTAHP);
		public static function get TSTAH():uint { return Math.round(FP.height * TSTAHP); }
		
		
		
		/* STATS SCREEN */
		/**
		 * The base layer for entities in Stats class
		 */
		public static const STATSBASELAYER:int = -7;
		
		
		
		/* MEDAL RANKING */
		/**
		 * The difference of moves between gold and silver
		 */
		public static const DIFF_SILVER:uint = 2;
		
		/**
		 * The difference of moves between gold and bronze
		 */
		public static const DIFF_BRONZE:uint = 5;
		
		
		
		/* OPTIONS MENU */
		/**
		 * The base layer value for any OptionsMenu entity
		 */
		public static const OPTIONSBASELAYER:int = -7;
		
		/**
		 * The tween duration for the OptionsMenu
		 */
		public static const OPTIONSTWEENDURATION:Number = .3;
		
		/**
		 * The ease function used for the OptionsMenu tween
		 */
		public static var optionsEase:Function = Ease.quintOut;
		
		/**
		 * Distance between the options panel edge and an object
		 */
		public static const OPTIONSPAD:uint = 100;
		
		/**
		 * x coordinate of left-most AudioLevelBar
		 */
		public static function get audioBarsX():Number { return FP.halfWidth + 40; }
		
		/**
		 * The height of the audio level bar for Draw.linePlus in AudioLevelBar class
		 */
		public static const AUDIOBARHEIGHT:uint = 16;
		
		/**
		 * The thickness of Draw.linePlus in AudioLevelBar
		 */
		public static const AUDIOBARTHICK:uint = 4;
		
		/**
		 * The distance between two AudioLevelBar's
		 */
		public static const AUDIOBARPAD:uint = 6; // Distance between each audio bar
		
		public static const STR_SOUNDFX:String = "Sound FX";
		public static const STR_MUSIC:String = "Music";
		
		/**
		 * Matches the text strings of soundFX:OptionsMenuText & music:OptionsMenuText in OptionsMenu
		 */
		public static var audioTypeStrs:Array = [STR_SOUNDFX, STR_MUSIC];
		
		
		
		/* GAME PLAY */
		/**
		 * The per-space duration it takes for a PushBlock to move
		 */
		public static const PUSHBLOCK_MOVERATE:Number = .15;
		
		/**
		 * The block movement ease
		 */
		public static const PUSHBLOCK_MOVEEASE:Function = Ease.quadIn;
		
		/**
		 * The base layer for game play GUI objects
		 */
		public static const GPGUILAYER:int = -4;
		
		/**
		 * The base layer for PushBlock
		 */
		public static const PUSHBLOCK_LAYER:int = -3;
		
		/**
		 * The maximum allowed moves in a room
		 */
		public static const MAXGAMEMOVES:uint = 256;
		
		/**
		 * The maximum allowed time to complete a room (in seconds)
		 */
		public static const MAXROOMTIME:uint = 96 * 60;
		
		
		
		/* ROOM SELECT */
		/**
		 * Room Select Bottom Side Buttons Center Offset
		 * 
		 * The distance between the x center of the text button
		 * and FP.halfWidth
		 */
		public static function get RSBSBCO():uint { return Math.round(FP.width * .36); }
		
		
		
		/* ROOM DESIGNER */
		/**
		 * Switch Client Creator Tile Type Changer Center Offset
		 * The distance between the x center of the game and the 
		 * x center of a TileTypeChanger
		 */
		// public static const SCCTTCCO:uint = ;
		
		/**
		 * The maximum text size for the RoomNamer text
		 */
		public static const MAXTEXTSIZERN:uint = 36;
		
		/**
		 * The minimum text size for the RoomNamer text
		 */
		public static const MINTEXTSIZERN:uint = 16;
		
		/**
		 * The maximum textWidth limit for a room name at text size 16
		 */
		public static const ROOMNAMEMAXTEXTWIDTH:uint = 244;
		// public static const ROOMNAMEMAXTEXTWIDTH:uint = 356;
		
		/**
		 * The base layer for SpaceSelector
		 */
		public static const SPACESELECTOR_LAYER:int = -20;
		
		
		
		/* SWITCH TILE */
		
		/**
		 * The number of data objects saved in RoomData for a SwitchClient
		 */
		public static const STC_DATA_COUNT:uint = 9;
		
		public static const SWITCHCLIENT_MOVES_BACKOFFSET:uint = 1;
		
		
		
		/* GAME PIECE ID */
		// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, sequenceBlockImg, glowOrb1b];
		public static const ID_FLOOR:uint 			= Images.imgs.indexOf(Images.floorImg);
		public static const ID_WALL:uint 			= Images.imgs.indexOf(Images.wallImg);
		public static const ID_GOAL:uint 			= Images.imgs.indexOf(Images.goalImg);
		public static const ID_HOLE:uint 			= Images.imgs.indexOf(Images.holeImg);
		public static const ID_SWITCH:uint 			= Images.imgs.indexOf(Images.switchImg);
		public static const ID_BLUEBLOCK:uint 		= Images.imgs.indexOf(Images.blueImg);
		public static const ID_REDBLOCK:uint 		= Images.imgs.indexOf(Images.redImg);
		public static const ID_SEQUENCEBLOCK:uint 	= Images.imgs.indexOf(Images.sequenceBlockImg);
		public static const ID_ORB:uint 			= Images.imgs.indexOf(Images.glowOrb1b);
		// ---------------------------------------------------------------------------------------------------------
		
		
		/**
		 * Creates and returns an array containing all the border space numbers
		 * for any given room dimensions
		 * @param	columnCount		The number of columns
		 * @param	rowCount		The number of rows
		 */
		public static function getBorderIndices(columnCount:uint, rowCount:uint):Array
		{
			var indices:Array = new Array(4);
			for (var i:uint = 0; i < indices.length; i++) indices[i] = new Array;
			
			var diff:uint = columnCount * (rowCount - 1);
			
			
			for (var columnIndex:uint = 0; columnIndex < columnCount; columnIndex++)
			{
				indices[0].push(columnIndex); // Top
				indices[2].push(columnIndex + diff); // Bottom
			}
			
			for (var rowIndex:uint = 0; rowIndex < rowCount; rowIndex++)
			{
				indices[3].push(rowIndex * columnCount); // Left
				indices[1].push((rowIndex * columnCount) + (columnCount - 1)); // Right
			}
			
			
			return indices;
		}
		
		
		
		/* ARRAY */
		
		
		
		/* TEXT */
		
		
		
		/* TWEEN */
		
		
		
		/* MOUSE */
		
		
		
		/* OTHER */
		public static function quitSWF():void
		{
			if (Game.developer) fscommand("quit");
		}
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		/**
		 * Creates and returns an EntityGame object
		 * @param	classType	The Class of the EntityGame
		 * @param	x			The x coordinate to place the EntityGame
		 * @param	y			The y coordinate to place the EntityGame
		 * @param	spaceNum	The space number for the EntityGame
		 * @param	color		The color of the EntityGame
		 */
		public static function createGameEntity(_class:Class, x:Number, y:Number, spaceNum:int = -1):EntityGame
		{
			return EntityGame(FP.world.create(_class))._EntityGame(x, y, spaceNum);
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		/* ENTITY TYPE AND NAME PROPERTY STRINGS */
		public static const TYPE_FallingBlock:String = "FallingBlock";
		public static const TYPE_FileSelectManager:String = "FileSelectManager";
		public static const TYPE_FileSelectObject:String = "FileSelectObject";
		public static const TYPE_FloorTile:String = "FloorTile";
		public static const TYPE_GoalTile:String = "GoalTile";
		public static const TYPE_GridSpace:String = "GridSpace";
		public static const TYPE_GridSpaceIndexText:String = "GridSpaceIndexText";
		public static const TYPE_HoleTile:String = "HoleTile";
		public static const TYPE_InputManager:String = "InputManager";
		public static const TYPE_KeyboardKeyButton:String = "KeyboardKeyButton";
		public static const TYPE_MoveArrow:String = "MoveArrow";
		public static const TYPE_Orb:String = "Orb";
		public static const TYPE_PushBlock:String = "PushBlock";
		public static const TYPE_PushBlockHitbox2:String = "PushBlockHitbox2";
		public static const TYPE_SequenceBlock:String = "SequenceBlock";
		public static const TYPE_SequenceBlockCreator:String = "SequenceBlockCreator";
		public static const TYPE_SequenceNumberText:String = "SequenceNumberText";
		public static const TYPE_SpaceIndexText:String = "SpaceIndexText";
		public static const TYPE_SpaceSelector:String = "SpaceSelector";
		public static const TYPE_SpacesSelectorGamePiece:String = "SpacesSelectorGamePiece";
		public static const TYPE_SwitchClient:String = "SwitchClient";
		public static const TYPE_SwitchClientMovesSetter:String = "SwitchClientMovesSetter";
		public static const TYPE_SwitchTile:String = "SwitchTile";
		public static const TYPE_SwitchTileEditor:String = "SwitchTileEditor";
		public static const TYPE_TitleScreenManager:String = "TitleScreenManager";
		public static const TYPE_TitleScreenSection:String = "TitleScreenSection";
		public static const TYPE_WallTile:String = "WallTile";
		
		public static const SUBTYPE_BlueBlock:String = "BlueBlock";
		public static const SUBTYPE_RedBlock:String = "RedBlock";
		
		public static const NAME_AddRoomToPlaylist:String = "AddRoomToPlaylist";
		public static const NAME_DeleteSaveFile:String = "DeleteSaveFile";
		public static const NAME_FallingBlockManager:String = "FallingBlockManager";
		public static const NAME_FileSelectManager:String = "FileSelectManager";
		public static const NAME_GamePlayManager:String = "GamePlayManager";
		public static const NAME_GoldMedalMovesBtn:String = "GoldMedalMovesBtn";
		public static const NAME_InputManager:String = "InputManager";
		public static const NAME_Manual:String = "Manual";
		public static const NAME_MenuListSelector:String = "MenuListSelector";
		public static const NAME_MousePointer:String = "MousePointer";
		public static const NAME_MousePointer_GM:String = "MousePointer_GM";
		public static const NAME_MousePointer_GP:String = "MousePointer_GP";
		public static const NAME_MousePointer_RS:String = "MousePointer_RS";
		public static const NAME_NewRoom:String = "NewRoom";
		public static const NAME_OptionsListSelector:String = "OptionsListSelector";
		public static const NAME_OptionsMenu:String = "OptionsMenu";
		public static const NAME_OverlayFadeIn:String = "OverlayFadeIn";
		public static const NAME_PanelBackground:String = "PanelBackground";
		public static const NAME_PressSpaceScreen:String = "PressSpaceScreen";
		public static const NAME_PushBlockHighlighter:String = "PushBlockHighlighter";
		public static const NAME_PushBlockMoveManager:String = "PushBlockMoveManager";
		public static const NAME_Room:String = "Room";
		public static const NAME_RoomCompleteScreen:String = "RoomCompleteScreen";
		public static const NAME_RoomDesigner:String = "RoomDesigner";
		public static const NAME_RoomFailedScreen:String = "RoomFailedScreen";
		public static const NAME_RoomNamer:String = "RoomNamer";
		public static const NAME_RoomNamerBtn:String = "RoomNamerBtn";
		public static const NAME_RoomSelect:String = "RoomSelect";
		public static const NAME_RoomTimer:String = "RoomTimer";
		public static const NAME_SequenceBlockCreator:String = "SequenceBlockCreator";
		public static const NAME_SetGoldMedalMoves:String = "SetGoldMedalMoves";
		public static const NAME_SpaceSelector_RD:String = "SpaceSelector_RD";
		public static const NAME_SpaceSelector_STE:String = "SpaceSelector_STE";
		public static const NAME_Stats:String = "Stats";
		public static const NAME_SwitchClientMovesSetter:String = "SwitchClientMovesSetter";
		public static const NAME_SwitchTileEditor:String = "SwitchTileEditor";
		public static const NAME_TitleScreenManager:String = "TitleScreenManager";
		public static const NAME_TitleScreenMenu:String = "TitleScreenMenu";
		public static const NAME_UnsavedDraftWarning:String = "UnsavedDraftWarning";
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}