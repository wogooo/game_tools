package com.YFFramework.core.world.mapScence.bgMapEffect
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.SourceCache;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.world.movie.thing.ThingEffectView;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/** 背景地图上面的特效背景
	 * 2012-7-20 下午7:10:57
	 *@author yefeng
	 */
	public class BgMapEffectView
	{
		protected var _totalDict:Dictionary;
		/**特效高度
		 */
		protected static const EffectViewHeight:int=200;
		/**特效范围矩阵的 y坐标偏移量
		 */
		protected static const EffectViewY:int=20;
		/** 建筑特效在该范围内显示 不在该范围内进行移出显示列表
		 */
		protected var _checkedViewRect:Rectangle;
		
		protected var nameIndex:int;
		public function BgMapEffectView()
		{
			nameIndex=0;
			_checkedViewRect=new Rectangle(0,-EffectViewY);
			ResizeManager.Instance.regFunc(resize);
			UpdateManager.Instance.frame60.regFunc(arangeEffectView);
			resize();
		}
		protected function resize():void
		{
			_checkedViewRect.width=StageProxy.Instance.stage.stageWidth;
			_checkedViewRect.height=StageProxy.Instance.stage.stageHeight+EffectViewHeight;
		}
				
		
		/**
		 * @param xxObj   地图配置文件
		 */		
		public function initData(xxObj:Object):void
		{
			if(_totalDict)disposeAllChildren();
			_totalDict=new Dictionary();
			/// 进行创建
			var buildObj:Object=xxObj.building;
			var buildData:Object;
			var building:ThingEffectView;
			var url:String;
			for(var name:String in buildObj)
			{
				for each (buildData in buildObj[name])
				{
					url=URLTool.getMapBuilding(name);
				//	building=new ThingEffectView();
					building=PoolCenter.Instance.getFromPool(ThingEffectView) as ThingEffectView;
					building.name=getSingleName();
					_totalDict[building.name]=building;
					building.setMapXY(buildData.x,buildData.y);
			//		addBuilding(building);
					if(SourceCache.Instance.getRes(url))
					{
						building.initData(SourceCache.Instance.getRes(url) as ActionData);
						building.start();
						building.playDefault();
					}
					else 
					{
						SourceCache.Instance.addEventListener(url,complete);
						SourceCache.Instance.loadRes(url,building);
					}
				}
			}
			
		}
		
		
		/**
		 */
		private function complete(e:ParamEvent):void
		{
			var url:String=e.type;
			var data:Object=e.param;
			for each (var building:ThingEffectView in data)
			{
				if(!building.isPool) ///如果没有进行内存释放
				{
					building.initData(SourceCache.Instance.getRes(url) as ActionData);
					building.start();
					building.playDefault();
				}
			}
			SourceCache.Instance.removeEventListener(url,complete);
//			print(this,"资源"+url+"加载完成了");
		}
		
		/**得到唯一名称
		 */
		private function getSingleName():String
		{
			var str:String="BgMapEffectView"+nameIndex;
			++nameIndex;
			return str;
		}
		
		
		/**添加建筑
		 */
		private function addBuilding(view:ThingEffectView):void
		{
			if(!LayerManager.BgEffectLayer.contains(view))LayerManager.BgEffectLayer.addChild(view);
		}
		
		private function removeBuilding(view:ThingEffectView):void
		{
			if(LayerManager.BgEffectLayer.contains(view)) LayerManager.BgEffectLayer.removeChild(view);
		}
		
		private function disposeAllChildren():void
		{
			for each (var effectView:ThingEffectView in _totalDict)
			{
				if(LayerManager.BgEffectLayer.contains(effectView)) LayerManager.BgEffectLayer.removeChild(effectView);
			//	effectView.dispose();
				PoolCenter.Instance.toPool(effectView);
			}
		}
		
		
		/** 管理建筑特效 只有字舞台范围内的特效才会被显示出来
		 */
		private function arangeEffectView():void
		{
			var len:int=LayerManager.BgEffectLayer.numChildren;
			var effectView:ThingEffectView;
			
			for each (effectView in _totalDict)
			{
				if(_checkedViewRect.contains(effectView.pivotX,effectView.pivotY))
				{
					 addBuilding(effectView);
				}
				else 
				{
					removeBuilding(effectView);
				}
			}
		}
		
		
	}
}