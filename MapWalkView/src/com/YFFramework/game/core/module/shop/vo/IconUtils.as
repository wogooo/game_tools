package com.YFFramework.game.core.module.shop.vo
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;

	public class IconUtils
	{
		
		public static function getIconURL(vo:ShopBasicVo):String
		{
			var url:String = "";
			if(vo.item_type == 1){
				try{
					url = EquipBasicManager.Instance.getURL(vo.item_id);
				} 
				catch(error:Error) {
					
				}
			}else{
				try{
					url = PropsBasicManager.Instance.getURL(vo.item_id);
				} 
				catch(error:Error) {
					
				}
			}
			return url;
		}
		
	}
}