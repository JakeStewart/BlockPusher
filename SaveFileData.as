package  
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * Handles the saving and loading for data specific to save files
	 */
	public class SaveFileData 
	{
		private static const ROOMCOUNT:uint = RoomData.roomDataClasses.length;
		
		private static const MOVESBEST:String = "_MovesBest";
		private static const BESTTIME:String = "_BestTime";
		private static const ORBSBEST:String = "_OrbsBest";
		private static const MEDAL:String = "_Medal";
		
		private static const SFXLEVELSTR:String = "SFXLevel";
		private static const MUSICLEVELSTR:String = "MusicLevel";
		// ------------------------------------------------------------------------------------------
		
		
		public static function loadStatsData(saveFileNum:uint):Array
		{
			var roomNames:Array = new Array(ROOMCOUNT);
			var room:XML;
			for (var i:uint = 0; i < ROOMCOUNT; i++)
			{
				room = FP.getXML(RoomData.roomDataClasses[i]);
				roomNames[i] = room.@roomName;
			}
			
			
			
			
			Data.load("SaveFile" + saveFileNum.toString());
			
			var movesBestData:Array = new Array(ROOMCOUNT);
			var bestTimeData:Array = new Array(ROOMCOUNT);
			var orbsBestData:Array = new Array(ROOMCOUNT);
			var medalsData:Array = new Array(ROOMCOUNT);
			
			for (var j:uint = 0; j < ROOMCOUNT; j++)
			{
				movesBestData[j] = Data.readInt("Room" + (j + 1).toString() + MOVESBEST);
				bestTimeData[j] = Data.readUint("Room" + (j + 1).toString() + BESTTIME);
				orbsBestData[j] = Data.readUint("Room" + (j + 1).toString() + ORBSBEST);
				medalsData[j] = Data.readUint("Room" + (j + 1).toString() + MEDAL); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			}
			
			
			
			return [roomNames, movesBestData, medalsData, bestTimeData, orbsBestData];
		}
		
		public static function saveRoomCompleteData(roomNum:uint, movesMade:uint, clearTime:uint, collectedOrbs:uint):void
		{
			var roomCount:uint;
			if (Game.developer) roomCount = RoomData.getRoomCount(RoomData.ROOMFILEPREFIXGP); // Total number of rooms that have been created so far
			else roomCount = RoomData.roomDataClasses.length; // Total number of rooms that have been created so far
			
			var saveFileNum:uint = getSaveFileInUse();
			
			Data.load("SaveFile" + saveFileNum.toString());
			
			
			Data.writeBool("Room" + roomNum.toString() + "_Completed", true);
			
			
			var movesBest:int = Data.readInt("Room" + roomNum.toString() + MOVESBEST);
			if (movesBest == -1 || movesMade < movesBest) Data.writeInt("Room" + roomNum.toString() + MOVESBEST, movesMade);
			
			var bestTime:int = Data.readUint("Room" + roomNum.toString() + BESTTIME);
			if (bestTime == 0 || clearTime < bestTime) Data.writeUint("Room" + roomNum.toString() + BESTTIME, clearTime);
			
			var orbsBest:uint = Data.readUint("Room" + roomNum.toString() + ORBSBEST);
			if (collectedOrbs > orbsBest) Data.writeUint("Room" + roomNum.toString() + ORBSBEST, collectedOrbs);
			
			if (roomNum < roomCount) Data.writeUint("CurrentRoom", roomNum + 1);
			
			
			Data.save("SaveFile" + saveFileNum.toString());
		}
		
		public static function getMovesBest(roomNum:uint):int
		{
			Data.load("SaveFile" + getSaveFileInUse().toString());
			return Data.readInt("Room" + roomNum.toString() + MOVESBEST);
		}
		
		public static function getBestTime(roomNum:uint):int
		{
			Data.load("SaveFile" + getSaveFileInUse().toString());
			return Data.readUint("Room" + roomNum.toString() + BESTTIME);
		}
		
		public static function getOrbsBest(roomNum:uint):int
		{
			Data.load("SaveFile" + getSaveFileInUse().toString());
			return Data.readUint("Room" + roomNum.toString() + ORBSBEST);
		}
		// ------------------------------------------------------------------------------------------
		
		
		public static function getRoomCompleteCount(saveFileNum:uint):uint
		{
			Data.load("SaveFile" + saveFileNum.toString());
			
			
			var count:uint = 0;
			
			for (var i:uint = 0; i < ROOMCOUNT; i++)
			{
				if (Data.readBool("Room" + (i + 1).toString() + "_Completed")) count++;
				else i = ROOMCOUNT;
			}
			
			
			return count;
		}
		
		public static function getCurrentRoomNum(saveFileNum:uint):uint
		{
			Data.load("SaveFile" + saveFileNum.toString());
			return Data.readUint("CurrentRoom");
		}
		// ------------------------------------------------------------------------------------------
		
		
		public static function onFirstLaunch():void
		{
			Data.load("SaveFilesInfo");
			
			
			// -1 means the save file hasn't been started yet
			Data.writeInt("File1State", -1);
			Data.writeInt("File2State", -1);
			Data.writeInt("File3State", -1);
			
			Data.writeUint("FileInUse", 0);
			
			
			Data.save("SaveFilesInfo");
		}
		
		public static function newSaveFile(saveFileNum:uint):void
		{
			Data.load("SaveFilesInfo");
			Data.writeInt("File" + saveFileNum.toString() + "State", 1);
			Data.writeUint("FileInUse", saveFileNum);
			Data.save("SaveFilesInfo");
			// ---------------------------------------------------
			
			
			Data.load("SaveFile" + saveFileNum.toString());
			
			
			Data.writeUint("CurrentRoom", 1); // Used by CONTINUE option in TitleMenu
			
			
			
			for (var i:uint = 0; i < ROOMCOUNT; i++)
			{
				Data.writeInt("Room" + (i + 1).toString() + MOVESBEST, -1);
				Data.writeUint("Room" + (i + 1).toString() + BESTTIME, 0);
				Data.writeUint("Room" + (i + 1).toString() + ORBSBEST, 0);
				Data.writeUint("Room" + (i + 1).toString() + MEDAL, 0); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
				Data.writeBool("Room" + (i + 1).toString() + "_Completed", false);
			}
			
			
			
			Data.writeUint("SFXLevel", 10);
			Data.writeUint("MusicLevel", 6);
			Data.writeBool("Mute", false);
			
			
			Data.save("SaveFile" + saveFileNum.toString());
			
			
			
			RoomData.onNewSaveFile(saveFileNum);
		}
		
		public static function deleteSaveFile(saveFileNum:uint):void
		{
			Data.load("SaveFilesInfo");
			Data.writeInt("File" + saveFileNum.toString() + "State", -1);
			Data.save("SaveFilesInfo");
			
			RoomData.deleteSaveFile(saveFileNum);
		}
		// ------------------------------------------------------------------------------------------
		
		
		public static function getSaveFileInUse():uint
		{
			Data.load("SaveFilesInfo");
			return Data.readUint("FileInUse");
		}
		
		public static function setSaveFileInUse(saveFileNum:uint):uint
		{
			Data.load("SaveFilesInfo");
			Data.writeUint("FileInUse", saveFileNum);
			
			Data.save("SaveFilesInfo");
			
			
			return saveFileNum;
		}
		
		public static function getSaveFileState(saveFileNum:uint):int
		{
			Data.load("SaveFilesInfo");
			return Data.readInt("File" + saveFileNum.toString() + "State");
		}
		// ------------------------------------------------------------------------------------------
		
		
		public static function setSFXLevel(moreOrLess:int):void
		{
			var saveFileNum:uint = getSaveFileInUse();
			Data.load("SaveFile" + saveFileNum.toString());
			
			
			var level:uint = Data.readUint("SFXLevel");
			if (level + moreOrLess > -1 && level + moreOrLess < 11) level += moreOrLess;
			
			Data.writeUint("SFXLevel", level);
			
			
			Data.save("SaveFile" + saveFileNum.toString());
		}
		
		public static function getSFXLevel():uint
		{
			var saveFileNum:uint = getSaveFileInUse();
			if (saveFileNum == 0) return 10; // No save files created
			Data.load("SaveFile" + saveFileNum.toString());
			return Data.readUint("SFXLevel");
		}
		
		public static function setMusicLevel(moreOrLess:int):void
		{
			var saveFileNum:uint = getSaveFileInUse();
			Data.load("SaveFile" + saveFileNum.toString());
			
			
			var level:uint = Data.readUint("MusicLevel");
			if (level + moreOrLess > -1 && level + moreOrLess < 11) level += moreOrLess;
			
			Data.writeUint("MusicLevel", level);
			
			
			Data.save("SaveFile" + saveFileNum.toString());
		}
		
		public static function getMusicLevel():uint
		{
			var saveFileNum:uint = getSaveFileInUse();
			Data.load("SaveFile" + saveFileNum.toString());
			return Data.readUint("MusicLevel");
		}
		
		public static function toggleMute():void
		{
			var saveFileNum:uint = getSaveFileInUse();
			Data.load("SaveFile" + saveFileNum.toString());
			
			if (Data.readBool("Mute")) Data.writeBool("Mute", false); // If "Mute" is true, change it to false
			else Data.writeBool("Mute", true); // If "Mute" is false, change it to true
			
			Data.save("SaveFile" + saveFileNum.toString());
		}
		// ------------------------------------------------------------------------------------------
		
		
		private static function swapRoomStats(roomNum1:uint, roomNum2:uint):void
		{
			var roomFileName:String;
			var saveFileName:String = "SaveFile" + getSaveFileInUse().toString();
			
			
			Data.load(saveFileName);
			trace(saveFileName + " loaded...");
			trace("");
			trace("");
			trace("");
			
			
			
			
			trace("READING DATA:");
			trace("");
			
			roomFileName = "Room" + roomNum1.toString();
			var room1MovesBest:int = Data.readInt(roomFileName + MOVESBEST);
			var room1BestTime:int = Data.readUint(roomFileName + BESTTIME);
			var room1OrbsBest:uint = Data.readUint(roomFileName + ORBSBEST);
			var room1Medal:uint = Data.readUint(roomFileName + MEDAL); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			
			if (room1BestTime == -1) room1BestTime = 0; // This is a fix
			
			traceRoomStat(MOVESBEST, room1MovesBest);
			traceRoomStat(BESTTIME, room1BestTime);
			traceRoomStat(ORBSBEST, room1OrbsBest);
			traceRoomStat(MEDAL, room1Medal);
			trace("");
			
			roomFileName = "Room" + roomNum2.toString();
			var room2MovesBest:int = Data.readInt(roomFileName + MOVESBEST);
			var room2BestTime:int = Data.readUint(roomFileName + BESTTIME);
			var room2OrbsBest:uint = Data.readUint(roomFileName + ORBSBEST);
			var room2Medal:uint = Data.readUint(roomFileName + MEDAL); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			
			if (room2BestTime == -1) room2BestTime = 0; // This is a fix
			
			traceRoomStat(MOVESBEST, room2MovesBest);
			traceRoomStat(BESTTIME, room2BestTime);
			traceRoomStat(ORBSBEST, room2OrbsBest);
			traceRoomStat(MEDAL, room2Medal);
			trace("");
			trace("");
			
			
			
			
			trace("CHANGING DATA:");
			trace("");
			
			roomFileName = "Room" + roomNum1.toString();
			Data.writeInt(roomFileName + MOVESBEST, room2MovesBest);
			Data.writeUint(roomFileName + BESTTIME, room2BestTime);
			Data.writeUint(roomFileName + ORBSBEST, room2OrbsBest);
			Data.writeUint(roomFileName + MEDAL, room2Medal); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			confirmChange();
			trace("");
			
			roomFileName = "Room" + roomNum2.toString();
			Data.writeInt(roomFileName + MOVESBEST, room1MovesBest);
			Data.writeUint(roomFileName + BESTTIME, room1BestTime);
			Data.writeUint(roomFileName + ORBSBEST, room1OrbsBest);
			Data.writeUint(roomFileName + MEDAL, room1Medal); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			confirmChange();
			trace("");
			trace("");
			trace("");
			
			
			
			
			
			Data.save(saveFileName);
			trace("..." + saveFileName + " saved.");
			trace("------------------------------");
			trace("");
			trace("");
			
			
			
			
			
			function traceRoomStat(statName:String, statVal:int):void
			{
				trace(roomFileName + statName + ": " + statVal.toString());
			}
			
			function confirmChange():void
			{
				trace(roomFileName + MOVESBEST + ": ", Data.readInt(roomFileName + MOVESBEST));
				trace(roomFileName + BESTTIME + ": ", Data.readUint(roomFileName + BESTTIME));
				trace(roomFileName + ORBSBEST + ": ", Data.readUint(roomFileName + ORBSBEST));
				trace(roomFileName + MEDAL + ": ", Data.readUint(roomFileName + MEDAL));
			}
		}
		
		private static function eraseRoomStats(roomNum:uint):void
		{
			var roomFileName:String;
			var saveFileName:String = "SaveFile" + getSaveFileInUse().toString();
			
			
			Data.load(saveFileName);
			trace(saveFileName + " loaded...");
			trace("");
			trace("");
			
			
			
			trace("READING DATA:");
			trace("");
			
			roomFileName = "Room" + roomNum.toString();
			var movesBest:int = Data.readInt(roomFileName + MOVESBEST);
			var bestTime:int = Data.readUint(roomFileName + BESTTIME);
			var orbsBest:uint = Data.readUint(roomFileName + ORBSBEST);
			var medal:uint = Data.readUint(roomFileName + MEDAL); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			
			traceRoomStat(MOVESBEST, movesBest);
			traceRoomStat(BESTTIME, bestTime);
			traceRoomStat(ORBSBEST, orbsBest);
			traceRoomStat(MEDAL, medal);
			trace("");
			trace("");
			
			
			
			trace("CHANGING DATA:");
			trace("");
			
			Data.writeInt(roomFileName + MOVESBEST, -1);
			Data.writeUint(roomFileName + BESTTIME, 0);
			Data.writeUint(roomFileName + ORBSBEST, 0);
			Data.writeUint(roomFileName + MEDAL, 0); // 0: no medal yet, 1: Bronze, 2: Silver, 3: Gold
			confirmChange();
			trace("");
			
			
			
			Data.save(saveFileName);
			trace("..." + saveFileName + " saved.");
			trace("------------------------------");
			trace("");
			trace("");
			
			
			
			
			
			function traceRoomStat(statName:String, statVal:int):void
			{
				trace(roomFileName + statName + ": " + statVal.toString());
			}
			
			function confirmChange():void
			{
				trace(roomFileName + MOVESBEST + ": ", Data.readInt(roomFileName + MOVESBEST));
				trace(roomFileName + BESTTIME + ": ", Data.readUint(roomFileName + BESTTIME));
				trace(roomFileName + ORBSBEST + ": ", Data.readUint(roomFileName + ORBSBEST));
				trace(roomFileName + MEDAL + ": ", Data.readUint(roomFileName + MEDAL));
			}
		}
		// ------------------------------------------------------------------------------------------
		
		
		// For adding or adjusting save file data during development
		public static function changeData():void
		{
			changeData2();
		}
		
		private static function changeData1():void
		{
			swapRoomStats(57, 56);
		}
		
		private static function changeData2():void
		{
			var startRoom:uint = 47;
			var count:uint = (RoomData.roomDataClasses.length + 1) - startRoom;
			for (var i:uint = 0; i < count; i++) eraseRoomStats(startRoom + i);
		}
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------
		
		
	}
	
}