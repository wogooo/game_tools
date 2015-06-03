package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.Cast;
	import com.dolo.ui.controls.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**游戏中小地图 上的一些图标
	 * 2012-11-6 下午2:31:29
	 *@author yefeng
	 */
	public class YFSmallMapIcon extends UIComponent
	{
		protected var _bitmap:Bitmap;
		protected var _bitmapMovieClip:BitmapMovieClip;;
		protected var _skinId:int;
		/**
		 * @param skinId   1代表
		 */		
		public function YFSmallMapIcon(skinId:int)
		{
			_skinId=skinId;
			initUI();
		}
		
		/**初始化皮肤ui 
		 */	
		protected function initUI():void
		{
			var bitmapData:BitmapData;
			switch (_skinId)
			{
				case 2: //  怪物图标
					bitmapData=ClassInstance.getInstance("monsterPic") as BitmapData;
					break;
				case 3: /// 地图跳转点图标
					bitmapData=ClassInstance.getInstance("exitPic") as BitmapData;
					_bitmap=new Bitmap();
					addChild(_bitmap);

					break;
				case 4:  /// 队友图标
					bitmapData=ClassInstance.getInstance("teamPic") as BitmapData;
					break;
				case 5:  //怪物 区域图标
					bitmapData=ClassInstance.getInstance("monsterZonePic") as BitmapData;
					break;
				case 6://小飞鞋
					var mc:MovieClip=ClassInstance.getInstance("a931803630");
					var actionData:ActionData=Cast.MCToActionData(mc);
					_bitmapMovieClip=new BitmapMovieClip();
					addChild(_bitmapMovieClip);
					_bitmapMovieClip.initData(actionData);
					_bitmapMovieClip.start();
					_bitmapMovieClip.playDefault();
					break;
				default: // npc图标
//				case 1:  // npc图标
					_bitmap=new Bitmap();
					addChild(_bitmap);
					var mySkinName:String="npc_"+1 //_skinId;
//					bitmapData=ClassInstance.getInstance("smallMapNPCPic") as BitmapData;
					bitmapData=ClassInstance.getInstance(mySkinName) as BitmapData;
					_bitmap.bitmapData=bitmapData;
					_bitmap.x=-bitmapData.width*0.5;
					_bitmap.y=-bitmapData.height;
					break; //计划9月底或者10月出一个删档测试版本   需要策划来调  把游戏串起来
			}
			
			if(_skinId==2||_skinId==3||_skinId==4||_skinId==5)
			{
				
				_bitmap=new Bitmap();
				addChild(_bitmap);
				_bitmap.bitmapData=bitmapData;
				_bitmap.x=-bitmapData.width*0.5;
				_bitmap.y=-bitmapData.height*0.5;
			}



		}
		/** 释放内存
		 */		
		override public function dispose():void
		{
			super.dispose();
			_bitmap=null;
			_bitmapMovieClip=null;
		}	
		
	}
}