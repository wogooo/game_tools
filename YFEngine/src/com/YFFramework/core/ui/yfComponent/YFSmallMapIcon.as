package com.YFFramework.core.ui.yfComponent
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**游戏中小地图 上的一些图标
	 * 2012-11-6 下午2:31:29
	 *@author yefeng
	 */
	public class YFSmallMapIcon extends YFComponent
	{
		protected var _bitmap:Bitmap;
		/**
		 * @param skinId   1代表
		 */		
		public function YFSmallMapIcon(skinId:int)
		{
			_skinId=skinId;
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_bitmap=new Bitmap();
			addChild(_bitmap);
			initSkin();
		}
		/**初始化皮肤ui 
		 */		
		private function initSkin():void
		{
			var bitmapData:BitmapData;
			switch (_skinId)
			{
				case 1:  // npc图标
					_style=YFSkin.Instance.getStyle(YFSkin.SmallMapNPC);
					bitmapData=_style.link as BitmapData;
					_bitmap.bitmapData=bitmapData;
					_bitmap.x=-bitmapData.width*0.5;
					_bitmap.y=-bitmapData.height;
					break;
				case 2: //  怪物图标
					_style=YFSkin.Instance.getStyle(YFSkin.SmallMapMonsterPic);
					break;
				case 3: /// 地图跳转点图标
					_style=YFSkin.Instance.getStyle(YFSkin.SmallMapExitPic);
					break;
				case 4:  /// 队友图标
					_style=YFSkin.Instance.getStyle(YFSkin.SmallMapTeamPic);
					break;
				case 5:  //怪物 区域图标
					_style=YFSkin.Instance.getStyle(YFSkin.SmallMapMonsterZonePic);
					break;
				case 6://小飞鞋
					_style=YFSkin.Instance.getStyle(YFSkin.SMallMapFlyBoot);
					break;
			}
			
			if(_skinId!=1)
			{
				bitmapData=_style.link as BitmapData;
				_bitmap.bitmapData=bitmapData;
				_bitmap.x=-bitmapData.width*0.5;
				_bitmap.y=-bitmapData.height*0.5;
			}



		}
		/** 释放内存
		 */		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_bitmap=null;
		}	
		
	}
}