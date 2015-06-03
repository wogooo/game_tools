package com.YFFramework.game.ui.layer
{
	/**@author yefeng
	 * 2013 2013-12-13 下午6:14:37 
	 */
	public class ParticleData
	{
		/** 最大粒子数
		 */		
		private static const MaxNum:int=20;
		private static var _pool:Vector.<ParticleData>=new Vector.<ParticleData>();
		private static var _size:int=0;
		
		/**当前时间
		 */
		public var timeArr:Array;
		/**粒子id 
		 */
//		public var particle_id:int;
		/**内部存储particleBasicVo
		 */
		public var particleArr:Array;
		/**数组长度
		 */
		public var len:int;
		
		/**旋转角度
		 */
		public var degree:Number;
		
		
		/**偏移量  内部保存的是x,y坐标
		 */
		public var offset:Array;
		
		/**粒子类型
		 */
		public  var type:int;
		
		public function ParticleData()
		{
		}
		
		public static function getParticleData():ParticleData
		{
			if(_size>0)
			{
				_size--;
				return _pool.pop();
			}
			return new ParticleData();
		}
		public static function toParticleDataPool(particleData:ParticleData):void
		{
			if(_size<MaxNum)
			{
				_size++;
				_pool.push(particleData);
			}
			particleData=null;
		}

	}
}