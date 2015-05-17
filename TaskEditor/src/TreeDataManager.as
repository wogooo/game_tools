package
{
	import com.YFFramework.air.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	public class TreeDataManager
	{
		public function TreeDataManager()
		{
		}
		
		
		/** dict创建 xml文件
		 */ 
		public static function createXML(dict:Object):XML
		{
		
			var taskName:String;
			var taskObj:Object;
			var label:String;
			var xml:XML=<root ></root>
			var node:XML;
			for (var taskId:String in dict)
			{
				taskObj=dict[taskId];
				taskName=taskObj.taskName;
				label=taskId+"--"+taskName;
				node=<item label={label} id={int(taskId)} />;
				xml.appendChild(node);
			}
			return xml;
		}
		
		
		
		/**创建 任务文件
		 */		
		public static function createTaskFile(dict:Object,dir:File,name:String):void
		{
			var data:String=JSON.stringify(dict);
			FileUtil.createFile(dir,name,data);
		}
		
		
		
		
	}
}