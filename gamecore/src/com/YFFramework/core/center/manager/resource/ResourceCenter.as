package com.YFFramework.core.center.manager.resource
{
	import flash.utils.Dictionary;

	/**
	 * author :夜枫 * 时间 ： 12:51:07 PM
	 * 
	 * 资源中心  单例  该类用于 SWF类型的资源 在外部swf资源中进行注册
	 *   一般 用于游戏辅助工具中
	 * 
	 */
	public class ResourceCenter
	{
		private static  var _resourceCenter:ResourceCenter;
		
		private var _resource:Dictionary;
		public function ResourceCenter()
		{
			if(_resourceCenter) throw new Error("请使用Instance属性");
		}
		public static function get Instance():ResourceCenter
		{
			if(!_resourceCenter) 
			{
				_resourceCenter=new ResourceCenter();
				_resourceCenter=new ResourceCenter();
			}
			return _resourceCenter;
		}
		/**注册资源 _source指的是 类的字符串 比如  "flash.display.Sprite",  type 指的是资源类型
		 */		
		public function register(_source:String,_type:ResourceType):void
		{
			var type:String=getOnlyStr(_type);
			if(!_resource[type])_resource[type]=[];
			if(_resource[type].indexOf(_source)==-1)_resource[type].push(_source)
		}
		/** 删除资源
		 */		
		public function unregister(_source:String,_type:ResourceType):void
		{
			var type:String=getOnlyStr(_type);
			if(_resource[type])
			{
				var index:int=_resource[type].indexOf(_source);
				if(index!=-1)
				{
					_resource[type].splice(index,1);
					if(_resource[type].length==0)  delete _resource[type];////假如长度为0  则删除该属性
				}
			}
		}
		/** 得到某一类型的资源数组
		 */		
		public function getResource(_type:ResourceType):Array
		{
			var type:String=getOnlyStr(_type)
			if(_resource[type]) return _resource[type];
			else  return null;
		}
		/**  根据资源类型 得到唯一字符串
		 */		
		private function getOnlyStr(_type:ResourceType):String
		{
			var type:String=_type.mainType+"-"+_type.subType;
			return type;
		}
	}
}