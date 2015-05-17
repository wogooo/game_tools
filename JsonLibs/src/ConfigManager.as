package 
{
	import com.YFFramework.core.debug.print;
	
	import flash.external.ExternalInterface;

	/**配置文件 的信息
	 * @author yefeng
	 *2012-4-21下午8:21:28
	 */
	public class ConfigManager
	{
		
		private var _xml:XML;
		private var _root:String;
		
		private static var _instance:ConfigManager;
		public function ConfigManager()
		{
		}
		public static function get Instance():ConfigManager
		{
			if(!_instance)_instance=new ConfigManager();
			return _instance;
		}
		
		public function  setRoot(url:String):void
		{
			_root=url;
		}
		public function parseData(data:XML):void
		{
			_xml=data;

		}
		
		public function getRoot():String
		{
			return _root;
		}
		

		/** 获得各个数值表 的具体信息
		 *  json表
		 */		
		public function getFileList():Vector.<Object>
		{
			var list:XMLList=_xml.libs.files;
			var len:int=list.item.length();
			var obj:Object;
			var arr:Vector.<Object>=new Vector.<Object>();
			for(var i:int=0;i!=len;++i)
			{
				obj={url:getRoot()+list.item[i],tips:list.item[i].@tittle,id:int(list.item[i].@id)}
				arr.push(obj);
			}
			return arr;

		}
	}
}