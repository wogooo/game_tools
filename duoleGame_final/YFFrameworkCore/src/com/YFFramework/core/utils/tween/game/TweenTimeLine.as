package com.YFFramework.core.utils.tween.game
{
	

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
		private var _isDispose:Boolean;
		public function TweenTimeLine()
		{
			_tweenArr=new Vector.<TweenSimple>();
			_playIndex=0;
			_isDispose=false
		}
//		public function identify():void
//		{
//			dispose();
//			_isDispose=false;
//		}
		public function getIsDispose():Boolean
		{
			return _isDispose;
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
			if(!_isDispose)
			{
				_playLen=_tweenArr.length;
				if(_playIndex<_playLen)_tweenArr[_playIndex].start();
			}
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
			if(_playIndex<_playLen)	_tweenArr[_playIndex].start();
			else ///最后一个
			{
				if(completeFunc!=null)completeFunc(completeParam);
		//		dispose();
			}
		}
		
		
		public function dispose():void
		{
			if(!_isDispose)
			{
				var tweenSimple:TweenSimple;
				for(var i:int=0;i!=_playLen;++i)
				{
					tweenSimple=_tweenArr[i];
					tweenSimple.dispose();
				//	TweenSimple.toPool(tweenSimple);
				}
				completeFunc=null;
				completeParam=null; 
				_playIndex=0;
				_isDispose=true;
				_tweenArr.length=0;
			}
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
			var tweenSimple:TweenSimple;
			for(var i:int=0;i!=_playLen;++i)
			{
				tweenSimple=_tweenArr[i];
				tweenSimple.stop();
			}
		}
		/**恢复
		 */		
		public function reset():void
		{
			var tweenSimple:TweenSimple;
			for(var i:int=0;i!=_playLen;++i)
			{
				tweenSimple=_tweenArr[i];
				tweenSimple.start();
			}
		}
			
				
		
		
		
		
	}
}