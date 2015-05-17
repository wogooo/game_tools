package manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	// lua  管理器   manage
	public class LuaManagerCreate
	{
		private static const NextLine :String= "\r";
		
		private static const Tab:String ="	";

		public function LuaManagerCreate()
		{
		}
		
		public static function createLuaManager(classname:String,desProp:Object,valueProp:Object,dir:File):void
		{
			
			var realName :String = classname;
			//将文件名称转化为大写
			var firstStr:String = classname.charAt(0);
			firstStr= firstStr.toLocaleUpperCase();
			classname = classname.substr(1);
			classname = firstStr+classname
			
			var upperClassname:String = classname
			///加上BasicManager
			classname = classname+"BasicManager"	
			
				
			 
				
				
			var fileName:String = classname+".lua"
				
				
			var str:String = getLuaStr(realName,upperClassname)
			var file:File=File.desktopDirectory;
			
			file.url =dir.url+"/" +fileName;
			if(!file.exists)
			{
				file = dir.resolvePath(fileName);
			}
			var fileStream:FileStream= new FileStream();
			fileStream.open(file,FileMode.WRITE);
			fileStream.position=0;
			
			fileStream.writeMultiByte(str,"UTF-8");
			fileStream.close();
			
				
		}
		
		
		private static function getLuaStr(className:String,upperClassname:String):String
		{
			var str:String ="-- created By yefeng Tool  "+NextLine+NextLine;
			
			str +="local "+className + ' = require "game/config/model/'+className+'"' +NextLine+NextLine;
			
			str += upperClassname+"Class = class()"+NextLine+NextLine;
			
			str += "function "+upperClassname+"Class:ctor()"+NextLine;
			str += Tab+"self._dict = {}"+NextLine;
			str += Tab+ "self:cacheData()"+NextLine;
			str += "end"+NextLine+NextLine;
			str += "function "+upperClassname+"Class:cacheData()"+NextLine;
			str += Tab+"for key, value in pairs("+className+") do"+NextLine;
			str += Tab+Tab+"self._dict[value.id] = value   -- key  value 重新存储，此处需要手动修改唯一key"+NextLine
			str += Tab+"end"+NextLine
			str += "end"+NextLine+NextLine;
			
			str += "function "+upperClassname+"Class:get"+upperClassname+"BasicVo(id)"+NextLine
			str += Tab+ "return self._dict[value.id]"+NextLine;
			str += "end"+NextLine+NextLine;
			
			str += upperClassname+"BasicManager = "+upperClassname+"Class.new()"
			return str
		}

	}
}