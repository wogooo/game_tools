package com.YFFramework.core.center.manager.update
{
	import com.YFFramework.core.debug.print;
	
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
		public var frame21:UpdateFrame;
		/**  管理场景建筑的显示与移出
		 */		
		public var frame61:UpdateFrame;
		/**小地圖上怪物位置的刷新   每隔 3秒刷一次
		 */		
		public var frame101:UpdateFrame;
		
		/**  对象池 多余对象gc的时间  
		 */		
		public var frame3601:UpdateFrame;
		/** 每 10s  检查一次怪物说话
		 */		
		public var frame301:UpdateFrame;
		/**  每五秒检测一次  用来检测玩家是否能上坐骑
		 */		
		public var frame153:UpdateFrame;
		/**每20秒检测一次,用于检测玩家是否能打坐
		 */		
		public var frame601:UpdateFrame;
		
		
		private static  var _instance:UpdateManager;
		
		///稳定帧频计算  变量 ---------------------
		
		/** 当前时间
		 */		
		private var _time:Number=0;
		public static const IntervalRate:int=33;//间隔时间为33毫秒 1000/30
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
		
		private var updateCoreDict:Vector.<IUpdate>;

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
			updateCoreDict=new Vector.<IUpdate>();
		//	var stage:Stage=StageProxy.Instance.stage;
			framePer=new UpdateFrame(1);//每一帧都执行
			frame9=new UpdateFrame(9);
			frame21=new UpdateFrame(21);
	//		frame45=new UpdateFrame(45);
			frame61=new UpdateFrame(61);
			frame101=new UpdateFrame(101);
			frame3601=new UpdateFrame(3601);
			frame301=new UpdateFrame(301);
			frame153=new UpdateFrame(153);
			frame601=new UpdateFrame(601);
			_time=getTimer();
		}
		
		/** 对更新函数进行统一
		 */		
		public function update():void
		{
			_dif=getTimer()-_time;
			_times=int(_dif/IntervalRate);
			if(_times==0) 
			{
				_times=1;
				_position +=_dif-IntervalRate;/// 差时间
			}
			else 
			{
				_position +=(_dif-IntervalRate)%IntervalRate
			}
	//对position 进行计算
			_positionTimes=int(_position/IntervalRate);
			_position=_position%IntervalRate;
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
					_position +=_positionTimes*IntervalRate;
					_times=0;
				}
			}
			
			
			_time=getTimer();
			while(_times--)  ///默认为1此次 发生掉帧的话就会变为 多次 这个时候需要将其补上来
			{
//				try
//				{
					handle();		
//				}
//				catch(e:Error)
//				{
//					print(this,"此处出现错误了");
//					handle();
//				}
				
			}
		}
		/** 初始化各个调用函数 
		 */			
		private function handle():void
		{
			framePer.update();
			frame9.update();
			frame21.update();
	//		frame45.update();
			frame61.update();
			frame101.update();
			frame3601.update();
			frame301.update();
			frame153.update();
			frame601.update();
			
			///检测临时注册
			for each (var updateCore:IUpdate in updateCoreDict)
				updateCore.update();//执行注册了函数
			
				///调试冲绘区域
			//	showRedrawRegions(true,0xFF0000);
		}
		
		
		/**注册需要更新的函数
		 */		
		public function  regUpdateCore(func:IUpdate):void
		{
			var index:int=updateCoreDict.indexOf(func);
			if(index==-1)updateCoreDict.push(func);
		}
		/** 卸载更新函数
		 */		
		public function  delUpdateCore(func:IUpdate):void
		{
			var index:int=updateCoreDict.indexOf(func);
			if(index!=-1) updateCoreDict.splice(index,1)
		}
		
		
	}
}