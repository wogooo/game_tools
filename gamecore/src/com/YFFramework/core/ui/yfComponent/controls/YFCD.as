package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.movie.BitmapEx;
	import com.YFFramework.core.ui.movie.RawMovieClip;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**  
	 * CD有一个 数据转化的过程 所以 需要预先转化
	 * 数据为单例
	 *   CD 播放器
	 * 2012-8-21 上午11:42:30
	 *@author yefeng
	 */
	public class YFCD extends RawMovieClip
	{
		private static var _style:YFStyle;
		private static var _dataArr:Vector.<BitmapDataEx>;
		public function YFCD()
		{
			super();
			start();
		}
		/** 就如游戏就要初始化 而不是在需要时初始化  因为下面有一个 影片剪辑转化为位图的过程  需要预先处理
		 * 
		 * 该处理放到 Common.fla文件中处理
		 */		
		public static function iniCD():void
		{
			if(!_dataArr)
			{
				_style=YFSkin.Instance.getStyle(YFSkin.CD);
				var mc:MovieClip=_style.link as MovieClip;
				_dataArr=Cast.MCToSequence(mc,new Point(200,200));
				mc=null;
			}
		}
		override protected function initUI():void
		{
			super.initUI();
			initData(_dataArr);
		}
		/** 释放内存 但是 CD图片不进行释放
		 */		
		override public function dispose():void
		{
			super.dispose();
			_style=null;
		}
	}
}