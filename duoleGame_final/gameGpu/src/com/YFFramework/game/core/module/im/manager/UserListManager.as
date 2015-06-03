package com.YFFramework.game.core.module.im.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.im.model.IMDyVo;

	/**玩家列表  数据
	 * @author yefeng
	 * 2013 2013-6-22 下午2:49:25 
	 */
	public class UserListManager
	{
		/**id作为键值 
		 */		
		private var _listId:HashMap;
		/**名字作为键值
		 */		
		private var _listName:HashMap;
		private var _arr:Array;
		public function UserListManager()
		{
			_listId=new HashMap();
			_listName=new HashMap();
			_arr=[];
		}
		/**添加 角色
		 */		
		public function addRole(imDyVo:IMDyVo):void
		{
			_listId.put(imDyVo.dyId,imDyVo);
			_listName.put(imDyVo.name,imDyVo);
			if(_arr.indexOf(imDyVo.dyId)==-1)_arr.push(imDyVo.dyId);
		}
		/**删除角色
		 */		
		public function removeRole(dyId:int):void
		{
			var imDyVo:IMDyVo=_listId.get(dyId);
			if(imDyVo)
			{
				_listId.remove(dyId);
				_listName.remove(imDyVo.name);
				var index:int=_arr.indexOf(imDyVo.dyId);
				if(index!=-1)_arr.splice(index,1);
			}
		}
		/**是否有角色
		 */		
		public function hasRole(dyId:int):Boolean
		{
			return _listId.hasKey(dyId);
		}
		/** 是否有角色
		 */		
		public function hasRoleByName(name:String):Boolean
		{
			return _listName.hasKey(name);
		}
		
		/** 获取玩家数据
		 */		
		public function getRole(dyId:int):IMDyVo
		{
			return _listId.get(dyId);
		}
		/** 获取玩家列表  列表是有序的    数据为IMDyVo
		 */		
		public function getArray():Array
		{
			var arr:Array=[];
			for each(var id:int in _arr)
			{
				arr.push(getRole(id));
			}
			return arr;
		}
	}
}