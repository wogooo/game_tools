package com.YFFramework.core.world.mapScence.bgMapEffect
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.movie.thing.ThingEffectView;
	import com.YFFramework.core.world.movie.thing.ThingEffectViewEx;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.display.DisplayObject;
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
			UpdateManager.Instance.frame61.regFunc(arangeEffectView);
			resize();
		}
		protected function resize():void
		{
			_checkedViewRect.width=StageProxy.Instance.stage.stageWidth;
			_checkedViewRect.height=StageProxy.Instance.stage.stageHeight+EffectViewHeight;
		}
		/**切换场景 释放前一个 场景资源
		 */		
		public function disposePreRes():void
		{
			if(_totalDict)disposeAllChildren();
		}
		
		/**
		 * @param xxObj   地图配置文件
		 */		
		public function initData(xxObj:Object):void
		{
		//	if(_totalDict)disposeAllChildren();
			_totalDict=new Dictionary();
			/// 进行创建 建筑
			var buildObj:Object=xxObj.building;
			var buildData:Object;
			var building:ThingEffectView;
			var url:String;
			var mapId:int=DataCenter.Instance.mapSceneBasicVo.mapId;
			var actionData:ActionData
			for(var name:String in buildObj)
			{
				url=URLTool.getMapBuilding(name);
				actionData=SourceCache.Instance.getRes2(url,mapId) as ActionData;
				for each (buildData in buildObj[name])
				{
					building=PoolCenter.Instance.getFromPool(ThingEffectView) as ThingEffectView;
					building.name=getSingleName();
					_totalDict[building.name]=building;
					building.setMapXY(buildData.x,buildData.y);
					if(actionData)
					{
						building.initData(actionData);
						building.start();
						building.playDefault();
					}
					else 
					{
						SourceCache.Instance.addEventListener(url,complete);
						SourceCache.Instance.loadRes(url,{effectView:building,exsitFlag:mapId},mapId);
					}
				}
			}
			
			///处理传送点  //// var skipArr:Array=xxObj.skip; //[{selfX,selfY,x,y,mapId,mapName}]  //selfX selfY 是传送点自己的坐标  x y mapId  mapName是另一个地图的信息
			var skipArr:Array=xxObj.skip;
			var transferView:ThingEffectViewEx;
			url=CommonEffectURLManager.TransferPtURL;
			actionData=SourceCache.Instance.getRes2(url) as ActionData;
			for each(var skipData:Object in skipArr)
			{
				transferView=PoolCenter.Instance.getFromPool(ThingEffectViewEx) as ThingEffectViewEx;
				transferView.text=skipData.mapName;
				transferView.name=getSingleName();
				_totalDict[transferView.name]=transferView;
				transferView.setMapXY(skipData.selfX,skipData.selfY);
				if(actionData)
				{
					transferView.initData(actionData);
					transferView.start();
					transferView.playDefault();
				}
				else
				{
					SourceCache.Instance.addEventListener(url,complete);
					SourceCache.Instance.loadRes(url,{effectView:transferView,exsitFlag:SourceCache.ExistAllScene});
				}
			}
			
		}
		
		
		/**
		 */
		private function complete(e:ParamEvent):void
		{
			var url:String=e.type;
			var data:Object=e.param;
			var effectView:Object;
			var exsitFlag:Object;
			for each (var obj:Object in data)
			{
				effectView=obj.effectView;
				exsitFlag=obj.exsitFlag;
				if(!effectView.isPool) ///如果没有进行内存释放
				{
					effectView.initData(SourceCache.Instance.getRes2(url,exsitFlag) as ActionData);
				//	building.initData(SourceCache.Instance.getRes(url) as ActionData);
					effectView.start();
					effectView.playDefault();
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
		private function addEffectView(view:DisplayObject):void
		{
			if(!LayerManager.BgEffectLayer.contains(view))LayerManager.BgEffectLayer.addChild(view);
		}
		
		private function removeEffectView(view:DisplayObject):void
		{
			if(LayerManager.BgEffectLayer.contains(view)) LayerManager.BgEffectLayer.removeChild(view);
		}
		
		private function disposeAllChildren():void
		{
			var child:DisplayObject;
			for each (var effectView:IPool in _totalDict)
			{
				child=effectView as DisplayObject;
				if(LayerManager.BgEffectLayer.contains(child)) LayerManager.BgEffectLayer.removeChild(child);
				PoolCenter.Instance.toPool(effectView);
			}
		}
		
		
		/** 管理建筑特效 只有字舞台范围内的特效才会被显示出来
		 */
		private function arangeEffectView():void
		{
			var len:int=LayerManager.BgEffectLayer.numChildren;
			var effectView:ThingEffectView;
			var tansferView:ThingEffectViewEx;
			for each (var display:DisplayObject in _totalDict)
			{
				effectView=display as ThingEffectView;
				tansferView= display as ThingEffectViewEx;
				if(effectView)  ///建筑特效
				{
					if(_checkedViewRect.contains(effectView.pivotX,effectView.pivotY))
					{
						addEffectView(effectView);
					}
					else 
					{
						removeEffectView(effectView);
					}
				}
				else  ////传送点
				{
					if(_checkedViewRect.contains(tansferView.x,tansferView.y))
					{
						addEffectView(tansferView);
					}
					else 
					{
						removeEffectView(tansferView);
					}
				}
			}
		}
		
		
	}
}