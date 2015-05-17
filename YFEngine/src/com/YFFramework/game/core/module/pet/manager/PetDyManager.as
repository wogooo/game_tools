package com.YFFramework.game.core.module.pet.manager
{
	import com.YFFramework.core.debug.Log;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	
	import flash.utils.Dictionary;

	/** 可以多宠物出战
	 * @author yefeng
	 *2012-9-16下午10:03:18
	 */
	public class PetDyManager
	{
		
		private static var _instance:PetDyManager;
		/**  缓存所有的宠物
		 */		
		private var _dict:Dictionary;
		
		/**出战的宠物  里面保存的出战宠物的动态 id :String
		 */ 
		private var _fightPetArr:Array;
		public function PetDyManager()
		{
			_dict=new Dictionary();
			_fightPetArr=[];
		}
		public static function get Instance():PetDyManager
		{
			if(_instance==null) _instance=new PetDyManager();
			return _instance;
		}
		
		/**  缓存服务端发来的宠物列表   {basicId  dyId level }   服务端的  RequestPetVo 类
		 */
		public function cachePetList(arr:Array):void
		{
			var petDyVo:PetDyVo;
			for each(var obj:Object in arr)
			{
				petDyVo=new PetDyVo();
				petDyVo.dyId=obj.dyId;
				petDyVo.basicId=obj.basicId;
				petDyVo.level=obj.level;
				petDyVo.roleName=obj.name;
				petDyVo.quality=obj.quality;
				_dict[petDyVo.dyId]=petDyVo;
			}
		}
		
		/**添加宠物
		 */ 
		public function addPet(petDyVo:PetDyVo):void
		{
			_dict[petDyVo.dyId]=petDyVo;
		}
		/**删除宠物
		 */		
		public function deletePet(dyId:String):void
		{
			_dict[dyId]=null;
			delete _dict[dyId];
		}
		
		/**返回宠物列表
		 */ 
		public function getPetDict():Dictionary
		{
			return _dict;	
		}
		
		/**获取宠物列表  品质高 的放在前面    再就是等级高的放前面
		 */ 
		public function getPetList():Array
		{
			var arr:Array=[];
			for each(var petDyVO:PetDyVo in _dict)
			{
				arr.push(petDyVO);
			}
			arr.sortOn("quality",Array.DESCENDING | Array.NUMERIC);	///从高到低进行品质排序
			return arr;
		}
		
		
		public function getPetDyVo(dyId:String):PetDyVo
		{
			return _dict[dyId];
		}
		/**是否具有宠物
		 * @param dyId
		 */		
		public function hasPet(dyId:String):Boolean
		{
			var petDyVo:PetDyVo=_dict[dyId];
			if(petDyVo==null) return false;
			return true;
		}
		
		/**获取默认宠物
		 */ 
		public function getDefaultPetDyVo():PetDyVo
		{
			for each(var petVo:PetDyVo in _dict)
			{
				return petVo;
			}
			return null;
		}
		
		/** 出战的宠物 
		 */		
		public function getFightPlayer():Array
		{
			return _fightPetArr;
		}
		
		/**  出战宠物  宠物出战
		 * mapX mapY 是宠物出战后的id 
		 */		
		public function setPetPlay(dyId:String):void
		{
			var petDyVo:PetDyVo=_dict[dyId];
			if(petDyVo)
			{
				_fightPetArr.push(dyId);
			}
			else 
			{
				print(this,"不存在该宠物，无法出战!");
				Log.Instance.v("不存在该宠物，无法出战!");
			}
		}
		/**召回宠物
		 */ 
		public function callBackPet(dyId:String):void
		{
			var petDyVo:PetDyVo=_dict[dyId];
			if(petDyVo)
			{
				var index:int=_fightPetArr.indexOf(dyId);
				if(index!=-1)_fightPetArr.splice(index,1);
			}
		}
		/**是否为出战宠物
		 * petDyId 宠物动态id 
		 */		
		public function isFightPet(petDyId:String):Boolean
		{
			var index:int=_fightPetArr.indexOf(petDyId);	
			if(index!=-1) return true;
			return false;
		}
			
		
		
		
	}
}