package manager
{
	import com.as3xls.xls.Cell;
	import com.as3xls.xls.Sheet;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.SRVRecord;
	
	import mx.controls.Alert;

	public class FileManager
	{
		public function FileManager()
		{
		}
		
		
		
		//将 sheet转化为 json或者lua 文件
		public static function parseSheet(sheet:Sheet,dir:File,fileName:String,alert:Boolean,checkObj:Object=null,createjava:Boolean=false):String
		{
			
			var checkStr:String ="";
			
			var rows:int =sheet.rows;
			var columns:int =sheet.cols;
			
			var desCell:Cell; //描述cell
			var createCell:Cell; //生成在哪一端的cell
			var propCell:Cell; //属性值cell
			var dataCell:Cell   ;//实际的数据
			var clientArr:Array = []; //客户端数据
			var serverArr:Array = []; //服务端数据
			var serverHasValue:Boolean;
			var clientHasValue:Boolean;
			for(var i:int = 3;i<rows;++i)
			{
				var clientOBj:Object ={}
				clientOBj.values={}
				clientOBj.des ={}

				var serverObj:Object ={}
				serverObj.values={}
				serverObj.des ={}
				serverHasValue= false;
				clientHasValue = false;
				for(var j:int =0 ;j<columns;++j)
				{
					desCell = sheet.getCell(0,j)
						
					createCell = sheet.getCell(1,j)
						
					propCell = sheet.getCell(2,j)
						
					dataCell = sheet.getCell(i,j)
					if (createCell.value=="Both" || createCell.value =="Client")
					{
						clientOBj.values[propCell.value] = dataCell.value ; //值
						clientOBj.des[propCell.value] = desCell.value;	//描述
						clientHasValue = true;
					}
					

					if (createCell.value=="Both" || createCell.value =="Server")
					{
						serverObj.values[propCell.value] = dataCell.value;
						serverObj.des[propCell.value] = desCell.value;	//描述

						serverHasValue = true;
					}
					
					/// check  value 
					if(checkObj)
					{
						var myCheckObj:Object =checkObj[propCell.value]
						if (myCheckObj)
						{
							var hasIt:Boolean = CheckManager.checkValue(myCheckObj.table,myCheckObj.prop,dataCell.value);
							if (!hasIt)
							{
								var str:String ="填表错误:表=="+fileName+"属性=="+propCell.value+",值=="+dataCell.value;
								checkStr +=str+"\n"
								trace(str)
							}
						}
					}
				}
				if (clientHasValue)	clientArr.push(clientOBj);
				if (serverHasValue) serverArr.push(serverObj);
			}
			
			/// clientArr  serverArr  存储了我们需要生成的数据
			
			//生成客户端lua数据
			var clientStr:String = createLua(clientArr,fileName);
			//生成服务端json数据
			var serverStr:String = createJson(serverArr);
//			trace(clientStr);
			
			saveFile(clientStr,dir,fileName+".lua");
			
			//json生成 替换内部的数组 "[]"为 []
			
			var  reg1:RegExp = new RegExp('"\[',"g");  ///"[/g; //
			serverStr=serverStr.replace(reg1,"\[");
			var  reg2:RegExp = /]"/g;//new RegExp(']"',"g");
			serverStr=serverStr.replace(reg2,"]");
			
			saveFile(serverStr,dir,fileName+".json");
			
			LuaManagerCreate.createLuaManager(fileName,clientArr[0].des,clientArr[0].values,dir);
			if (serverArr.length >0&&createjava)
			{
				JavaFileCreate.createJavaVoFile(fileName,serverArr[0].des,serverArr[0].values,dir);
				JavaFileCreate.createJavaManagerFile(fileName,serverArr[0].des,serverArr[0].values,dir);
			}
			if (alert)
			{
				Alert.show("生成完成");
			}
			
			return checkStr;
		}
		
		
		//创建lua文件
		private static  function createLua(arr:Array,fileName:String):String
		{
			var nextEnter:String ="\r"; //换行
			var table:String = "local " + fileName +" = {" + nextEnter ;//"{"+nextEnter;
			var index:int = 1;
			var len:int =arr.length;
			for(var i:int=0;i!=len;++i)
			{
				var obj:Object=arr[i];
				var str:String ;
				if (i!=len-1)
				{
					str = '['+index+'] = '+ objToLuaTable(obj.values) + "," +nextEnter;
				}
				else 
				{
					str = '['+index+'] = '+ objToLuaTable(obj.values) ;
				}
				
				table += str;
				++index;
			}
			
			table +=nextEnter +"}";
			
			table +=nextEnter
			table +="return " + fileName;
			return table;
		}
		
		//单一table转化为 lua Obj
		private static function objToLuaTable(obj:Object):String
		{
			var table:String ="{"
			for (var key:String in obj)
			{
				var value:String = obj[key];
				var index:int =value.indexOf("[");
				var str:String ;

				if (index==-1)  //不是数组
				{
					str='["'+key+'"] = "'+ value + '" , '
				}
				else //是数组
				{
					value = arrayToLuaArray(value);
					str='["'+key+'"] = '+ value + ' , '
				}
				table +=str;
			}
			table =table.substr(0,table.length-2);
			table +="}"
			return table;
		}
		
		//如果有数组，将数组转化为lua形式
		private static function arrayToLuaArray(arrStr:String):String
		{
			var str:String = arrStr.replace("[","{");
			str= str.replace("]","}");
			return str;
		}
		
		// 创建json文件 
		private static function createJson(arr:Array):String
		{
			var len:int =arr.length;
			var myJsonObj:Object ={};
			
			for(var i:int=0;i!=len;++i)
			{
				var obj:Object=arr[i];
				myJsonObj[i] =obj.values
			}
			
			var str:String =JSON.stringify(myJsonObj);
			return str;
			
		}
		
		private static function saveFile(str:String,dir:File,fileName:String):void
		{
			var file:File=File.desktopDirectory;
			file.url =dir.url+"/" +fileName;
			if(!file.exists)
			{
				file = dir.resolvePath(fileName);
			}
			var fileStream:FileStream= new FileStream();
			fileStream.open(file,FileMode.WRITE);
			fileStream.position=0;

//			fileStream.writeUTF(str);
//			fileStream.writeMultiByte(str,"gb2312");
			fileStream.writeMultiByte(str,"UTF-8");

			fileStream.close();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}