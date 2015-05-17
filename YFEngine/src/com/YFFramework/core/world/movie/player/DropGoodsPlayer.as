package com.YFFramework.core.world.movie.player
{
	/**物品掉落
	 * @author yefeng
	 *2012-10-30下午9:43:47
	 */
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.world.model.MonsterDyVo;
	
	public class DropGoodsPlayer extends NPCPlayer
	{
		public function DropGoodsPlayer(roleDyVo:MonsterDyVo=null)
		{
			super(roleDyVo);
		}
		
		override public function resetSkin():void
		{
			///设置默认物品皮肤
//			_cloth.setBitmapDataEx(CommonFla.DropGoodsFakeSkin);////设置  默认皮肤
			_cloth.setBitmapFrame(CommonFla.DropGoodsFakeSkin,CommonFla.DropGoodsFakeSkin.flashTexture,CommonFla.DropGoodsFakeSkin.atlasData);////设置  默认皮肤
			_cloth.initData(null);
			_cloth.playTweenStop();
		}
		
		override protected function initNameLayer():void
		{
			super.initNameLayer();
			_nameLayer.y=_cloth.y-20;
		}
		
		override protected function initShowdow():void
		{
			
		}

		

		
		
		
	}
}