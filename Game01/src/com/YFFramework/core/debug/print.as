package com.YFFramework.core.debug
{
	import flash.utils.getQualifiedClassName;

	/**打印函数
	 * author :夜枫
	 */
		public function print(obj:Object,...arguments):void
		{
			var className:String;
			if(obj is String)className=String(obj);
			else className=getQualifiedClassName(obj);
			trace(className+"===",arguments);
		}
}