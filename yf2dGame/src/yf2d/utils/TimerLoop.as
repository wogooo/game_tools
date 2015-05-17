package yf2d.utils
{
	import flash.utils.getTimer;

	/** 代替 Timer的循环事件 下面是个循环事件
	 * author :夜枫
	 * 时间 ：2011-12-18 下午07:32:05
	 */
	public  class TimerLoop
	{
		/**  表示 已经保存的时间  单位为毫秒
		 */
		protected var postion:int;
		protected var intervalTime:int;
		
		protected var time:int;
		protected var excuteFunc:Function;
		private var isStart:Boolean=false;
		/**
		 * @param intervalTime  时间间隔  单位为毫秒
		 */
		public function TimerLoop(intervalTime:int,func:Function)
		{
			this.intervalTime=intervalTime;
			excuteFunc=func;
		}
		public function start():void
		{
			postion=0;
			time=getTimer();
			isStart=true;
		}
		public function stop():void
		{
			isStart=false;
		}
		/**  该函数需要进行注册调用
		 */		
		public function update():void
		{
			if(isStart)
			{
				var t:int=time;
				time=getTimer();
				var dif:int=time-t;
				postion	+=dif;
				if(postion>=intervalTime)
				{
					excuteFunc();///执行	
					postion=0;
				}
			}

		}
		public function dispose():void
		{
			excuteFunc=null;
		}
	}
}