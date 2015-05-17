package com.YFFramework.core.center.manager.update
{
	import flash.utils.getTimer;

	/**
	 * 
	 * 更新函数的集合 使整个程序 只有一个enterFrame函数  更新函数最终会在 enterFrame里调用
	 * 
	 * 该函数必须要在EnterFrame中进行调用
	 */
	public class UpdateManager
	{
		/**
		 *  要更新的函数说明
		 */		
		
		/**每帧都执行
		 */		
		public var framePer:UpdateFrame;
		
		/** 每9帧执行一次  用于深度排序 
		 */
		public var frame9:UpdateFrame;
		/**  每 90帧执行一次   用于 管理舞台对象的添加与移除  
		 */		
	//	public var frame45:UpdateFrame;
		
		
		
		/** 管理 舞台角色的显示与隐藏
		 */		
		public var frame20:UpdateFrame;
		/**  管理场景建筑的显示与移出
		 */		
		public var frame60:UpdateFrame;
		
		/**  对象池 多余对象gc的时间 每五分钟gc一次
		 */		
		public var frame9000:UpdateFrame;
		
		private static  var _instance:UpdateManager;
		
		
		
		
		///稳定帧频计算  变量 ---------------------
		
		/** 当前时间
		 */		
		private var _time:Number=0;
		private static const intervalRate:int=33;//间隔时间为33毫秒
		private var _position:Number;/// 多出的部分   可能为负值 
		/** position偏移造成的 次数 
		 */
		private var _positionTimes:int;
		/**和上一帧的时间差 
		 */		
		private var _dif:Number;
		
		/** 当前帧距离上一帧 执行的时间除以 时间间隔得到的次数
		 */
		private var _times:int;
		public function UpdateManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
			else  reg();
		}
		public static function get Instance():UpdateManager
		{
			if(!_instance)	_instance=new UpdateManager();
			return _instance;
		}                                                                                    
		/**注册各个更新函数
		 */		
		private function reg():void
		{
		//	var stage:Stage=StageProxy.Instance.stage;
			framePer=new UpdateFrame(1);//每一帧都执行
			frame9=new UpdateFrame(9);
			frame20=new UpdateFrame(20);
	//		frame45=new UpdateFrame(45);
			frame60=new UpdateFrame(60);
			frame9000=new UpdateFrame(9000);
			
			_time=getTimer();
		}
		
		/** 对更新函数进行统一
		 */		
		public function update():void
		{
			_dif=getTimer()-_time;
			_times=int(_dif/intervalRate);
			if(_times==0) 
			{
				_times=1;
				_position +=_dif-intervalRate;/// 差时间
			}
			else 
			{
				_position +=(_dif-intervalRate)%intervalRate
			}
	//对position 进行计算
			_positionTimes=int(_position/intervalRate);
			_position=_position%intervalRate;
			if(_positionTimes>0)
			{
				_times +=_positionTimes;
			}
			else if(_positionTimes<0)
			{
				if(_time>=Math.abs(_positionTimes))
				{
					_times +=_positionTimes;
				}
				else 
				{
					_positionTimes +=_times;
					_position +=_positionTimes*intervalRate;
					_times=0;
				}
			}
			
			
			_time=getTimer();
			while(_times--)  ///默认为1此次 发生掉帧的话就会变为 多次 这个时候需要将其补上来
			{
				handle();
			}
		}
		/** 初始化各个调用函数 
		 */			
		private function handle():void
		{
			framePer.update();
			frame9.update();
			frame20.update();
	//		frame45.update();
			frame60.update();
			frame9000.update();
		}
	}
}