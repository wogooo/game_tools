package com.YFFramework.game.core.global.model
{
	import flash.utils.getTimer;

	public class MonsterBasicVo
	{
		/**  名称
		 */		
		public var name:String;
		public var unit_id:int;
		public var move_speed:int;
		public var level:int;
		public var dialog:int;
		/** 怪物图像图标
		 */		
		public var icon_id:int;
		/**模型id 
		 */		
		public var model_id:int;

		/**说话
		 */		
		public var bubble1:String;
		public var bubble2:String;
		public var bubble3:String;

		/**怪物每次说话的时间间隔
		 */		
		public var wordsInterval:int;


		/** 怪物说的话
		 */		
		private var _words:Array;
		
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
			_wordsLen=3;
		}
		
		/**  得到怪物可以说的话 
		 */		
		public function getWord():String
		{
			_words=[bubble1,bubble2,bubble3];   
			var word:String=_words[_worldIndex];
			++_worldIndex;
			_worldIndex=_worldIndex%_wordsLen;
			return word;
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
		
		/**获取现实的 怪物名称
		 */		
		public function getName():String
		{
			return name+"("+level+"级)";
		}
		
	}
}