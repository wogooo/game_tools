package com.YFFramework.core.yf2d.extension
{
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.tween.TweenGuidePlay;
	import com.YFFramework.core.yf2d.extension.face.IYF2dMovie;

	/**坐骑头部  保存  坐骑引导点信息
	 * @author yefeng
	 * 2013 2013-4-27 上午10:42:34 
	 */
	public class MountHeadPart extends RolePart2DView implements IYF2dMovie
	{
		/**偏移设置 里面带有 Object参数  {x,y}
		 */		
		private var _updateOffsetFunc:Function;
		private var _tweenGuidePlay:TweenGuidePlay;
		public function MountHeadPart(updateOffsetFunc:Function)
		{
			_updateOffsetFunc=updateOffsetFunc;
			super();
		}
		public  function initUpdateFunc(updateOffsetFunc:Function):void
		{
			_updateOffsetFunc=updateOffsetFunc;
			_tweenGuidePlay.setPlayFunc(_updateOffsetFunc);
		}
		override protected function initUI():void
		{
			super.initUI();
			_tweenGuidePlay=new TweenGuidePlay();
			_tweenGuidePlay.setPlayFunc(_updateOffsetFunc);
		}
		/**开始引导
		 */		
		public function startGuide():void
		{
			_tweenGuidePlay.start();
		}
		/**停止引导
		 */		
		public function stopGuide():void
		{
			_tweenGuidePlay.stop();
		}
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false):void
		{
			super.play(action, direction, loop, completeFunc, completeParam, resetPlay);
			var direcitonObj:Object=TypeDirection.getCopyDirection(direction);
			var myDireciton:int=direcitonObj.direction;  ///方向
			if(actionDataStandWalk)
			{
				var offsetObject:Object=actionDataStandWalk.getOffsetData();
				if(offsetObject)
				{
					if(offsetObject[action])
					{
						var __scaleX:Number=1;
						if(direction>=TypeDirection.LeftDown&&direction<=TypeDirection.LeftUp)__scaleX=-1;
						var arr:Array=offsetObject[action][myDireciton];
						_tweenGuidePlay.initData(arr,__scaleX,loop);
						_tweenGuidePlay.start();
					}
				}
			}
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_tweenGuidePlay.dispose();
			_tweenGuidePlay=null;
			_updateOffsetFunc=null;
		}
		
		override public function disposeToPool():void
		{
			stopGuide();
			super.disposeToPool();
			_updateOffsetFunc=null;
		}
	}
}