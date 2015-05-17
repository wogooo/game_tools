package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	
	import flash.utils.getTimer;

	/** 技能播放类      将一个技能 分割成多点受击  客户端分割 攻击 进行播放   受击者播放多次受击动画
	 *  2012-7-11
	 *	@author yefeng
	 */
	public class TweenSuperSkill extends AbsPool
	{
		private var _time:Number;
		private var _timeArr:Array;
		private var _playFunc:Function;
		private var _playParam:Object;
		private var _len:int;
		
		/**函数当前要调用的索引时间
		 */
		private var _invokeIndex:int;
		
		private var _totalTimes:Number;
		private var _totalCompleteFunc:Function;
		private var _totalCompleteParam:Object;
		
		/** break函数 终止触发函数
		 */		
		private var _breakFunc:Function;
		private var _breakParam:Object;
		/** 临时变量 
		 */		
		private var _tempDif:Number; 
		/**totalComplete函数是否执行了
		 */ 
		private var _isTotalCompleteTrigger:Boolean;
		
		private var _isStart:Boolean;
		public function TweenSuperSkill()
		{
			super();
			_isStart=false;
		}
		
		
		/**注册对象池
		 */		
		override protected function regObject():void
		{
			regPool(10);
		}

		
		/**
		 * @param timesArr   函数执行的时间轴 
		 * @param playFunc	调用函数
		 * @param playParam	函数参数
		 * @param totalTimes  该动作执行的总时间    
		 * @param totalCompleteFunc	时间到后调用
		 * @param totalCompleteParam 参数
 		 * @param breakFunc  <暂时不用>   该类被强行终
		 * @param breakParam <暂时不用> breakFunc的参数
		 */
		public static  function excute(timesArr:Array,playFunc:Function,playParam:Object=null,totalTimes:Number=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null,breakFunc:Function=null,breakParam:Object=null):TweenSuperSkill
		{
			var tweenSuperSkill:TweenSuperSkill=PoolCenter.Instance.getFromPool(TweenSuperSkill) as TweenSuperSkill;//new TweenSuperSkill();//
			tweenSuperSkill.handle(timesArr,playFunc,playParam,totalTimes,totalCompleteFunc,totalCompleteParam,breakFunc,breakParam);
			return tweenSuperSkill;
		}
		
		
		/**
		 * @param timesArr  时间数组  每到 timeArr里面的时间值时执行一次函数   timeArr就是一个时间轴  值如下     o 30  60   等等 后面的值必须比前面的值大    单位为毫秒
		 * @param playFunc	在各个时间段调用的函数
		 * @param playParam 函数参数
		 * @param totalTimes  该动作执行的总时间    
		 * @param totalCompleteFunc	时间到后调用    当  totalCompleteFunc为 null 时  则不进行调用 totalTimes无效
		 * @param totalCompleteParam 参数
		 * @param breakFunc     该类被强行终止dispose 的话 ，假如没有执行totalCompleteFunc 函数 的话  则 执行 breakFunc作为补救 告诉该函数强制被中断，假如totalCompleteFunc执行了的话，breakFunc就不执行
		 * @param breakParam breakFunc的参数
		 */
		private function  handle(timesArr:Array,playFunc:Function,playParam:Object=null,totalTimes:Number=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null,breakFunc:Function=null,breakParam:Object=null):void
		{
			_timeArr=timesArr;
			_playFunc=playFunc;
			_playParam=playParam;
			_len=timesArr.length;
			_invokeIndex=0;
			_totalTimes=totalTimes>_timeArr[_len-1]?totalTimes:_timeArr[_len-1];
			_totalCompleteFunc=totalCompleteFunc;
			_totalCompleteParam=totalCompleteParam;
			_breakFunc=breakFunc;
			_breakParam=breakParam;
			
			_isTotalCompleteTrigger=false;
			_time=getTimer();
			UpdateManager.Instance.framePer.regFunc(update);
			_isStart=true;
			update();
		}
		
		/**  更新 	
		 */
		private function update():void
		{
			if(_isStart)
			{
				_tempDif=getTimer()-_time;
				if(_invokeIndex<_len)
				{
					if(_tempDif>=_timeArr[_invokeIndex]) 
					{
						_playFunc(_playParam);
						++_invokeIndex;
						//	if(_invokeIndex>=_len&&_totalCompleteFunc==null) disposeToPoolWidthStop();
					}
				}
				if(_tempDif>=_totalTimes)
				{
					if(_totalCompleteFunc!=null)	_totalCompleteFunc(_totalCompleteParam);
					_isTotalCompleteTrigger=true;
					disposeToPoolWidthStop();
				}
			}
		}
		
		private function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.framePer.delFunc(update);
		}
		
		private function destroy():void
		{
			 stop();
			_timeArr=null;
			_playFunc=null;
			_playParam=null;
			_totalCompleteFunc=null;
			_totalCompleteParam=null;
			_breakFunc=null;
			_breakParam=null;
			_isTotalCompleteTrigger=true;

		}
		
		/** 停止播放 释放内存 一般当动画没有播放完 而人物又死亡的状况下播放该动画
		 */
		override public function reset():void
		{
			///假如 totalComplete函数没有执行而被强行终止了
			if(!_isTotalCompleteTrigger)
			{
				if(_breakFunc!=null) _breakFunc(_breakParam);
				_isTotalCompleteTrigger=true;
			}
			
	//		UpdateManager.Instance.framePer.delFunc(update);
//			_timeArr=null;
//			_playFunc=null;
//			_playParam=null;
//			_totalCompleteFunc=null;
//			_totalCompleteParam=null;
//			_breakFunc=null;
//			_breakParam=null;
//			_isTotalCompleteTrigger=true;
		}
		/** 立马中断 函数       disposeToPool 是在时间到之后才释放内存   disposeToPoolWidthStop 是立马释放内存 
		 * 也中断了
		 */		
		public function disposeToPoolWidthStop():void
		{
			destroy();
			super.disposeToPool();
		}
		
		override public function disposeToPool():void
		{
			reset();
		}
		
		public function dispose():void
		{
			reset();
		}
		
	}
}