package com.YFFramework.game.core.global.view.progressbar
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.extend.ProgressBarEx;

	/**进度条
	 * @author yefeng
	 * 2013 2013-9-29 下午4:13:13 
	 */
	public class ProgressControl
	{
		/**采集进度条
		 */		
		private var _gatherProgress:ProgressBarEx;
		
		private var _isStart:Boolean=false;
		private var _time:Number;
		/**
		 * @param txt 显示的文本  
		 * @param time  进度消耗的总时间
		 */
		public function ProgressControl(txt:String="采集中...",time:int=1500)
		{
			_gatherProgress=new ProgressBarEx(1);
			_gatherProgress.setText(txt);
			_time=time
			addEvents();
		}
		private function addEvents():void
		{
			ResizeManager.Instance.regFunc(gardProgressResize);
		}
		private function gardProgressResize():void
		{
			PopUpManager.centerDownPopUp(_gatherProgress);
		}
		/**显示采集进度条
		 */		
		public function showGatherProgress(callBack:Function,param:Object=null):void
		{
			if(!_isStart)
			{
				_gatherProgress.percent=0;
				_gatherProgress.play(_time,gatherProgressFunc,{func:callBack,param:param});
				if(!LayerManager.TipsLayer.contains(_gatherProgress))LayerManager.TipsLayer.addChild(_gatherProgress);
				PopUpManager.centerDownPopUp(_gatherProgress);
				_isStart=true;
			}
		}
		/**
		 */		
		private function gatherProgressFunc(param:Object=null):void
		{
			stopGatherProgress();
			var func:Function=param.func;
			var param:Object=param.param;
			if(func!=null)func(param);
		}
		/**停止采集进度条
		 */		
		public function stopGatherProgress():void
		{
			if(_isStart)
			{
				_isStart=false;
				_gatherProgress.stop();
				if(LayerManager.TipsLayer.contains(_gatherProgress))LayerManager.TipsLayer.removeChild(_gatherProgress);
			}
		}
	}
}