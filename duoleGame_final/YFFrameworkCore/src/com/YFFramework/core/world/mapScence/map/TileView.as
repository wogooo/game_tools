package com.YFFramework.core.world.mapScence.map
{
	/**yf2d实现
	 * 背景地图贴图  256*256大小
	 * @author yefeng
	 *2012-11-20下午9:57:54
	 */
	import com.YFFramework.core.yf2d.display.sprite2D.Map2D;
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	
	public class TileView extends Map2D
	{
		
		private static var _pool:Vector.<TileView>=new Vector.<TileView>();
		private static const MaxLen:int=800;// 5120*5120大小
		private static var _len:int=0;//当前池里的个数
		
//		private var _vector3D:Vector3D;
		public function TileView(sceneContainsIt:Function)
		{
			super(0,0,sceneContainsIt);
			_mouseEnabled=false;
			
		}
		override public function  setTextureData(texture2D:ITextureBase,scaleX:Number=1,scaleY:Number=1):void
		{
			super.setTextureData(texture2D,scaleX);
			///设置缩放
			var myW:int=__renderW;
			var myH:int=__renderH;
			this.scaleX=(myW+1)/myW;
			this.scaleY=(myH+1)/myH;
		}
		
		/**获取tileView
		 */		
		public static function getTileView(sceneContainsIt:Function):TileView
		{
			var tileView:TileView;
			if(_len>0)
			{
				tileView=_pool.pop();
				tileView.initFromPool(sceneContainsIt);
				_len--;
			}
			else tileView=new TileView(sceneContainsIt);
			return tileView;
		}
		
		/**回收tileView
		 */		
		public static function toTileViewPool(tileView:TileView):void
		{
			if(_len<MaxLen)
			{
				var index:int=_pool.indexOf(tileView);
				if(index==-1)
				{
					tileView.disposeToPool();
					_pool.push(tileView);
					_len++;
				}
			}
			else tileView.dispose();
		}
		/**填满对象池
		 */		
		public static function FillPool():void
		{
			var tileView:TileView;
			for(var i:int=0;i!=MaxLen;++i)
			{
				tileView=new TileView(null);
				tileView.disposeToPool();
				_pool.push(tileView);
			}
			_len=MaxLen;
		}
		
	}
}