package manager
{
	import com.as3xls.xls.Cell;
	import com.as3xls.xls.Sheet;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	//检测表
	public class CheckManager
	{
		private static var _dict:Dictionary=new Dictionary() 
		
		private static var _hasLoaded:Boolean = false;
		public function CheckManager()
		{
		}
		public static function setLoaded():void							
		{
			_hasLoaded= true;
		}

		public static function isLoaded():Boolean
		{
			return _hasLoaded;
		}
		public static function parseSheet(sheet:Sheet,fileName:String):void
		{
			var rows:int =sheet.rows;
			var columns:int =sheet.cols;
			
			var desCell:Cell; //描述cell
			var createCell:Cell; //生成在哪一端的cell
			var propCell:Cell; //属性值cell
			var dataCell:Cell   ;//实际的数据
			var clientArr:Array = []; //客户端数据
			for(var i:int = 3;i<rows;++i)
			{
				var clientOBj:Object ={}
				clientOBj={}
				
				for(var j:int =0 ;j<columns;++j)
				{
					desCell = sheet.getCell(0,j)
					
					createCell = sheet.getCell(1,j)
					
					propCell = sheet.getCell(2,j)
					
					dataCell = sheet.getCell(i,j)
					clientOBj[propCell.value] = dataCell.value ; //值
				}
				clientArr.push(clientOBj);
			}
			_dict[fileName] = clientArr
		}
		
		
		//检测 tableName 表里的   是否存在  属性prop的值 为 checkValue
		public static function checkValue(tableName:String,prop:String,checkValue:int):Boolean
		{
			var arr:Array =_dict[tableName]
			for each(var item:Object in arr)
			{
				if (int(item[prop]) ==checkValue)
				{
					return true
				}
			}
			return false
		}
		
		/** parse check sheet 获取每个属性的检测表 和检测字段
		 */				
		public static function parseCheckSheet(sheet:Sheet):Object
		{
			var columns:int =sheet.cols;
			var obj:Object ={}
			for(var j:int =0 ;j<columns;++j)
			{
				var propCell:Cell = sheet.getCell(0,j)
				var dataCell:Cell = sheet.getCell(1,j)
				if (String(propCell.value)!=""&&String(dataCell.value)!="")
				{
					var str:String =String(dataCell.value)  ;//   table/ key 
					var index:int = str.indexOf("/");
					if(index!=-1)
					{
						var table :String = str.substring(0,index);
						var prop:String = str.substring(index+1);
						obj[propCell.value] = {table:table,prop:prop}
					}
				}
			}
			return obj;
		}
				
	}
}