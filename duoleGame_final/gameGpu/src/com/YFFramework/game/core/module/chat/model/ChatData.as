package com.YFFramework.game.core.module.chat.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-6-29 上午11:04:32
	 */
	public class ChatData{
		
		/**发送的类型：1.道具；2：装备；3：NPC;4:人物； 5：市场寄售；6：市场求购
		 */		
		public var myType:int;
		/**需要显示在聊天文本的文字；例如：[道具1]的话，displayName="道具1" 
		 */		
		public var displayName:String;
		/**数据的key值，一般为动态id；特殊情况用静态id（市场求购）
		 */		
		public var myId:int;
		/** 品质，对应文字颜色
		 */
		public var myQuality:int;
		/**文本捆绑的数据，可以是任何类型 
		 */
		public var data:*;
		
		public function ChatData(){
		}
	}
} 