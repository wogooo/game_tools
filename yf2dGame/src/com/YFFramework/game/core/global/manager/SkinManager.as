package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.SkinVo;
	
	import flash.utils.Dictionary;

	/**资源总表   皮肤资源管理器
	 * 缓存 skin 表   保存的是各个资源的地址id 
	 * 2012-8-15 下午3:06:10
	 *@author yefeng
	 */
	public class SkinManager
	{
		
		private static var _instance:SkinManager;
		private var _dict:Dictionary;
		public function SkinManager()
		{
			_dict=new Dictionary();
		}
		
		public static function  get Instance():SkinManager
		{
			if(_instance==null) _instance=new SkinManager();
			return _instance;
		}
		public function cacheData(jsonData:Object):void
		{
			var skinVo:SkinVo;//皮肤 资源 vo
			for  (var resId:String  in jsonData)
			{
				skinVo=new SkinVo();
				skinVo.resId=int(resId);
				skinVo.iconId=jsonData[resId].iconId;
				skinVo.normalSkinId=jsonData[resId].normalSkin;
				skinVo.mountSkinId=jsonData[resId].mountSkin;
				skinVo.sitSkinId=jsonData[resId].sitSkin;
				skinVo.dropGoodsSkinId=jsonData[resId].dropGoodsSkinId;
				_dict[skinVo.resId]=skinVo;
			}
		}
		/**得到皮肤资源vo  resId为GoodsBasicVo的resId值
		 */		
		public function getSkinVo(resId:int):SkinVo
		{
			return _dict[resId];
		}
		
		
		
	}
}