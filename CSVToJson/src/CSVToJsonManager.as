package
{
	import com.YFFramework.core.net.parse.CSVParse;
	import com.YFFramework.core.utils.StringUtil;

	/**2012-8-27 下午4:37:34
	 *@author yefeng
	 */
	public class CSVToJsonManager
	{
		public function CSVToJsonManager()
		{
		}
		
		/**csvData字符串数据
		 */ 
		public static  function convert(csvData:String):Object
		{
			var arr:Array=CSVParse.Parse(csvData);
			///以第一行作为键值
			var len:int=arr.length;
			
			var cellArr:Array=CSVParse.GetCellArr(arr[0]);
			var propertylen:int=cellArr.length;
			
			var obj:Object={};
			var cellObj:Object;
			
			var valueArr:Array;
			
			var line:String;
			for (var i:int=1;i!=len;++i)
			{
				line=arr[i];
				if(StringUtil.trim(line)!="")
				{
					cellObj=new Object();
					valueArr=CSVParse.GetCellArr(line);
					for(var j:int=0;j!=propertylen;++j)
					{
						if(valueArr[j].indexOf("[")!=-1)
						{
							var arrObj:Object=JSON.parse(valueArr[j]);
							cellObj[cellArr[j]]=arrObj;
						}
						else cellObj[cellArr[j]]=valueArr[j];
					}
					///以第一个键值作为id头
					obj[valueArr[0]]=cellObj;

				}
			}
			return obj;
		}
		
		/**转化为bson对象
		 * csvData字符串数据
		 */ 
		public static  function convertToBson(csvData:String):String
		{
			
			var arr:Array=CSVParse.Parse(csvData);
			///以第一行作为键值
			var len:int=arr.length;
			
			var cellArr:Array=CSVParse.GetCellArr(arr[0]);  ////  tittle 字符串   
			var propertylen:int=cellArr.length;
			
			var cellObj:Object;
			
			var obj:Object={};

			var valueArr:Array;
			//Bson字符串
			var bsonStr:String="";
			var lineObjectStr:String;///每一行的 对象的字符串
			var line:String;
			for (var i:int=1;i!=len;++i)
			{
				line=arr[i];
				if(StringUtil.trim(line)!="")
				{
					cellObj=new Object();
					valueArr=CSVParse.GetCellArr(line);
					for(var j:int=0;j!=propertylen;++j)
					{
						//	cellObj[cellArr[j]]=valueArr[j]
						
						if(valueArr[j].indexOf("[")!=-1)
						{
							var arrObj:Object=JSON.parse(valueArr[j]);
							cellObj[cellArr[j]]=arrObj;
						}
						else cellObj[cellArr[j]]=valueArr[j];
						
					}
					///以第一个键值作为id头
					lineObjectStr=JSON.stringify(cellObj);
					bsonStr +=lineObjectStr+"\n";

				}
			}
			return bsonStr;
		}
	
		/**
		 * @param arr 保存是数据 obj  ={id,data:}  , index是主键id    data是具体的obj
		 */		
		public static function conbineData(arr:Array):String
		{
			var totalObj:Object={};
			var id:int;
			var data:Object;
			for each (var obj:Object in arr)
			{
				id=obj.id;
				data=obj.data;
				totalObj[id]=data;
			}
			return JSON.stringify(totalObj);
		}
		
		
		
		
		
	}
}