package manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	//创建java文件
	public class JavaFileCreate
	{
		private static const NextLine :String= "\r";
		
		private static const Tab:String ="	";
		private static const Space:String = " "
		
		
		
		public function JavaFileCreate()
		{
		}
		
		public static function createJavaVoFile(classname:String,desProp:Object,valueProp:Object,dir:File):void
		{
			//将文件名称转化为大写
			var firstStr:String = classname.charAt(0);
			firstStr= firstStr.toLocaleUpperCase();
			classname = classname.substr(1);
			classname = firstStr+classname
			///加上Basicvo 
			classname = classname+"BasicVo"	
				
			var fileName:String = classname+".java"
			var str:String = getJavaVoClassStr(classname,desProp,valueProp)
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
		
		//获取java vo类
		private static function getJavaVoClassStr(className:String,desProp:Object,valueProp:Object):String
		{
			
			var str:String ="// created By yefeng Tool  "+NextLine+NextLine;

			str +="package com.game.reader.model;" +NextLine+NextLine
				
			// do import  ///
				
			str +="public class " + className + NextLine
				+"{" + NextLine ;
				
			
			for(var prop:String in desProp)
			{
				var descript:String = desProp[prop]
				var valuePropValue:String = valueProp[prop]
				var type:String ="String "
				if(valuePropValue.charCodeAt(0)>=48 && valuePropValue.charCodeAt(0)<=57)
				{
					type = "int "
				}
				str +=Tab +"//"+descript +NextLine
				str += Tab +"public " +type+prop +" ;"+NextLine
			}
			str += "}"
			return str;
		}
		
		
		
		public static function createJavaManagerFile(className:String,desProp:Object,valueProp:Object,dir:File):void
		{
			
			//将文件名称转化为大写
			var firstStr:String = className.charAt(0);
			firstStr= firstStr.toLocaleUpperCase();
			className = className.substr(1);
			className = firstStr+className;
			
			var voName:String = className+"BasicVo"
			///加上Basicvo 
			className = className+"BasicManager"	
			
			var fileName:String = className+".java"
			var str:String = getJavaManagerClassStr(className,voName,desProp,valueProp);
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

		
		
		private static function getLowName(className:String):String
		{
			var firstStr:String = className.charAt(0);
			var lowClassNameFirst:String= firstStr.toLocaleLowerCase();
			var lowClassName:String = className.substr(1);
			lowClassName = lowClassNameFirst+lowClassName
			return lowClassName
		}
		//获取java manager类
		private static function getJavaManagerClassStr(className:String,voName:String,desProp:Object,valueProp:Object):String
		{
			// 首字母小写的 类名
//			var firstStr:String = className.charAt(0);
//			var lowClassNameFirst:String= firstStr.toLocaleLowerCase();
//			var lowClassName:String = className.substr(1);
//			lowClassName = lowClassNameFirst+lowClassName
			var lowClassName:String = getLowName(className);
			var voLowName:String = getLowName(voName);
				
				
				
				
			var str:String ="// created By yefeng Tool  "+NextLine+NextLine;
			str +="package com.game.reader.manager;" +NextLine+NextLine
			
			// do import  ///
				
			str +="import java.util.HashMap;"+NextLine
			str +="import java.util.Iterator;"+NextLine
			str +="import org.json.JSONException;"+NextLine
			str +="import org.json.JSONObject;"+NextLine
			str +="import com.game.reader.model."+voName+";"+NextLine+NextLine
				
				//构造函数
			str +="public class " + className + NextLine
			str +="{" + NextLine+ NextLine;
			str += Tab + "private HashMap<Integer, "+voName+"> _dict;"+NextLine;
			str += Tab +"private static "+className+" _instance;" +NextLine;
			
			str +=Tab +"public "+className+"()"+NextLine;
			str +=Tab+"{"+NextLine;
			str +=Tab+Tab+"_dict=new HashMap<Integer, "+voName+">();" +NextLine ;
			str +=Tab+"}"+NextLine+NextLine;
			
			//单利
			str +=Tab +"static public "+className+" getInstance()"+NextLine;
			str +=Tab +"{"+NextLine
			str +=Tab +Tab+"if(_instance==null) _instance=new "+className+"();"+NextLine
			str +=Tab +Tab+"return _instance;"+NextLine+NextLine;
			str +=Tab +"}"+NextLine+NextLine;
				
			//cache对象
			
			str +=Tab +"public void cacheData(JSONObject obj)"+NextLine;
			str +=Tab +"{"+NextLine;
			str +=Tab+Tab +"Iterator iterator=obj.keys();"+NextLine
			str +=Tab+Tab +"String key;"+NextLine;
			str +=Tab+Tab +voName+" "+voLowName+";"+NextLine;
			str +=Tab+Tab +"JSONObject itemObj;"+NextLine;
			str +=Tab+Tab +"while(iterator.hasNext())"+NextLine;
			str +=Tab+Tab +"{"+NextLine
			str +=Tab+Tab +Tab + "key=iterator.next().toString();"+NextLine
				
			str +=Tab+Tab +Tab +"try"+NextLine
			str +=Tab+Tab +Tab +"{"+NextLine
			str +=Tab+Tab +Tab +Tab+"itemObj=obj.getJSONObject(key);"+NextLine;
			str +=Tab+Tab +Tab +Tab+voLowName+" = " +"new "+voName+"();"+NextLine;
			
			//便利属性 
			var firstProp :String=null;
			for(var prop:String in desProp)
			{
				if (!firstProp)firstProp = prop;
				var descript:String = desProp[prop]
				var valuePropValue:String = valueProp[prop]

				var type:String ="getString "
				if(valuePropValue.charCodeAt(0)>=48 && valuePropValue.charCodeAt(0)<=57)
				{
					type = "getInt "
				}

				str +=Tab+Tab +Tab +Tab+ voLowName +"."+prop+" = "+"itemObj."+type+'("'+prop+'");'+NextLine;
			}
				
			str +=Tab+Tab +Tab +Tab+ "_dict.put("+voLowName+"."+firstProp+","+voLowName+");"+NextLine;
			
			str +=Tab+Tab +Tab +"}"+NextLine
			str +=Tab+Tab +Tab +"catch(JSONException e)"+NextLine
			str +=Tab+Tab +Tab +"{"+NextLine
			str +=Tab+Tab +Tab +Tab+"e.getStackTrace();"+NextLine
			str +=Tab+Tab +Tab +"}"+NextLine
			str +=Tab+Tab +"}" +NextLine
			str +=Tab+"}" +NextLine
				
				
		//获取数据vo 
			str +=Tab+"public "+voName+" get"+voName+"(int "+prop+")"+NextLine
			str +=Tab+"{"+NextLine
			str +=Tab+Tab+"return _dict.get("+prop+");"+NextLine;
			str +=Tab+"}"+NextLine+NextLine
			str +="}"
			return str;
		}
	}
}