package
{
	import mx.skins.halo.TabSkin;

	public class ASCreator
	{
		/**换行
		 */		
		private static const Br:String="\n";
		/** tab键
		 */		
		private static const Tab:String="\t";
		
		
		public function ASCreator()
		{
		}
		private static function getProp(prop:String):String
		{
			return Tab+Tab+"public var "+ prop+":int;" ;
		}
		/** 创建数据vo 文件   只支持一维转化
		 * jsonObj  json 文件
		 * 表里面的唯一 id
		 */		
		public static function CreateAsFileVo(jsonObj:Object,className:String):String
		{
			
			var content:String="";
			for(var prop:String in jsonObj)
			{
				content +=getProp(prop)+Br;
			}
			
			return createFileHead(className)+Br+content+Br+createMyFunc(className)+Br+createFileLast();
		}
		/**创建数据manager
		 * @param jsonObj
		 * @param id
		 * @param className
		 * @param voClassName
		 * @return 
		 * 
		 */		
		public static function CreateAsFileManager(jsonObj:Object,id:String,className:String,voClassName:String):String
		{
			var content:String="";
			content=createFileHead(className)+createAsFileManagerContent(jsonObj,id,className,voClassName)+createFileLast();
			return content;

		}
		/**创建数据管理表manager文件
		 * jsonObj    是一个 数据 模型Vo 的 Object
		 */		
		private static function createAsFileManagerContent(jsonObj:Object,id:String,className:String,voClassName:String):String
		{
			
			var staticProp:String=Tab+Tab+"private static var _instance:"+className+";"+Br+
									Tab+Tab+"private var _dict:Dictionary;"+Br+
									Tab+Tab+"public function "+className+"()"+Br+
									Tab+Tab+"{"+Br+
									Tab+Tab+Tab+"_dict=new Dictionary();"+Br+
									Tab+Tab+"}"+Br+
									Tab+Tab+"public static function get Instance():" +className+Br+
										Tab+Tab+"{"+Br+
										Tab+Tab+Tab+"if(_instance==null)_instance=new "+className+"();"+Br+
										Tab+Tab+Tab+"return _instance;"+Br+
										Tab+Tab+"}"+Br;
			
			var content:String=""; 
			var voInstance:String=voClassName;
			var pre:String=voInstance.charAt(0);
			pre=pre.toLocaleLowerCase();
			voInstance= pre+voInstance.substr(1);
			content=Tab+Tab+"public  function cacheData(jsonData:Object):void"+Br+
					Tab+Tab+"{"+Br+
					Tab+Tab+Tab+"var "+voInstance+":"+voClassName+";"+Br+
					Tab+Tab+Tab+"for (var id:String in jsonData)"+Br+
					Tab+Tab+Tab+"{"+Br+
					Tab+Tab+Tab+Tab+voInstance+"=new "+voClassName+"();"+Br;
			for(var prop:String in jsonObj)
			{
				content +=Tab+Tab+Tab+Tab+voInstance+"."+prop+"=jsonData[id]."+prop+";"+Br;
			}
			content +=Tab+Tab+Tab+Tab+"_dict["+voInstance+"."+id+"]="+voInstance+";"+Br+
						Tab+Tab+Tab+"}"+Br+
						Tab+Tab+"}"+Br;
			
			content +=Tab+Tab+"public function get"+voClassName+"("+id+":int)"+":"+voClassName+Br+
				Tab+Tab+"{"+Br+
				Tab+Tab+Tab+"return _dict["+id+"];"+Br+
				Tab+Tab+"}"+Br;
			return staticProp+content;

		}
		/**类文件开头
		 * @param className
		 */		
		private static function createFileHead(className:String):String
		{
			var str:String="package"+Br+"{"+Br+Tab+"public class "+className+Br+Tab+"{"+Br;
			return str;
		}
		/**类文件结束
		 * @param className
		 * @return 
		 * 
		 */		
		private static function createFileLast():String
		{
			var str:String=Tab+"}"+Br+"}";
			return str;
		}
		
		/**构造函数字符串
		 */ 
		private static function createMyFunc(className:String):String
		{
			var str:String=Tab+Tab+"public function "+className+"()"+Br+Tab+Tab+"{"+Br+Tab+Tab+"}";
			return str;
		}
		
	}
}