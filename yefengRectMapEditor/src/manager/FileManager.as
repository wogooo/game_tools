    package manager
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.UtilString;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import model.TypeFile;
	import model.TypeRoad;
	
	import mx.controls.Alert;
	
	import view.FlexMovieClip;
	import view.MarkMonster;
	import view.MarkObject;
	import view.MonsterZoneClip;

	/**
	 *  创建文件
	 *   2012-7-12
	 *	@author yefeng
	 */
	public class FileManager
	{
		
		public function FileManager()
		{
		}
		
		/**处理路点 地面信息信息
		 */
		private function handleFloor(obj:Object,arr:Vector.<MarkObject>):void
		{
			var len:int=arr.length;
			obj.tileW=RectMapConfig.tileW;
			obj.tileH=RectMapConfig.tileH;
			obj.gridW=RectMapConfig.gridW;
			obj.gridH=RectMapConfig.gridH;
			obj.columns=RectMapConfig.columns;
			obj.rows=RectMapConfig.rows;
			//	var markObj:MarkObject
				var floor:String="";///地面信息
			for each (var markObj:MarkObject in arr)
			{
				///当存在标记点时
				if(markObj) floor +=markObj.myId;
				///当不存在标记点  以可走点处理
				else floor +=TypeRoad.Walk
			}
			obj.floor=floor;
		}
		/** 处理建筑信息
		 */		
		private function handleBuilding(obj:Object,dict:Dictionary):void
		{
			obj.building={};
			var data:Object;
			for (var name:String in dict)
			{
				obj.building[name]=[];
				for each (var movie:FlexMovieClip in dict[name])
				{
					data={};
					data.x=movie.x;
					data.y=movie.y;
					data.scaleX=movie.scaleX;
					data.scaleY=movie.scaleY;
					data.rotation=movie.rotation;
					obj.building[name].push(data);
				}
				///如果长度为0 则进行删除
				if(obj.building[name].length==0) delete obj.building[name]; 
			}
			if(getObjectLen(obj.building)==0) delete obj.building; 
		}
		
		
		
		
		/**处理npc 信息
		 * dict  存储的 是  dict[id]=flexMovieClip
		 */
		private function handleNpc(obj:Object,dict:Dictionary):void
		{
			obj.npc={};
			var data:Object;
			var movie:FlexMovieClip
			for  (var nameId:String in dict)
			{
					
				movie=dict[nameId];
				data={};
				data.x=movie.x;
				data.y=movie.y;
				data.url=UtilString.getFileName(movie.myData.toString());
				obj.npc[nameId]=data
			}
			///如果长度为0 则进行删除
			if(getObjectLen(obj.npc)==0) delete obj.npc;
		}
		
		
		/** 将 npc数据变成xml文件便于策划可调
		 */
		public static  function handleNpcToXML(dict:Dictionary,dir:File,npcFileName:String):void
		{
			npcFileName=npcFileName+"_npc.xml"
			
			var xml:XML=<root><itemsArr /></root>
			var childNode:XML;
			var parentNode:XML;
			var data:Object;
			var movie:FlexMovieClip
			for  (var nameId:String in dict)
			{
				movie=dict[nameId];
				childNode=<item x={movie.x} y={movie.y} url={UtilString.getFileName(String(movie.myData))} id={nameId} />
				xml.appendChild(childNode);
			}
			FileUtil.createFile(dir,npcFileName,xml.toXMLString());
		}
			
		/** 将 npc数据变成xml文件便于策划可调
		 */
		public static  function handleNpcToCSV(dict:Dictionary,dir:File,npcFileName:String):void
		{  /////   id    x  y     
			npcFileName=npcFileName+"_npc.csv";
			
			var br:String="\r\n";
			var csvStr:String="id,x,y"+br;
			var childNode:XML;
			var parentNode:XML;
			var data:Object;
			var movie:FlexMovieClip;
			var line:String; 
			for  (var nameId:String in dict)
			{
				movie=dict[nameId];
				line=nameId+","+movie.x+","+movie.y+br;
				csvStr +=line;
			}
			FileUtil.createFile(dir,npcFileName,csvStr);
		}
		
		
		/** 创建文件     roadArr是路点信息数组   
		 */
		private function createMapXX(mapType:int,mapDes:String,storeDir:File,mapIdName:String,roadArr:Vector.<MarkObject>,buildDict:Dictionary,npcDict:Dictionary,transferPtLayer:FlexUI,monsterZoneDict:Dictionary):void
		{
				var obj:Object={}; 
				obj.mapDes=mapDes;
				obj.type=mapType;
				handleFloor(obj,roadArr);	
				handleBuilding(obj,buildDict);
				handleNpc(obj,npcDict);
				handleTransferPtForClient(obj,transferPtLayer);    ///处理传送点数据
				handleMonsterZone(obj,monsterZoneDict);
				
				//在同目录下生成  .xx文件 
				var byteArr:ByteArray=new ByteArray();
				byteArr.endian=Endian.LITTLE_ENDIAN;
//				byteArr.writeObject(obj);
				var objStr:String=JSON.stringify(obj);
				byteArr.writeUTF(objStr);
				byteArr.compress();
				FileUtil.createFileByByteArray(storeDir,mapIdName+TypeFile.XXExtention,byteArr);
				
		//		var str:String=JSON.stringify(obj);
				//生成json 给 js用
				FileUtil.createFile(storeDir,mapIdName+TypeFile.JSMapExtention,objStr);
		}
		
//		/**创建 id__mapScene.csv文件
//		 */		
//		public static function createMapSceneCSV(dir:File,width:int,height:int,mapId:String,transferLayer:FlexUI):void
//		{
//			var arr:Array=handleTransferPtForService(transferLayer);
//			var arrStr:String=JSON.stringify(arr);
//			/// mapId   width  height  resId    策划去配置skipArr信息
//			var str:String="mapId,width,height,resId,skipArr"+"\r\n";
//			str +=mapId+","+width+","+height+","+mapId+',"'+arrStr+'"';//"";
//			var name:String=mapId+"_mapScene.csv"
//			FileUtil.createFile(dir,name,str);
//		}
		
		
		/**创建 id__mapScene.csv文件
		 */		
		public static function createMapSceneCSV(mapType:int,dir:File,width:int,height:int,mapId:String,mapDes:String,transferLayer:FlexUI):void
		{
		//	var arr:Array=handleTransferPtForService(transferLayer);
		//	var arrStr:String=JSON.stringify(arr);
			/// mapId   width  height  resId    策划去配置skipArr信息
			var str:String="mapId,mapDes,type,width,height,resId\r\n";
			str +=mapId+","+mapDes+","+mapType+","+width+","+height+","+mapId+'\r\n';//"";
			var name:String=mapId+"_mapScene.csv"
			FileUtil.createFile(dir,name,str);
			
			handleTransferPtForService(transferLayer,dir,mapId);
		}
		
		
		
		/** 处理  传送点
		 * 生成配置文件给服务端
		 */		
		private static function handleTransferPtForService(transferLayer:FlexUI,dir:File,mapIdName:String):void
		{
			var len:int=transferLayer.numElements;
			var element:FlexMovieClip;
			
//			var arr:Array=[];
//			var cellArr:Array;
			var mapX:int;
			var mapY:int;
			var mapId:int;
			var data:Object;  /// {mapId:mapIdTxt.text,x:mapPosX.text,y:mapPosY};
			
			///跳转点 left,top,right,bottom,otherMapId,mapX,mapY
			var skipPointStr:String="mapId,left,top,right,bottom,otherMapId,mapX,mapY\r\n";
			for (var i:int=0;i!=len;++i)
			{
				element=transferLayer.getElementAt(i) as FlexMovieClip;    ////传送点信息      left,top,right,bottom,otherMapId,mapX,mapY
				data=element.myData;
				mapId=int(data.mapId);  
				
				skipPointStr +=mapIdName+",0,0,0,0,"+mapId+","+data.x+","+data.y+"\r\n";
			}
			var name:String=mapIdName+"_skipPoint.csv";
			FileUtil.createFile(dir,name,skipPointStr);
		}

		
		
		
		
//		/** 处理  传送点
//		 * 生成配置文件给服务端
//		 */		
//		private static function handleTransferPtForService(transferLayer:FlexUI):Array
//		{
//			var len:int=transferLayer.numElements;
//			var element:FlexMovieClip;
//			
//			var arr:Array=[];
//			var cellArr:Array;
//			var mapX:int;
//			var mapY:int;
//			var mapId:int;
//			var data:Object;  /// {mapId:mapIdTxt.text,x:mapPosX.text,y:mapPosY};
//			for (var i:int=0;i!=len;++i)
//			{
//				element=transferLayer.getElementAt(i) as FlexMovieClip;    ////传送点信息   [[0,0],[0,0],mapId,[x3,y3]]
//				data=element.data;
//				
//				mapId=int(data.mapId);  
//				cellArr=[[0,0],[0,0]];
//				cellArr.push(mapId);
//				cellArr.push([data.x,data.y]);
//				arr.push(cellArr);
//			}
//			return arr;
//		}
		
		
		
		
		/**客户端使用 	var skipArr:Array=xxObj.skip; //[{selfX,selfY,x,y,mapId,mapName}]  //selfX selfY 是传送点自己的坐标  x y mapId 是另一个地图的信息 mapName另一个地图的名称

		 * @param obj
		 */		
		private static function handleTransferPtForClient(obj:Object,transferLayer:FlexUI):void
		{
			var len:int=transferLayer.numElements;
			var element:FlexMovieClip;

			var arr:Array=[];
			var data:Object;  /// {mapId:mapIdTxt.text,x:mapPosX.text,y:mapPosY,mapName};
			for (var i:int=0;i!=len;++i)
			{
				element=transferLayer.getElementAt(i) as FlexMovieClip;    ////传送点信息   {selfX,selfY,x,y,mapId,,mapName}  //selfX selfY 是传送点自己的坐标  x y mapId ,mapName是另一个地图的信息
				data=element.myData;
				//判断名字;
				data.mapName=StringUtil.trim(element.text);
				data.selfX=element.x;
				data.selfY=element.y;
				data.type=data.type; /// 传送点类型   1  表示普通  2 表示 特殊
				arr.push(data);
			}
			obj.skip=arr;
		}

		
		
		
		/**创建  .floor文件   只包含 障碍点信息文件
		 */
		private function createFloor(storeDir:File,name:String,roadArr:Vector.<MarkObject>):void
		{
			var obj:Object={}; 

			handleFloor(obj,roadArr);	
			
			//在同目录下生成  .floor文件 

			var str:String=JSON.stringify(obj);
			FileUtil.createFile(storeDir,name+TypeFile.FloorExtention,str);
//			var byteArr:ByteArray=new ByteArray();
//			byteArr.writeObject(obj);
//			byteArr.compress();
//			FileUtil.createFileByByteArray(storeDir,name+TypeFile.FloorExtention,byteArr);

		}
		
		
		/**
		 * 创建 怪物点文件s   只包含 怪物信息     用于服务端
		 */
		public function createMonster(storeDir:File,name:String,monsterDict:Dictionary):void
		{
			var obj:Object={};
			var monsterData:Object;
			var len:int;
			var csvStr:String="onlyId,id,x,y"+"\n";
			var onlyId:int=0;
			for(var id:String in monsterDict )
			{
				obj[int(id)]=[];
				len=0;
				for each (var monsterMark:MarkMonster in monsterDict[int(id)])
				{
					++len;
					++onlyId;
					
					monsterData={};
					monsterData.x=monsterMark.x;
					monsterData.y=monsterMark.y;
					obj[int(id)].push(monsterData);
					
					csvStr +=onlyId+","+id+","+monsterData.x+","+monsterData.y+"\n";
				}
				if(len==0) delete obj[int(id)];
			}
			
			///生成配置文件给服务端
			var str:String=JSON.stringify(obj);
			FileUtil.createFile(storeDir,name+TypeFile.MonsterExtention,str);
			
			///生成怪物.csv文件
			FileUtil.createFile(storeDir,name+"_monster.csv",csvStr);
		}
		/**处理怪区域配置      var monsterZoneArr:Array=xxObj.monsterZone;//[{name,x,y},{...},{...}]
		 */		
		private function handleMonsterZone(obj:Object,monsterZoneDict:Dictionary):void
		{
			var arr:Array=[];
			for each(var monsterZoneClip:MonsterZoneClip in monsterZoneDict)  /// {name,x,y}   [{name,x,y},{...},{...}]
			{
				arr.push(monsterZoneClip.myData);
			}
			obj.monsterZone=arr;
		}
		
		
		
		

		/**  创建怪物点的Bson 文件 给mongoDB使用
		 * 创建 怪物点文件s   只包含 怪物信息     用于服务端
		 */
		private function createMonsterToBson(storeDir:File,name:String,monsterDict:Dictionary):void
		{
			var obj:Object;
			var monsterData:Object;
			
			var jsonStr:String="";
			
			var singleStr:String;
			for(var id:String in monsterDict )
			{
				obj={};
				obj.id=id;
				obj.pointArr=[];
				for each (var monsterMark:MarkMonster in monsterDict[int(id)])
				{
					monsterData={};
					monsterData.x=monsterMark.x;
					monsterData.y=monsterMark.y;
					obj.pointArr.push(monsterData);
				}
				
				singleStr=JSON.stringify(obj);
				jsonStr +=singleStr+"\n";
			}
			
			///生成配置文件给服务端
			FileUtil.createFile(storeDir,name+TypeFile.BSonExtention,jsonStr);
			
		}

		
		
		
		
		
		
		/**创建地图信息  包含  地表信息   建筑 npc
		 */		
		public function createMapFile(mapType:int,mapDes:String,storeDir:File,name:String,roadArr:Vector.<MarkObject>,buildDict:Dictionary,npcDict:Dictionary,transferPtLayer:FlexUI,monsterZoneDict:Dictionary):void
		{
			createMapXX(mapType,mapDes,storeDir,name,roadArr,buildDict,npcDict,transferPtLayer,monsterZoneDict);
			createFloor(storeDir,name,roadArr);
			Alert.show("地图基本信息生成完成");
		}
		
		
		
		private function getObjectLen(obj:Object):int
		{
			var len:int=0;
			for each (var item:Object in obj)
			{
				++len;
			}
			return len;
		}
		
		
	}
}