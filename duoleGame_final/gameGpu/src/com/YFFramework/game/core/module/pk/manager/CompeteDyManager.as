package com.YFFramework.game.core.module.pk.manager
{
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.pk.model.CompeteDyVo;
	

	/**缓存  请求的PK列表
	 * @author yefeng
	 * 2013 2013-5-6 下午4:02:56 
	 */
	public class CompeteDyManager
	{
		private static var _instance:CompeteDyManager;
		private var _array:Array;
		
		public function CompeteDyManager()
		{
			_array=[];
		}
		
		public static function get Instance():CompeteDyManager
		{
			if(_instance==null)_instance=new CompeteDyManager();
			return _instance;
		}
		/**添加请求的 PK玩家
		 */		
		private function addRole(competeDyVo:CompeteDyVo):void
		{
			var index:int=_array.indexOf(competeDyVo);
			if(index==-1)_array.push(competeDyVo);
		}
		
		public function addCompeteRole(dyId:int):void{
			if(!containsCompeteRole(dyId)){
				var competeDyVo:CompeteDyVo=new CompeteDyVo();
				var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(dyId) as RoleDyVo;
				competeDyVo.dyId=roleDyVo.dyId;
				competeDyVo.level=roleDyVo.level;
				competeDyVo.name=roleDyVo.roleName;
				_array.push(competeDyVo);
			}
		}
		
		private function containsCompeteRole(dyId:int):Boolean{
			var len:int=_array.length;
			for(var i:int=0;i<len;i++){
				if(_array[i].dyId==dyId)	return true;
			}
			return false;
		}

		public function delCompeteRole(competeDyoVo:CompeteDyVo):void
		{
			var index:int=_array.indexOf(competeDyoVo);
			if(index!=-1)_array.splice(index,1);
		}
		
		public function getCompeteDyVo(dyId:int):CompeteDyVo
		{
			for each(var competeDyVo:CompeteDyVo in _array)
			{
				if(competeDyVo.dyId==dyId) return competeDyVo;
			}
			return null;
		}
		public function clear():void
		{
			_array=[];
		}
		public function getSize():int
		{
			return _array.length;
		}
		/**  获取 PK列表
		 */		
		public function getPkArray():Array
		{
			return _array;
		}
	}
}