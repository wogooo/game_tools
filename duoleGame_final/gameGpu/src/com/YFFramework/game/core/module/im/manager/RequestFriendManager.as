package com.YFFramework.game.core.module.im.manager
{
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	
	import flash.utils.Dictionary;

	/**请求添加好友的管理器 存储 多个请求者
	 * @author yefeng
	 * 2013 2013-6-22 下午5:35:09 
	 */
	public class RequestFriendManager
	{
		private var _arr:Array;
		private var _dict:Dictionary;
		private static var _instance:RequestFriendManager;
		public function RequestFriendManager()
		{
			_arr=[];
			_dict=new Dictionary();
		}
		
		public static function get Instance():RequestFriendManager
		{
			if(!_instance) _instance=new RequestFriendManager();
			return _instance;
		}
		
		public function addRole(requestFriendVo:RequestFriendVo):void
		{
			if(!_dict[requestFriendVo.dyId]) //如果之前没有进行请求
			{
				var index:int=_arr.indexOf(requestFriendVo);
				if(index==-1)_arr.push(requestFriendVo.dyId);
				_dict[requestFriendVo.dyId]=requestFriendVo
			}
		}
		public function getRole(dyId:int):RequestFriendVo
		{
			return _dict[dyId];
		}
		public function removeRole(requestFriendVo:RequestFriendVo):void
		{
			var index:int=_arr.indexOf(requestFriendVo.dyId);
			if(index!=-1)_arr.splice(index,1);
			delete _dict[requestFriendVo.dyId];
		}
		
		public function clear():void
		{
			_arr=[];
			_dict=new Dictionary();
		}
		public function getArray():Array
		{
			return _arr;
		}
	}
}