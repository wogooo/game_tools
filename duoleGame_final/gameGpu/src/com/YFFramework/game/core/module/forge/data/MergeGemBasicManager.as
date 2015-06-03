package com.YFFramework.game.core.module.forge.data
{
	import flash.utils.Dictionary;

	/** 
	 * 物品合成
	 */	
	public class MergeGemBasicManager
	{
		private static var _instance:MergeGemBasicManager;
		private var _dict:Dictionary;
		
		public function MergeGemBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():MergeGemBasicManager
		{
			if(_instance==null)_instance=new MergeGemBasicManager();
			return _instance;
		}
		
		public  function cacheData(jsonData:Object):void
		{
			var merge_gemBasicVo:MergeGemBasicVo;
			for (var id:String in jsonData)
			{
				merge_gemBasicVo=new MergeGemBasicVo();
				merge_gemBasicVo.form_id=jsonData[id].form_id;
				merge_gemBasicVo.product_id=jsonData[id].product_id;
				merge_gemBasicVo.mater_id=jsonData[id].mater_id;
				merge_gemBasicVo.money=jsonData[id].money;
				_dict[merge_gemBasicVo.form_id]=merge_gemBasicVo;
			}
		}
		public function getMergeGemBasicVo(form_id:int):MergeGemBasicVo
		{
			return _dict[form_id];
		}
		
		public function getBasicVoByMaterialId(materId:int):MergeGemBasicVo
		{
			for each(var vo:MergeGemBasicVo in _dict)
			{
				if(vo.mater_id == materId)
					return vo;
			}
			return null;
		}
	}
}