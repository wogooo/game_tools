package com.YFFramework.core.utils.common
{
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**  获取外部加载的链接类的实例    
	 *   2012-6-20
	 *	@author yefeng
	 */
	public class ClassInstance
	{
		private static var _cacheDict:Dictionary=new Dictionary();
		public function ClassInstance()
		{
		}
		
		/**  根据 类名  得到该类名对应的一个实例
		 *   和bitmapDat有关的只有 一个  
		 */
		public static function getInstance(uiclassName:String):*
		{
//			if(_cacheDict[uiclassName])
//			{
//				return _cacheDict[uiclassName];
//			}
//			var UI:Class=ApplicationDomain.currentDomain.getDefinition(uiclassName) as Class;
//			var ui:Object=new UI();
//			if(ui is BitmapData)_cacheDict[uiclassName]=ui;  /////缓存 bitmapData
//			return ui;	
			return getInstance2(uiclassName,ApplicationDomain.currentDomain);
		}
		
		public static function getInstance2(uiclassName:String,appDomain:ApplicationDomain):*
		{
			if(_cacheDict[uiclassName])
			{
				return _cacheDict[uiclassName];
			}
			var UI:Class=appDomain.getDefinition(uiclassName) as Class;
			var ui:Object=new UI();
			if(ui is BitmapData)_cacheDict[uiclassName]=ui;  /////缓存 bitmapData
			return ui;	
		}
		
		
	}
}