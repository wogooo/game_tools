package com.YFFramework.game.core.module.npc.model
{
	import com.YFFramework.core.utils.StringUtil;
	
	import flash.utils.getTimer;

	/**缓存 Npc_config数据表
	 */	
	public class Npc_ConfigBasicVo
	{
		
		/** npc 的静态  id 
		 */		
		public var basic_id:int;
		/**    图像 图标      半身像图标 和小图标的id 一样
		 */		
		public var icon_id:int;
		/**名称
		 */		
		public var name:String;

		
		/** 功能类型
		 */		
		public var func_type1:int;
		/** 对应的功能id 
		 */		
		public var func_id1:int;
		/** 功能描述
		 */		
		public var func_desc1:String;

		public var func_type2:int;
		public var func_id2:int;
		public var func_desc2:String;

		
		public var func_id3:int;
		public var func_type3:int;
		public var func_desc3:String;
		/**阵营
		 */		
		public var camp:int;
		/** 模型id 
		 */		
		public var model_id:int;
		/**默认对话框
		 */		
		public var defaultDialog:String;
		
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

		public function Npc_ConfigBasicVo()
		{
			_worldIndex=0;
			_currentTime=getTimer();
//			_wordsLen=3;
		}
		
		/**  得到NPC可以说的话 
		 */		
		public function getWord():String
		{
//			_words=[bubble1,bubble2,bubble3];   
			var word:String=_words[_worldIndex];
			++_worldIndex;
			_worldIndex=_worldIndex%_wordsLen;
			return word;
		}
		
		public function  initWords():void
		{
			_words=[];   
			if(isCanUseStr(bubble1))
			{
				_words.push(bubble1);
			}
			if(isCanUseStr(bubble2))
			{
				_words.push(bubble2);
			}
			if(isCanUseStr(bubble3))
			{
				_words.push(bubble3);
			}
			_wordsLen=_words.length;
		}
		/**是否是可用的 字符串
		 */		
		private function isCanUseStr(str:String):Boolean
		{
			if(str)
			{
				if(str!="")return true;
			}
			return false;
		}
		
		/** 能否进行说话
		 */		
		public function canSay():Boolean
		{
			//能够进行说话
			if(_wordsLen>0&&_wordsLen>0)
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