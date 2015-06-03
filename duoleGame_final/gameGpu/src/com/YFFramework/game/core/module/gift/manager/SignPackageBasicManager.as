package com.YFFramework.game.core.module.gift.manager
{
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.gift.model.SignPackageBasicVo;
	import com.YFFramework.game.core.module.gift.model.SignPackageVo;
	import com.YFFramework.game.core.module.gift.model.TypeSignPackage;
	
	import flash.utils.Dictionary;

	public class SignPackageBasicManager
	{
		private static var _instance:SignPackageBasicManager;
		private var _dict:Dictionary;
		private var _total:int;
		public function SignPackageBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():SignPackageBasicManager
		{
			if(_instance==null)_instance=new SignPackageBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var signPackageBasicVo:SignPackageBasicVo;
			for (var id:String in jsonData)
			{
				signPackageBasicVo=new SignPackageBasicVo();
				signPackageBasicVo.id=jsonData[id].id;
				signPackageBasicVo.name=jsonData[id].name;
				signPackageBasicVo.reward_id=jsonData[id].reward_id;
				_dict[signPackageBasicVo.id]=signPackageBasicVo;
				_total++;
			}
		}
		public function getSignPackageBasicVo(id:int):SignPackageBasicVo
		{
			return _dict[id];
		}
		
		public function getSignPackageVo():Vector.<SignPackageVo>
		{
			var i:int;
			var vos:Vector.<SignPackageVo>=new Vector.<SignPackageVo>(_total);
			var basicVo:SignPackageBasicVo;
			var vo:SignPackageVo;
			for(i=0;i<_total;i++)
			{
				vo=new SignPackageVo;
				basicVo=_dict[i+1];
				vo.id=basicVo.id;
				vo.name=basicVo.name;
				vo.items=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(basicVo.reward_id);
				vos[i]=vo;
			}
			return vos;
		}
	}
}