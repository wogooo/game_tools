package com.YFFramework.game.core.module.im.model
{
	/**私聊数据vo  包含具体的内容
	 * @author yefeng
	 * 2013 2013-6-25 下午6:02:21 
	 */
	public class PrivateTalkContentVo
	{
		/**私聊对象id  好友私聊 选择 id 作为 键值
		 */		
		public var toId:int;
		/**私聊对象名称 也是作为key值     陌生人私聊选择名字作为私聊
		 */		
//		public var toName:String;
		/**私聊的内容
		 */		
		public var content:String;
		public function PrivateTalkContentVo()
		{
		}
	}
}