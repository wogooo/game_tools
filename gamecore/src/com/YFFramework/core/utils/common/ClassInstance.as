package com.YFFramework.core.utils.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	/**  获取外部加载的链接类的实例    
	 *   2012-6-20
	 *	@author yefeng
	 */
	public class ClassInstance
	{
		public function ClassInstance()
		{
		}
		
		/**  根据 类名  得到该类名对应的一个实例
		 */
		public static function getInstance(uiclassName:String):Object
		{
			var UI:Class=ApplicationDomain.currentDomain.getDefinition(uiclassName) as Class;
			var ui:Object=new UI();
			return ui;
		}
		
	}
}