package com.YFFramework.core.yf2d.display.sprite2D
{
	
	
	/**文本对象     主角色的名称    高度 为  16  宽度 为64  只能显示5个名字 也就是只能打出五个字
	 * 2012-11-21 上午11:04:21
	 *@author yefeng
	 */
	public class YF2dGameNameLabel extends YF2dAbsLabel
	{
		private static var _pool:Vector.<YF2dGameNameLabel>=new Vector.<YF2dGameNameLabel>();
		private static const  MaxLen:int=30;
		private static var _curentLen:int=0;
		public function YF2dGameNameLabel()
		{
			super();
			mouseEnabled=false;//不具备鼠标交互能力
		}
		override public function get width():Number
		{
			return _texture.rect.width-2;  //因为生成贴图的时候人为的在 textWidth  上 加了  2 所以这里需要减去2 
		}
		override public function get height():Number
		{
			return _texture.rect.height;
		}

		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			if(_texture)
			{
				_texture.dispose();
				_texture=null;
			}
		}
		/**对象池获取文本
		 */		
		public static function getYF2dGameNameLabel():YF2dGameNameLabel
		{
			var label:YF2dGameNameLabel;
			if(_curentLen>0)
			{
				_curentLen--;
				label= _pool.pop();
				label.initFromPool();
			}
			else label=new YF2dGameNameLabel();
			return label;
		}
		/**存入对象池
		 */		
		public static function toYF2dGameNameLabelPool(label:YF2dGameNameLabel):void
		{
			if(_curentLen<MaxLen)
			{
				var index:int=_pool.indexOf(toYF2dGameNameLabelPool);
				if(index==-1)
				{
					label.disposeToPool();
					_pool.push(label);
					_curentLen++;
				}
			}
		}

		
	}
}