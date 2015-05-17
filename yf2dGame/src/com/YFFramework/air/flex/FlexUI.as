package com.YFFramework.air.flex
{
	import mx.events.FlexEvent;
	
	import spark.components.Group;

	/** flex 容器的基类
	 */	
	public class FlexUI extends Group //FlexTransformManager
	{
		protected var _autoRemove:Boolean;
		public function FlexUI(autoRemove:Boolean=false)
		{
			_autoRemove=autoRemove;
			super();
			initUI();
			addEvent();
		}
		
		protected function addEvent():void
		{
			if(_autoRemove) addEventListener(FlexEvent.REMOVE,dispose);
		}
		
		protected function initUI():void
		{
			
		}
		
		protected function  removeEvent():void
		{
			if(_autoRemove)removeEventListener(FlexEvent.REMOVE,dispose);
		}
		
		public function dispose(e:FlexEvent=null):void
		{
			removeEvent();
			removeAllElements();
		}
	}
}