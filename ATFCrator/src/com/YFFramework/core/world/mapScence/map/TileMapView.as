package com.YFFramework.core.world.mapScence.map
{
	/**
	 *  图切片单元
	 *   2012-7-2
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class TileMapView extends Bitmap implements IPool
	{
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;

		private var __id:int;
		public function TileMapView(bitmapData:BitmapData=null)
		{
			__id=IDCreator.getID();
			super(bitmapData,"auto", true);
			regObject();
		}
		
		/** 将图片宽高放大一像素
		 */
		override public function set bitmapData(value:BitmapData):void
		{
			super.bitmapData=value;
			if(bitmapData)
			{
				scaleX=(super.bitmapData.width+1)/super.bitmapData.width;
				scaleY=(super.bitmapData.height+1)/super.bitmapData.height;
			}
		}
		public function dispose():void
		{
			if(bitmapData)	bitmapData.dispose();
			super.bitmapData=null;
		}
		
		/**注册对象池
		 */		
		protected function regObject():void
		{
			regPool(400);
		}
		/**注册对象池
		 */			
		protected function regPool(size:int):void
		{
			var className:String=getQualifiedClassName(this);
			var myClass:Class=getDefinitionByName(className) as Class;
			PoolCenter.Instance.regClass(myClass,size);
		}

		/**子类重写
		 * 重置对象至初始状态
		 */		
		public function reset():void
		{
			bitmapData.dispose();
			super.bitmapData=null;
		}
		/**子类重写  BitmapData
		 * 池对象的 构造函数
		 ** @param obj
		 */		
		public function constructor(obj:Object):IPool
		{
			_isPool=false;
			bitmapData=obj as BitmapData;
			return this;
		}
		
		public function toPool():void
		{
			_isPool=true;
			reset();
		}
		/**是否已经回收
		 */		
		public function get isPool():Boolean
		{
			return _isPool;
		}

		public function getID():int
		{
			return __id;
		}

		
		public function disposeToPool():void
		{
			PoolCenter.Instance.toPool(this);
		}
	}
}