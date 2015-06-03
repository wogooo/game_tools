package com.dolo.ui.controls
{
	import flash.display.Sprite;

	/**
	 * 表格 ，表格用法暂时参照自定义渲染器的List用法，sortItemsOn(fieldName:Object, options:Object = null)函数提供了表格的排序方法。
	 * 具体参见List组件
	 * @author flashk
	 * 
	 */
	public class DataGrid extends List
	{
		protected var _title:Sprite;
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		public function DataGrid()
		{
			
		}
		
		/**
		 * 设置表格标题 
		 * @param sp
		 * 
		 */
		public function setTitle(sp:Sprite):void
		{
			_title = sp;
		}
		
	}
}