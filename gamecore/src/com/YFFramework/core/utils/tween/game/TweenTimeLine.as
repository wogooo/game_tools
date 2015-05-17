package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.PoolCenter;

	/**控制管理  TweenSimplet
	 * @author yefeng
	 *2012-7-12下午10:02:36
	 */
	public class TweenTimeLine
	{
		public var completeFunc:Function;
		public var completeParam:Object; 
		private var _tweenArr:Vector.<TweenSimple>;
		private var _playIndex:int;
		private var _playLen:int;
		public function TweenTimeLine()
		{
			_tweenArr=new Vector.<TweenSimple>();
			_playIndex=0;
		}
		/** 变为初始状态
		 */
		public function identify():void
		{
			dispose();
			_tweenArr=new Vector.<TweenSimple>();
			_playIndex=0;
		}
		/** tween的完成函数将会被忽略
		 */		
		public function addTween(tween:TweenSimple):void
		{
			tween._completeFunc=invoke;
			_tweenArr.push(tween);
		}
		
		public function start():void
		{
			_playLen=_tweenArr.length;
			if(_playIndex<_playLen)_tweenArr[_playIndex].start();
		}
		/**更新移动速度
		 */		
		public function updateSpeed(speed:Number):void
		{
			for each (var tweenSimple:TweenSimple in _tweenArr)
			{
				tweenSimple.updateSpeed(speed);
			}
		}
		
		private function invoke(data:Object):void
		{
			++_playIndex;
			if(_playIndex!=_playLen)	_tweenArr[_playIndex].start();
			else ///最后一个
			{
				if(completeFunc!=null)completeFunc(completeParam);
				dispose();
			}
		}
		
		
		public function dispose():void
		{
	//		if(_playIndex<_playLen)	_tweenArr[_playIndex].stop();
			for each (var tweenSimple:TweenSimple in _tweenArr)
			{
//				tweenSimple.stop();
//				tweenSimple.dispose();
				PoolCenter.Instance.toPool(tweenSimple);//// 回收对象
			}
			completeFunc=null;
			completeParam=null; 
			_tweenArr=null;
		}
		/**返回当前播放索引
		 */		
		public function get playIndex():int
		{
			return _playIndex;
		}
		
		
		/**停止
		 */		
		public function stop():void
		{
			for each (var tweenSimple:TweenSimple in _tweenArr)
			{
				tweenSimple.stop();
			}

		}
		/**恢复
		 */		
		public function reset():void
		{
			for each (var tweenSimple:TweenSimple in _tweenArr)
			{
				tweenSimple.start();
			}

		}
			
				
		
		
		
		
	}
}