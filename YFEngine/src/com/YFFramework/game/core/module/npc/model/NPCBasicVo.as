package com.YFFramework.game.core.module.npc.model
{
	import flash.utils.getTimer;

	/**   该表最终待修改
	 * 缓存npcProp表 
	 * 
	 * 2012-10-24 下午12:42:22
	 *@author yefeng
	 */
	public class NPCBasicVo
	{
		/**npc 的 唯一id 
		 */		
		public var id:int;
		
		/**npc的名称
		 */ 
		public var name:String;
		/**默认对话 点击npc弹出的窗口显示的默认对话
		 */		
		public var defaultWord:String;
		
		/**场景冒泡  npc 说的话
		 */		
		private var _words:Array;
		/** 说话的时间间隔
		 */		
		public var wordsInterval:int;

		
		private var _wordsLen:int;
		/** 说话索引
		 */		
		private var _worldIndex:int;
		/**当前时间
		 */		
		private var _currentTime:Number;

		public function NPCBasicVo()
		{
			_worldIndex=0;
			_currentTime=getTimer();
		}
		
		/**  得到NPC可以说的话 
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