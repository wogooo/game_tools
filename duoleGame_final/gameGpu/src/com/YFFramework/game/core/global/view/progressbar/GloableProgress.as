package com.YFFramework.game.core.global.view.progressbar
{
	/**全局进度条控制显示类  控制游戏中所有和进度相关的类
	 * @author yefeng
	 * 2013 2013-7-9 下午7:06:38 
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.extend.ProgressBarEx;
	
	public class GloableProgress 
	{
		/**采集进度条
		 */		
		private var _gatherProgress:ProgressControl;
		
		/**坐骑进度条
		 */
		private var _mountProgress:ProgressControl;

		private static var _instance:GloableProgress;
		
		public function GloableProgress()
		{
			_gatherProgress=new ProgressControl("采集中...");
			_mountProgress=new ProgressControl("骑乘中...");
		}
		public static function get Instance():GloableProgress
		{
			if(!_instance)_instance=new GloableProgress();	
			return _instance;
		}
		/**显示采集进度条
		 */		
		public function showGatherProgress(callBack:Function,param:Object=null):void
		{
			_gatherProgress.showGatherProgress(callBack,param);
		}
		/**停止采集进度条
		 */		
		public function stopGatherProgress():void
		{
			_gatherProgress.stopGatherProgress();
		}
		
		
		public function showMountProgress(callBack:Function,param:Object=null):void
		{
			_mountProgress.showGatherProgress(callBack,param);
		}
		/**停止采集进度条
		 */		
		public function stopMountProgress():void
		{
			_mountProgress.stopGatherProgress();
		}

		
	}
}