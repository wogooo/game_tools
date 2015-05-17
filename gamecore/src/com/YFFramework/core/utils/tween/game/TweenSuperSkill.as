package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.utils.getTimer;

	/** 技能播放类      将一个技能 分割成多点受击  客户端分割 攻击 进行播放   受击者播放多次受击动画
	 *  2012-7-11
	 *	@author yefeng
	 */
	public class TweenSuperSkill
	{
		private var _time:Number;
		private var _timeArr:Vector.<Number>;
		private var _playFunc:Function;
		private var _playParam:Object;
		private var _len:int;
		
		/**函数当前要调用的索引时间
		 */
		private var _invokeIndex:int;
		
		private var _totalTimes:Number;
		private var _totalCompleteFunc:Function;
		private var _totalCompleteParam:Object;
		/** 临时变量 
		 */		
		private var _tempDif:Number; 
		public function TweenSuperSkill()
		{
		}
		
		/**
		 * @param timesArr   函数执行的时间轴 
		 * @param playFunc	调用函数
		 * @param playParam	函数参数
		 * @param totalTimes  该动作执行的总时间    
		 * @param totalCompleteFunc	时间到后调用
		 * @param totalCompleteParam 参数
		 */
		public static  function excute(timesArr:Vector.<Number>,playFunc:Function,playParam:Object=null,totalTimes:Number=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null):TweenSuperSkill
		{
			var tweenSuperSkill:TweenSuperSkill=new TweenSuperSkill();
			tweenSuperSkill.handle(timesArr,playFunc,playParam,totalTimes,totalCompleteFunc,totalCompleteParam);
			return tweenSuperSkill;
		}
		
		
		
		
		/**
		 * @param timesArr  时间数组  每到 timeArr里面的时间值时执行一次函数   timeArr就是一个时间轴  值如下     o 30  60   等等 后面的值必须比前面的值大    单位为毫秒
		 * @param playFunc	在各个时间段调用的函数
		 * @param playParam 函数参数
		 * @param totalTimes  该动作执行的总时间    
		 * @param totalCompleteFunc	时间到后调用    当  totalCompleteFunc为 null 时  则不进行调用 totalTimes无效
		 * @param totalCompleteParam 参数
		 */
		private function  handle(timesArr:Vector.<Number>,playFunc:Function,playParam:Object=null,totalTimes:Number=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null):void
		{
			_timeArr=timesArr;
			_playFunc=playFunc;
			_playParam=playParam;
			_len=timesArr.length;
			_invokeIndex=0;
			_totalTimes=totalTimes>_timeArr[_len-1]?totalTimes:_timeArr[_len-1];
			_totalCompleteFunc=totalCompleteFunc;
			_totalCompleteParam=totalCompleteParam;
			_time=getTimer();
			UpdateManager.Instance.framePer.regFunc(update);
			update();
		}
		
		/**  更新 	
		 */
		private function update():void
		{
			_tempDif=getTimer()-_time;
			
			if(_invokeIndex<_len)
			{
				if(_tempDif>=_timeArr[_invokeIndex]) 
				{
					_playFunc(_playParam);
					++_invokeIndex;
					if(_invokeIndex>=_len&&_totalCompleteFunc==null) dispose();
				}
			}
			if(_tempDif>=_totalTimes&&_totalCompleteFunc!=null)
			{
				_totalCompleteFunc(_totalCompleteParam);
				dispose();
			}
		}
		
		
		
		/** 停止播放 释放内存 一般当动画没有播放完 而人物又死亡的状况下播放该动画
		 */
		public function dispose():void
		{
			UpdateManager.Instance.framePer.delFunc(update);
			_timeArr=null;
			_playFunc=null;
			_playParam=null;
			_totalCompleteFunc=null;
			_totalCompleteParam=null;

		}
	}
}