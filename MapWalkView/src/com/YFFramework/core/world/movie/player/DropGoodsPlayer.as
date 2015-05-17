package com.YFFramework.core.world.movie.player
{
	/**物品掉落
	 * @author yefeng
	 *2012-10-30下午9:43:47
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.res.ResSimpleTexture;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	public class DropGoodsPlayer extends NPCPlayer
	{
		public function DropGoodsPlayer(roleDyVo:MonsterDyVo=null)
		{
			super(roleDyVo);
			addDropEffect();
		}
		
		override public function resetSkin():void
		{
			///设置默认物品皮肤
			initGoodsSkin(CommonFla.DropGoodsFakeSkin);
			_cloth.initData(null);
			_cloth.playTweenStop();
		}
		
		
		override protected function initNameLayer():void
		{
			super.initNameLayer();
			_nameLayer.y=_cloth.y-40;
			_nameLayer.x=-_nameLayer.width*0.5
		}
		override protected function initShowdow():void
		{
			
		}
		/**初始化皮肤
		 */		
		public function initGoodsSkin(resSimpleTexture:ResSimpleTexture):void
		{
			_cloth.setBitmapFrame(resSimpleTexture,resSimpleTexture.flashTexture,resSimpleTexture.atlasData);////设置  默认皮肤
		}

		private function addDropEffect(quality:int=1):void
		{
			var url:String=CommonEffectURLManager.DropGoodsEffectNormal;
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			if(actionData)
			{
				addFrontEffect(actionData,[0],true);
			}
			else 
			{
				SourceCache.Instance.addEventListener(url,dropEffectComplete);
				SourceCache.Instance.loadRes(url,this);
			}
			
		}
		private function dropEffectComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,dropEffectComplete);
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			var goodsVect:Vector.<Object>=e.param as Vector.<Object>;
			for each(var dropGoodsPlayer:DropGoodsPlayer in goodsVect)
			{
				dropGoodsPlayer.addFrontEffect(actionData,[0],true);
			}
		}
		
		override public function constructor(roleDyVo:Object):IPool
		{	
			super.constructor(roleDyVo);
			addDropEffect();
			return this;
		}

		
	}
}