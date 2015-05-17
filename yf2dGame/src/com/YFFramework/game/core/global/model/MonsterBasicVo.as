package com.YFFramework.game.core.global.model
{
	import flash.utils.getTimer;

	/**@author yefeng
	 *2012-8-28下午10:36:34
	 */
	public class MonsterBasicVo
	{
		/**  静态id 
		 */ 
		public var basicId:int;
		/**名称
		 */
		public var name:String;
		/**资源id 
		 */
		public var resId:int;
		
		/**等级
		 */		
		public var level:int;
		
		/**怪物移动速度
		 */ 
		public var speed:int;
		/** 怪物说的话
		 */		
		private var _words:Array;
		/**怪物每次说话的时间间隔
		 */		
		public var wordsInterval:int;
		
		private var _wordsLen:int;
		/** 说话索引
		 */		
		private var _worldIndex:int;
		/**当前时间
		 */		
		private var _currentTime:Number;
		public function MonsterBasicVo()
		{
			_worldIndex=0;
			_currentTime=getTimer();
		}
		/**  得到怪物可以说的话 
		 */		
		public function getWord():String
		{
			var word:String=_words[_worldIndex];
			++_worldIndex;
			_worldIndex=_worldIndex%_wordsLen;
			return word;
		}
		
		public function set words(arr:Array):void
		{
			_words=arr;
			_wordsLen=_words.length;
		}
		
		public function get words():Array
		{
			return _words;
		}
		/** 能否进行说话
		 */		
		public function canSay():Boolean
		{
			//能够进行说话
			if(_wordsLen>0)
			{
				var dif:Number=getTimer()-_currentTime;
				if(dif>wordsInterval)
				{
					_currentTime=getTimer();
					return true;
				}
				return false;
			}
			return false
		}
		
		
		
	}
}