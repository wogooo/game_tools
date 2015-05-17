package movieData.manager.update
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
		
		/** 每7帧执行一次  用于深度排序 
		 */
		public var frame7:UpdateFrame;
		/**  每 22帧执行一次   用于 管理舞台对象的添加与移除  
		 */		
		public var frame22:UpdateFrame;
		
		private static  var _instance:UpdateManager;
		//private var funcArr:Array=[];//保存函数对象 
		//private var len:int;
		
		private var _time:Number=0;
		private static const intervalRate:int=30;//间隔时间为30毫秒
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
			frame7=new UpdateFrame(7);
			frame22=new UpdateFrame(22);
		}
		
		/** 对更新函数进行统一
		 */		
		public function update():void
		{
			var dif:Number=getTimer()-_time;
			var times:int=int(dif/intervalRate);
			if(times==0) times=1;
			_time=getTimer();
			while(times--)  ///默认为1此次 发生掉帧的话就会变为 多次 这个时候需要将其补上来
			{
				handle();
			}
		}
		/** 初始化各个调用函数 
		 */			
		private function handle():void
		{
			framePer.update();
			frame7.update();
			frame22.update();
		}
	}
}