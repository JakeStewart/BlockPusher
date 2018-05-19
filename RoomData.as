package  
{
	import flash.geom.Point;
	import flash.net.FileReference;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * Handles both loading and saving data through both SharedObjects and XML files
	 */
	public final class RoomData 
	{
		public static const ROOMTOSCREENPERCENTAGE:Number = .7525;
		
		public static const ROOMFILEPREFIXGP:String = "Room_";
		private static const USERFILEPREFIX:String = "User";
		private static const DRAFTPREFIX:String = "RoomDraft_" + USERFILEPREFIX;
		public static const XMLFILEPREFIX:String = ROOMFILEPREFIXGP;
		
		/**
		 * For RoomDesigner.playlistFileName to indicate the design did not originate
		 * from a room in a playlist and was started from blank.
		 */
		public static const NOTONFILE:String = "Not on file";
		// ------------------------------------------------------------------------------------------------
		
		
		public static function loadRoomData(fileName:String):Array
		{
			trace("Loading local data...");
			
			Data.load(fileName);
			trace(fileName);
			
			
			
			var playlistFileName:String = Data.readString("playlistFileName");
			
			var roomName:String = Data.readString("roomName");
			
			
			const TOPLEFT_GRIDINDEX:int = Data.readInt("topLeftGridIndex"); // -1 means this save is a empty RoomDesigner grid
			const COLUMN_COUNT:uint = Data.readUint("roomWidth");
			const ROW_COUNT:uint = Data.readUint("roomHeight");
			
			const MOVESQUALGOLD:uint = Data.readUint("movesQualGold");
			
			
			var imgNums:Array = new Array(COLUMN_COUNT * ROW_COUNT);
			for (var i:uint = 0; i < imgNums.length; i++) imgNums[i] = Data.readUint("imgNum" + (i + 1).toString());
			
			var blues:Array = new Array(Data.readUint("blueCount"));
			var reds:Array = new Array(Data.readUint("redCount"));
			
			for (var p:uint = 0; p < blues.length; p++) blues[p] = Data.readUint("blue" + (p + 1).toString());
			for (var q:uint = 0; q < reds.length; q++) reds[q] = Data.readUint("red" + (q + 1).toString());
			
			
			var name:String;
			
			var sbData:Array = new Array(Data.readUint("bfCount")); // The count variables are important! For avoiding old data.
			for (var r:uint = 0; r < sbData.length; r++)
			{
				sbData[r] = new Array(4);
				
				name = "bf" + (r + 1).toString() + "Data1";
				sbData[r][0] = Data.readUint(name);
				
				name = "bf" + (r + 1).toString() + "Data2";
				sbData[r][1] = Data.readUint(name);
				
				
				
				var count:uint = Data.readUint("bf" + (r + 1).toString() + "SeqCount");
				
				sbData[r][2] = new Array(count);
				for (var s:uint = 0; s < count; s++)
				{
					name = "bf" + (r + 1).toString() + "Data" + (s + 1 + 2).toString();
					sbData[r][2][s] = Data.readUint(name);
				}
				
				sbData[r][3] = new Array(count);
				for (var t:uint = 0; t < count; t++)
				{
					name = "bf" + (r + 1).toString() + "Data" + (t + 1 + 2 + sbData[r][3].length).toString();
					sbData[r][3][t] = Data.readUint(name);
				}
			}
			
			
			
			var stCount:uint = Data.readUint("stCount");
			var stData:Array = new Array(stCount); // The count variables are important! For avoiding old data.
			var stClientData:Array = new Array(stCount);
			
			for (var j:uint = 0; j < stCount; j++) // The count variables are important! For avoiding old data.
			{
				stData[j] = new Array(4);
				stData[j][0] = Data.readInt("st" + (j + 1).toString() + "GridIndex");
				stData[j][1] = Data.readInt("st" + (j + 1).toString() + "RoomIndex");
				stData[j][2] = Data.readInt("outline" + (j + 1).toString() + "color1Index");
				stData[j][3] = Data.readInt("outline" + (j + 1).toString() + "color2Index");
				
				
				name = "st" + (j + 1).toString() + "ClientCount";
				var clientCount:uint = Data.readUint(name);
				
				stClientData[j] = new Array(clientCount);
				for (var k:uint = 0; k < clientCount; k++) // The count variables are important! For avoiding old data.
				{
					stClientData[j][k] = new Array(Game.STC_DATA_COUNT);
					for (var m:uint = 0; m < Game.STC_DATA_COUNT; m++)
					{
						name = "st" + (j + 1).toString() + "c" + (k + 1).toString() + "Data" + (m + 1).toString();
						stClientData[j][k][m] = Data.readUint(name);
					}
				}
			}
			
			
			var orbCount:uint = Data.readUint("orbCount");
			var orbData:Array = new Array(orbCount);
			
			for (var u:uint = 0; u < orbCount; u++)
			{
				orbData[u] = new Array(2);
				orbData[u][0] = Data.readUint("orb" + (u + 1).toString() + "GridIndex");
				orbData[u][1] = Data.readUint("orb" + (u + 1).toString() + "RoomIndex");
			}
			
			
			
			trace("...data loaded: ");
			trace("");
			
			
			
			
			return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, sbData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
		}
		
		public static function saveRoomData(names:Array, data:Array, isAddingRoom:Boolean, isDraftSave:Boolean = false, xmlRoomNum:int = -1):String
		{
			// Most things need a 'count' Data saved so when a file is written over with less data
			// loading that file doesn't go beyond the new data and try to use the old data
			
			trace("Saving local data...");
			
			
			// var data:Array = [columnCount, rowCount, imgNums, blues, reds, sbData, stData, stClientData, topLeft, movesQualGold, orbData];
			const COLUMN_COUNT:uint = data[0];
			const ROW_COUNT:uint = data[1];
			var imgNums:Array = data[2];
			var blues:Array = data[3]; // one dim array contains roomIndex for each blue
			var reds:Array = data[4]; // one dim array contains roomIndex for each red
			var sbData:Array = data[5];
			var stData:Array = data[6];
			var stClientData:Array = data[7];
			const TOPLEFT_GRIDINDEX:uint = data[8];
			var movesQualGold:uint = data[9]; // Silver is movesQualGold + 2, Bronze is movesQualGold + 5
			var orbData:Array = data[10];
			
			
			
			var fileName:String = names[0];
			var fileNamePrefix:String = names[2];
			
			if (isAddingRoom)
			{
				var roomCount:uint = getRoomCount(fileNamePrefix); // This will also load an empty data object to save into
				fileName = fileNamePrefix + (roomCount + 1).toString();
			}
			else Data.load(fileName);
			
			trace(fileName);
			
			
			
			Data.writeString(fileName, fileName);
			Data.writeString("roomName", names[1]);
			
			
			var playlistFileName:String = names[3];
			if (isAddingRoom) playlistFileName = fileName;
			Data.writeString("playlistFileName", playlistFileName);
			
			
			Data.writeUint("movesQualGold", movesQualGold);
			
			
			
			Data.writeInt("topLeftGridIndex", TOPLEFT_GRIDINDEX); // -1 means this save is a empty RoomDesigner grid
			Data.writeUint("roomWidth", COLUMN_COUNT), Data.writeUint("roomHeight", ROW_COUNT);
			
			var count:uint = 1;
			for (var i:uint = 0; i < imgNums.length; i++)
			{
				Data.writeUint("imgNum" + count.toString(), imgNums[i]);
				count++;
			}
			
			Data.writeUint("blueCount", blues.length);
			for (var p:uint = 0; p < blues.length; p++) Data.writeUint("blue" + (p + 1).toString(), blues[p]);
			
			Data.writeUint("redCount", reds.length);
			for (var q:uint = 0; q < reds.length; q++) Data.writeUint("red" + (q + 1).toString(), reds[q]);
			
			
			
			var name:String;
			
			Data.writeUint("bfCount", sbData.length);
			for (var r:uint = 0; r < sbData.length; r++) // Each SequenceBlock
			{
				var sbD:Array = sbData[r];
				
				name = "bf" + (r + 1).toString() + "Data1"; // gridIndex
				Data.writeUint(name, sbD[0]);
				
				name = "bf" + (r + 1).toString() + "Data2"; // roomIndex
				Data.writeUint(name, sbD[1]);
				
				
				
				Data.writeUint("bf" + (r + 1).toString() + "SeqCount", sbD[2].length);
				
				for (var s:uint = 0; s < sbD[2].length; s++) // Sequence gridIndices
				{
					name = "bf" + (r + 1).toString() + "Data" + (s + 1 + 2).toString();
					Data.writeUint(name, sbD[2][s]);
				}
				
				for (var t:uint = 0; t < sbD[3].length; t++) // Sequence roomIndices
				{
					name = "bf" + (r + 1).toString() + "Data" + (t + 1 + 2 + sbD[3].length).toString();
					Data.writeUint(name, sbD[3][t]);
				}
			}
			
			
			Data.writeUint("stCount", stData.length);
			for (var j:uint = 0; j < stData.length; j++)
			{
				Data.writeInt("st" + (j + 1).toString() + "GridIndex", stData[j][0]);
				Data.writeInt("st" + (j + 1).toString() + "RoomIndex", stData[j][1]);
				Data.writeInt("outline" + (j + 1).toString() + "color1Index", stData[j][2]);
				Data.writeInt("outline" + (j + 1).toString() + "color2Index", stData[j][3]);
				
				var clients:Array = stClientData[j];
				
				Data.writeUint("st" + (j + 1).toString() + "ClientCount", clients.length)
				for (var k:uint = 0; k < clients.length; k++)
				{
					var clientData:Array = clients[k];
					for (var m:uint = 0; m < Game.STC_DATA_COUNT; m++)
					{
						name = "st" + (j + 1).toString() + "c" + (k + 1).toString() + "Data" + (m + 1).toString();
						Data.writeUint(name, clientData[m]);
					}
				}
			}
			
			Data.writeUint("orbCount", orbData.length);
			for (var u:uint = 0; u < orbData.length; u++)
			{
				Data.writeUint("orb" + (u + 1).toString() + "GridIndex", orbData[u][0]);
				Data.writeUint("orb" + (u + 1).toString() + "RoomIndex", orbData[u][1]);
			}
			
			
			
			Data.save(fileName);
			
			trace("...data saved: ");
			trace("");
			
			
			
			
			return playlistFileName;
		}
		
		public static function loadRoomDataXML(classIndex:uint):Array
		{
			trace("Loading XML data...");
			
			var data:Array = new Array(13);
			var room:XML = FP.getXML(RoomData.roomDataClasses[classIndex]);
			
			data[0] = String(room.@playlistFileName);
			data[1] = String(room.@roomName);
			data[2] = int(room.@columnCount);
			data[3] = int(room.@rowCount);
			data[4] = getXMLList(room.imgNums.imgNum, room.imgNums.@count);
			data[5] = getXMLList(room.blueIndices.roomIndex, room.blueIndices.@count);
			data[6] = getXMLList(room.redIndices.roomIndex, room.redIndices.@count);
			data[7] = getSBDataXML();
			data[8] = getSTDataXML();
			data[9] = getSTClientDataXML();
			data[10] = getOrbDataXML();
			data[11] = int(room.@topLeftGridIndex);
			data[12] = int(room.@movesQualGold);
			
			trace("...data loaded: ");
			trace("");
			
			
			return data;
			
			
			
			function getXMLList(xmlList:XMLList, count:uint):Array
			{
				var list:Array = new Array(count);
				for (var i:uint = 0; i < count; i++) list[i] = int(xmlList[i]);
				
				return list;
			}
			
			function getSBDataXML():Array
			{
				var sbData1:Array = new Array;
				
				for (var i:uint = 0; i < room.bfTiles.@count; i++)
				{
					sbData1.push(new Array(4));
					sbData1[i][0] = int(room.bfTiles.bfTile[i].@gridIndex);
					sbData1[i][1] = int(room.bfTiles.bfTile[i].@roomIndex);
					
					sbData1[i][2] = new Array(room.bfTiles.bfTile[i].sequenceIndices.@count);
					sbData1[i][3] = new Array(room.bfTiles.bfTile[i].sequenceIndices.@count);
					
					for (var j:uint = 0; j < room.bfTiles.bfTile[i].sequenceIndices.@count; j++)
					{
						sbData1[i][2][j] = int(room.bfTiles.bfTile[i].sequenceIndices.grid[j]);
						sbData1[i][3][j] = int(room.bfTiles.bfTile[i].sequenceIndices.room[j]);
					}
				}
				
				return sbData1;
			}
			
			function getSTDataXML():Array
			{
				if (room.switchTiles.@count == 0) return new Array(0);
				
				var stData1:Array = new Array;
				for (var i:uint = 0; i < room.switchTiles.@count; i++) // Each SwitchTile
				{
					stData1[i] = new Array(4);
					stData1[i][0] = int(room.switchTiles.switchTile[i].gridIndex);
					stData1[i][1] = int(room.switchTiles.switchTile[i].roomIndex);
					stData1[i][2] = int(room.switchTiles.switchTile[i].outlineColor1); // color index, not 0x color value
					stData1[i][3] = int(room.switchTiles.switchTile[i].outlineColor2); // color index, not 0x color value
				}
				
				return stData1;
			}
			
			function getSTClientDataXML():Array
			{
				if (room.switchTiles.@count == 0) return new Array(0);
				
				var stClientData1:Array = new Array;
				var count:uint;
				
				stClientData1.push(new Array(room.switchTiles.@count));
				
				for (var i:uint = 0; i < room.switchTiles.@count; i++) // Each SwitchTile
				{
					count = room.switchTiles.switchTile[i].clients.@count;
					stClientData1[i] = new Array(count);
					
					for (var j:uint = 0; j < count; j++) // Each client
					{
						stClientData1[i][j] = new Array(Game.STC_DATA_COUNT);
						for (var k:uint = 0; k < Game.STC_DATA_COUNT; k++)
						{
							stClientData1[i][j][k] = int(room.switchTiles.switchTile[i].clients.client[j].data[k]);
						}
					}
				}
				
				
				return stClientData1;
				
				
				/*
				stClientData[i][j][0] = sc.x;
				stClientData[i][j][1] = sc.y;
				stClientData[i][j][2] = sc.activeNum;
				stClientData[i][j][3] = sc.inactiveNum;
				stClientData[i][j][4] = sc.gridIndex;
				stClientData[i][j][5] = sc.hostGridIndex;
				stClientData[i][j][6] = sc.roomIndex;
				stClientData[i][j][7] = sc.hostRoomIndex;
				stClientData[i][j][8] = sc.moves;
				*/
				
				
			}
			
			function getOrbDataXML():Array
			{
				if (room.orbs.@count == 0) return new Array(0);
				
				var orbData:Array = new Array(room.orbs.@count);
				for (var i:uint = 0; i < room.orbs.@count; i++)
				{
					orbData[i] = new Array(2);
					orbData[i][0] = int(room.orbs.orb[i].gridIndex);
					orbData[i][1] = int(room.orbs.orb[i].roomIndex);
				}
				
				return orbData;
			}
		}
		
		public static function saveRoomDataXML(names:Array, data:Array, xmlRoomNum:int, isAddingRoom:Boolean):String
		{
			var room:XML = new XML(<room />);
			var imgNums:XML = new XML(<imgNums />);
			var blueIndices:XML = new XML(<blueIndices />); // For storing BlueBlock.roomIndex
			var redIndices:XML = new XML(<redIndices />); // For storing RedBlock.roomIndex
			var bfTiles:XML = new XML(<bfTiles />);
			var switchTiles:XML = new XML(<switchTiles />);
			var orbs:XML = new XML(<orbs />);
			
			
			var playlistFileName:String;
			if (isAddingRoom) playlistFileName = RoomData.XMLFILEPREFIX + (RoomData.roomDataClasses.length + 1).toString(); // adding a room
			else playlistFileName = RoomData.XMLFILEPREFIX + xmlRoomNum.toString(); // saving changes
			
			// var names:Array = [fileName, roomName, filePrefix, playlistFileName];
			// var data:Array = [columnCount, rowCount, imgNums, blues, reds, sbData, stData, stClientData, topLeft, movesQualGold, orbData];
			room.@playlistFileName = playlistFileName;
			room.@roomName = names[1];
			room.@topLeftGridIndex = data[8];
			room.@columnCount = data[0];
			room.@rowCount = data[1];
			room.@movesQualGold = data[9];
			
			
			
			imgNums.@count = data[2].length;
			for (var i:uint = 0; i < data[2].length; i++)
			{
				imgNums.appendChild(new XML("<imgNum>" + data[2][i].toString() + "</imgNum>"));
			}
			
			
			blueIndices.@count = data[3].length;
			for (var j:uint = 0; j < data[3].length; j++)
			{
				blueIndices.appendChild(new XML("<roomIndex>" + data[3][j].toString() + "</roomIndex>"));
			}
			
			redIndices.@count = data[4].length;
			for (var k:uint = 0; k < data[4].length; k++)
			{
				redIndices.appendChild(new XML("<roomIndex>" + data[4][k].toString() + "</roomIndex>"));
			}
			
			
			var sbData:Array = data[5];
			bfTiles.@count = sbData.length;
			for (var m:uint = 0; m < sbData.length; m++)
			{
				var bfTile:XML = new XML(<bfTile />);
				bfTile.@gridIndex = sbData[m][0];
				bfTile.@roomIndex = sbData[m][1];
				
				
				var sequenceIndices:XML = new XML(<sequenceIndices />);
				sequenceIndices.@count = sbData[m][2].length;
				
				for (var p:uint = 0; p < sbData[m][2].length; p++)
				{
					sequenceIndices.appendChild(new XML("<grid>" + sbData[m][2][p].toString() + "</grid>"));
				}
				
				for (var r:uint = 0; r < sbData[m][3].length; r++)
				{
					sequenceIndices.appendChild(new XML("<room>" + sbData[m][3][r].toString() + "</room>"));
				}
				
				
				bfTile.appendChild(sequenceIndices);
				bfTiles.appendChild(bfTile);
			}
			
			
			var stData:Array = data[6];
			var stClientData:Array = data[7];
			switchTiles.@count = stData.length;
			for (var s:uint = 0; s < stData.length; s++)
			{
				var switchTile:XML = new XML(<switchTile />);
				switchTile.appendChild(new XML("<gridIndex>" + stData[s][0].toString() + "</gridIndex>"));
				switchTile.appendChild(new XML("<roomIndex>" + stData[s][1].toString() + "</roomIndex>"));
				switchTile.appendChild(new XML("<outlineColor1>" + stData[s][2].toString() + "</outlineColor1>"));
				switchTile.appendChild(new XML("<outlineColor2>" + stData[s][3].toString() + "</outlineColor2>"));
				
				
				var clients:XML = new XML(<clients />);
				clients.@count = stClientData[s].length;
				
				for (var t:uint = 0; t < stClientData[s].length; t++) // Each Client
				{
					var client:XML = new XML(<client />);
					for (var u:uint = 0; u < stClientData[s][t].length; u++) // Each Data
					{
						client.appendChild(new XML("<data>" + stClientData[s][t][u].toString() + "</data>"));
					}
					
					clients.appendChild(client);
				}
				
				
				switchTile.appendChild(clients);
				switchTiles.appendChild(switchTile);
			}
			
			
			var orbData:Array = data[10];
			orbs.@count = orbData.length;
			for (var v:uint = 0; v < orbData.length; v++)
			{
				var orb:XML =  new XML(<orb />);
				orb.appendChild(new XML("<gridIndex>" + orbData[v][0].toString() + "</gridIndex>"));
				orb.appendChild(new XML("<roomIndex>" + orbData[v][1].toString() + "</roomIndex>"));
				
				orbs.appendChild(orb);
			}
			
			
			
			
			room.appendChild(imgNums);
			room.appendChild(blueIndices);
			room.appendChild(redIndices);
			room.appendChild(bfTiles);
			room.appendChild(switchTiles);
			room.appendChild(orbs);
			
			
			
			
			var fileName:String = playlistFileName + ".xml";
			
			var fileRef:FileReference = new FileReference;
			fileRef.save(room, fileName);
			
			
			
			trace("Request save: " + fileName);
			
			return playlistFileName;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		public static function getMovesQualGoldData():Array
		{
			var data:Array = new Array;
			var room:XML;
			
			for (var i:uint = 0; i < RoomData.roomDataClasses.length; i++)
			{
				room = FP.getXML(RoomData.roomDataClasses[i]);
				data.push(int(room.@movesQualGold));
			}
			
			
			return data;
		}
		
		public static function getOrbsPossibleData():Array
		{
			var data:Array = new Array;
			var room:XML;
			
			for (var i:uint = 0; i < RoomData.roomDataClasses.length; i++)
			{
				room = FP.getXML(RoomData.roomDataClasses[i]);
				data.push(int(room.orbs.@count));
			}
			
			
			return data;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		public static function onNewSaveFile(saveFileNum:uint):void
		{
			eraseRoom(DRAFTPREFIX + saveFileNum.toString());
		}
		
		public static function draftIsEmpty():Boolean
		{
			Data.load(getDraftName());
			if (Data.readInt("topLeftGridIndex") == -1) return true;
			
			
			return false;
		}
		
		public static function getRoomCount(fileNamePrefix:String):uint
		{
			// For story mode rooms (xml files)
			if (fileNamePrefix == RoomData.XMLFILEPREFIX) return roomDataClasses.length;
			
			
			// For user designed rooms (SharedObject files)
			var roomCount:uint = 1;
			var fileName:String;
			countLoop();
			
			function countLoop():void
			{
				fileName = fileNamePrefix + roomCount.toString();
				Data.load(fileName); // If the file hasn't been created yet, this creates one
				
				if (fileName == Data.readString(fileName) // If the file exists, it should have a property matching the fileName
					&& Data.readInt("topLeftGridIndex") != -1) // If the file isn't a blank file (deleted file)
				{
					roomCount++;
					countLoop();
				}
				else roomCount--; // This ends countLoop
			}
			
			
			
			return roomCount;
		}
		
		public static function eraseRoom(fileName:String):void
		{
			// var names:Array = [fileName, roomName, "Room_", playlistFileName];
			// var data:Array = [columnCount, rowCount, imgNums, blues, reds, sbData, stData, stClientData, topLeft, movesQualGold, orbData];
			var names:Array = [fileName, "Untitled", null, null];
			var data:Array = [0, 0, [], [], [], [], [], [], -1, 1, []]; // The -1 means this save is an erased file. Is used for Data.readInt("topLeftGridIndex")
			saveRoomData(names, data, false);
			
			trace(fileName + " erased!");
			trace("");
		}
		
		public static function deleteSaveFile(saveFileNum:uint):void
		{
			eraseRoom(DRAFTPREFIX + saveFileNum.toString()); // Draft
			
			var userPrefix:String = USERFILEPREFIX + saveFileNum.toString() + "_" + ROOMFILEPREFIXGP;
			var count:uint = getRoomCount(userPrefix);
			
			for (var i:uint = 0; i < count; i++) eraseRoom(userPrefix + (i + 1).toString());
		}
		
		public static function draftIsDifferent(playlistFileName:String, isXML:Boolean = false, xmlClassIndex:int = -1):Boolean
		{
			var savedData:Array;
			
			if (isXML) savedData = loadRoomDataXML(xmlClassIndex);
			else savedData = loadRoomData(playlistFileName);
			
			var draftData:Array = loadRoomData(RoomData.getDraftName());
			
			// return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, sbData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
			if (savedData[2] != draftData[2]) return true;			// column count
			if (savedData[3] != draftData[3]) return true;			// row count
			if (isDiff(savedData[4], draftData[4])) return true;	// imgNums
			if (isDiff(savedData[5], draftData[5])) return true;	// blues
			if (isDiff(savedData[6], draftData[6])) return true;	// reds
			if (isDiff(savedData[7], draftData[7])) return true;	// sbData
			if (isDiff(savedData[8], draftData[8])) return true;	// stData
			if (isDiff(savedData[9], draftData[9])) return true;	// stClientData
			if (isDiff(savedData[10], draftData[10])) return true;	// orbData
			if (savedData[11] != draftData[11]) return true;		// topLeftGridIndex
			if (savedData[12] != draftData[12]) return true;		// movesQualGold
			
			
			return false;
			
			
			
			function isDiff(sList:Array, dList:Array):Boolean
			{
				if (sList.length != dList.length) return true;
				
				for (var i:uint = 0; i < sList.length; i++)
				{
					if (sList[i] is Array)
					{
						if (isDiff(sList[i], dList[i])) return true;
					}
					else if (sList[i] != dList[i]) return true;
				}
				
				
				return false;
			}
		}
		
		public static function getUserPrefix():String
		{
			return USERFILEPREFIX + SaveFileData.getSaveFileInUse().toString() + "_" + ROOMFILEPREFIXGP;
		}
		
		public static function getDraftName():String
		{
			return DRAFTPREFIX + SaveFileData.getSaveFileInUse().toString();
		}
		
		/**
		 * If design is from a story mode room
		 */
		public static function isXMLRoom(playlistFileName:String):Boolean
		{
			// if "xxxxx" == "Room_"
			if (playlistFileName.substring(0, RoomData.XMLFILEPREFIX.length) == RoomData.XMLFILEPREFIX) return true;
			return false;
		}
		
		/**
		 * If design is from a user created room
		 */
		public static function isUserRoom(playlistFileName:String):Boolean
		{
			// if "xxxxxxxxxxx" == "UserX_Room_"
			if (playlistFileName.substring(0, RoomData.getUserPrefix().length) == RoomData.getUserPrefix()) return true;
			return false;
		}
		// ------------------------------------------------------------------------------------------------
		
		
		public static function getAllSpaceCoords(columnCount:uint, rowCount:uint, spaceSize:uint = 32, spacePadding:uint = 6):Array
		{
			var roomWidthLimit:int = Math.round(FP.width * ROOMTOSCREENPERCENTAGE);
			var roomHeightLimit:int = Math.round(FP.height * ROOMTOSCREENPERCENTAGE);
			
			var spaceDiff:uint = spaceSize + spacePadding;
			
			/* Needs to tell user if grid exceeds room size limit */
			// if ((columnCount * spaceDiff) - spacePadding > roomWidthLimit) /* Prompt user to give different dimensions */
			// else if ((rowCount * spaceDiff) - spacePadding > roomHeightLimit) /* Prompt user to give different dimensions */
			
			var coords:Array = new Array(columnCount * rowCount);
			
			var cornerCoords:Point = new Point(0, 0);
			cornerCoords.x = Math.round(FP.halfWidth - getCornerCoord(columnCount));
			cornerCoords.y = Math.round(FP.halfHeight - getCornerCoord(rowCount));
			
			var xOffset:int = 0;
			var yOffset:int = 0;
			
			for (var i:uint = 0; i < coords.length; i++)
			{
				coords[i] = new Point(cornerCoords.x + xOffset, cornerCoords.y + yOffset);
				
				xOffset += spaceDiff;
				if (xOffset == columnCount * spaceDiff) xOffset = 0, yOffset += spaceDiff;
			}
			
			
			
			return coords;
			
			
			
			function getCornerCoord(dimension:uint):Number
			{
				return ((dimension * spaceSize) + ((dimension - 1) * spacePadding)) * .5;
			}
		}
		// ------------------------------------------------------------------------------------------------
		
		
		/* LEVEL  1 */
		[Embed(source = "../assets/data/rooms/Room_1.xml", mimeType = "application/octet-stream")] public static const ROOM1XML:Class;
		[Embed(source = "../assets/data/rooms/Room_2.xml", mimeType = "application/octet-stream")] public static const ROOM2XML:Class;
		[Embed(source = "../assets/data/rooms/Room_3.xml", mimeType = "application/octet-stream")] public static const ROOM3XML:Class;
		[Embed(source = "../assets/data/rooms/Room_4.xml", mimeType = "application/octet-stream")] public static const ROOM4XML:Class;
		[Embed(source = "../assets/data/rooms/Room_5.xml", mimeType = "application/octet-stream")] public static const ROOM5XML:Class;
		[Embed(source = "../assets/data/rooms/Room_6.xml", mimeType = "application/octet-stream")] public static const ROOM6XML:Class;
		[Embed(source = "../assets/data/rooms/Room_7.xml", mimeType = "application/octet-stream")] public static const ROOM7XML:Class;
		[Embed(source = "../assets/data/rooms/Room_8.xml", mimeType = "application/octet-stream")] public static const ROOM8XML:Class;
		[Embed(source = "../assets/data/rooms/Room_9.xml", mimeType = "application/octet-stream")] public static const ROOM9XML:Class;
		[Embed(source = "../assets/data/rooms/Room_10.xml", mimeType = "application/octet-stream")] public static const ROOM10XML:Class;
		
		/* LEVEL  2 */
		[Embed(source = "../assets/data/rooms/Room_11.xml", mimeType = "application/octet-stream")] public static const ROOM11XML:Class;
		[Embed(source = "../assets/data/rooms/Room_12.xml", mimeType = "application/octet-stream")] public static const ROOM12XML:Class;
		[Embed(source = "../assets/data/rooms/Room_13.xml", mimeType = "application/octet-stream")] public static const ROOM13XML:Class;
		[Embed(source = "../assets/data/rooms/Room_14.xml", mimeType = "application/octet-stream")] public static const ROOM14XML:Class;
		[Embed(source = "../assets/data/rooms/Room_15.xml", mimeType = "application/octet-stream")] public static const ROOM15XML:Class;
		[Embed(source = "../assets/data/rooms/Room_16.xml", mimeType = "application/octet-stream")] public static const ROOM16XML:Class;
		[Embed(source = "../assets/data/rooms/Room_17.xml", mimeType = "application/octet-stream")] public static const ROOM17XML:Class;
		[Embed(source = "../assets/data/rooms/Room_18.xml", mimeType = "application/octet-stream")] public static const ROOM18XML:Class;
		[Embed(source = "../assets/data/rooms/Room_19.xml", mimeType = "application/octet-stream")] public static const ROOM19XML:Class;
		[Embed(source = "../assets/data/rooms/Room_20.xml", mimeType = "application/octet-stream")] public static const ROOM20XML:Class;
		
		/* LEVEL  3 */
		[Embed(source = "../assets/data/rooms/Room_21.xml", mimeType = "application/octet-stream")] public static const ROOM21XML:Class;
		[Embed(source = "../assets/data/rooms/Room_22.xml", mimeType = "application/octet-stream")] public static const ROOM22XML:Class;
		[Embed(source = "../assets/data/rooms/Room_23.xml", mimeType = "application/octet-stream")] public static const ROOM23XML:Class;
		[Embed(source = "../assets/data/rooms/Room_24.xml", mimeType = "application/octet-stream")] public static const ROOM24XML:Class;
		[Embed(source = "../assets/data/rooms/Room_25.xml", mimeType = "application/octet-stream")] public static const ROOM25XML:Class;
		[Embed(source = "../assets/data/rooms/Room_26.xml", mimeType = "application/octet-stream")] public static const ROOM26XML:Class;
		[Embed(source = "../assets/data/rooms/Room_27.xml", mimeType = "application/octet-stream")] public static const ROOM27XML:Class;
		[Embed(source = "../assets/data/rooms/Room_28.xml", mimeType = "application/octet-stream")] public static const ROOM28XML:Class;
		[Embed(source = "../assets/data/rooms/Room_29.xml", mimeType = "application/octet-stream")] public static const ROOM29XML:Class;
		[Embed(source = "../assets/data/rooms/Room_30.xml", mimeType = "application/octet-stream")] public static const ROOM30XML:Class;
		
		/* LEVEL  4 */
		[Embed(source = "../assets/data/rooms/Room_31.xml", mimeType = "application/octet-stream")] public static const ROOM31XML:Class;
		[Embed(source = "../assets/data/rooms/Room_32.xml", mimeType = "application/octet-stream")] public static const ROOM32XML:Class;
		[Embed(source = "../assets/data/rooms/Room_33.xml", mimeType = "application/octet-stream")] public static const ROOM33XML:Class;
		[Embed(source = "../assets/data/rooms/Room_34.xml", mimeType = "application/octet-stream")] public static const ROOM34XML:Class;
		[Embed(source = "../assets/data/rooms/Room_35.xml", mimeType = "application/octet-stream")] public static const ROOM35XML:Class;
		[Embed(source = "../assets/data/rooms/Room_36.xml", mimeType = "application/octet-stream")] public static const ROOM36XML:Class;
		[Embed(source = "../assets/data/rooms/Room_37.xml", mimeType = "application/octet-stream")] public static const ROOM37XML:Class;
		[Embed(source = "../assets/data/rooms/Room_38.xml", mimeType = "application/octet-stream")] public static const ROOM38XML:Class;
		[Embed(source = "../assets/data/rooms/Room_39.xml", mimeType = "application/octet-stream")] public static const ROOM39XML:Class;
		[Embed(source = "../assets/data/rooms/Room_40.xml", mimeType = "application/octet-stream")] public static const ROOM40XML:Class;
		
		
		/* LEVEL  5 */
		[Embed(source = "../assets/data/rooms/Room_41.xml", mimeType = "application/octet-stream")] public static const ROOM41XML:Class;
		[Embed(source = "../assets/data/rooms/Room_42.xml", mimeType = "application/octet-stream")] public static const ROOM42XML:Class;
		[Embed(source = "../assets/data/rooms/Room_43.xml", mimeType = "application/octet-stream")] public static const ROOM43XML:Class;
		[Embed(source = "../assets/data/rooms/Room_44.xml", mimeType = "application/octet-stream")] public static const ROOM44XML:Class;
		[Embed(source = "../assets/data/rooms/Room_45.xml", mimeType = "application/octet-stream")] public static const ROOM45XML:Class;
		[Embed(source = "../assets/data/rooms/Room_46.xml", mimeType = "application/octet-stream")] public static const ROOM46XML:Class;
		[Embed(source = "../assets/data/rooms/Room_47.xml", mimeType = "application/octet-stream")] public static const ROOM47XML:Class;
		[Embed(source = "../assets/data/rooms/Room_48.xml", mimeType = "application/octet-stream")] public static const ROOM48XML:Class;
		[Embed(source = "../assets/data/rooms/Room_49.xml", mimeType = "application/octet-stream")] public static const ROOM49XML:Class;
		[Embed(source = "../assets/data/rooms/Room_50.xml", mimeType = "application/octet-stream")] public static const ROOM50XML:Class;
		
		
		/* LEVEL  6 */
		[Embed(source = "../assets/data/rooms/Room_51.xml", mimeType = "application/octet-stream")] public static const ROOM51XML:Class;
		[Embed(source = "../assets/data/rooms/Room_52.xml", mimeType = "application/octet-stream")] public static const ROOM52XML:Class;
		[Embed(source = "../assets/data/rooms/Room_53.xml", mimeType = "application/octet-stream")] public static const ROOM53XML:Class;
		[Embed(source = "../assets/data/rooms/Room_54.xml", mimeType = "application/octet-stream")] public static const ROOM54XML:Class;
		[Embed(source = "../assets/data/rooms/Room_55.xml", mimeType = "application/octet-stream")] public static const ROOM55XML:Class;
		[Embed(source = "../assets/data/rooms/Room_56.xml", mimeType = "application/octet-stream")] public static const ROOM56XML:Class;
		[Embed(source = "../assets/data/rooms/Room_57.xml", mimeType = "application/octet-stream")] public static const ROOM57XML:Class;
		[Embed(source = "../assets/data/rooms/Room_58.xml", mimeType = "application/octet-stream")] public static const ROOM58XML:Class;
		
		/*
		[Embed(source = "../assets/data/rooms/Room_59.xml", mimeType = "application/octet-stream")] public static const ROOM59XML:Class;
		[Embed(source = "../assets/data/rooms/Room_60.xml", mimeType = "application/octet-stream")] public static const ROOM60XML:Class;
		*/
		
		/* LEVEL  7 */
		/*
		[Embed(source = "../assets/data/rooms/Room_61.xml", mimeType = "application/octet-stream")] public static const ROOM61XML:Class;
		[Embed(source = "../assets/data/rooms/Room_62.xml", mimeType = "application/octet-stream")] public static const ROOM62XML:Class;
		[Embed(source = "../assets/data/rooms/Room_63.xml", mimeType = "application/octet-stream")] public static const ROOM63XML:Class;
		[Embed(source = "../assets/data/rooms/Room_64.xml", mimeType = "application/octet-stream")] public static const ROOM64XML:Class;
		[Embed(source = "../assets/data/rooms/Room_65.xml", mimeType = "application/octet-stream")] public static const ROOM65XML:Class;
		[Embed(source = "../assets/data/rooms/Room_66.xml", mimeType = "application/octet-stream")] public static const ROOM66XML:Class;
		[Embed(source = "../assets/data/rooms/Room_67.xml", mimeType = "application/octet-stream")] public static const ROOM67XML:Class;
		[Embed(source = "../assets/data/rooms/Room_68.xml", mimeType = "application/octet-stream")] public static const ROOM68XML:Class;
		[Embed(source = "../assets/data/rooms/Room_69.xml", mimeType = "application/octet-stream")] public static const ROOM69XML:Class;
		[Embed(source = "../assets/data/rooms/Room_70.xml", mimeType = "application/octet-stream")] public static const ROOM70XML:Class;
		*/
		
		
		public static var roomDataClasses:Array = 
		[
			/* LEVEL  1 */	ROOM1XML,  ROOM2XML,  ROOM3XML,  ROOM4XML,  ROOM5XML,  ROOM6XML,  ROOM7XML,  ROOM8XML,  ROOM9XML,  ROOM10XML, 
			/* LEVEL  2 */	ROOM11XML, ROOM12XML, ROOM13XML, ROOM14XML, ROOM15XML, ROOM16XML, ROOM17XML, ROOM18XML, ROOM19XML, ROOM20XML, 
			/* LEVEL  3 */	ROOM21XML, ROOM22XML, ROOM23XML, ROOM24XML, ROOM25XML, ROOM26XML, ROOM27XML, ROOM28XML, ROOM29XML, ROOM30XML, 
			/* LEVEL  4 */	ROOM31XML, ROOM32XML, ROOM33XML, ROOM34XML, ROOM35XML, ROOM36XML, ROOM37XML, ROOM38XML, ROOM39XML, ROOM40XML, 
			/* LEVEL  5 */	ROOM41XML, ROOM42XML, ROOM43XML, ROOM44XML, ROOM45XML, ROOM46XML, ROOM47XML, ROOM48XML, ROOM49XML, ROOM50XML,
			/* LEVEL  6 */	ROOM51XML, ROOM52XML, ROOM53XML, ROOM54XML, ROOM55XML, ROOM56XML, ROOM57XML, ROOM58XML
			/* LEVEL  7 */	
			/* LEVEL  8 */	
			/* LEVEL  9 */	
		];
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
		
		/**
		 * For fixing save data
		 */
		public static function changeData():void
		{
			changeData1();
		}
		
		private static function changeData1():void
		{
			
		}
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------------------------
		
	}

}