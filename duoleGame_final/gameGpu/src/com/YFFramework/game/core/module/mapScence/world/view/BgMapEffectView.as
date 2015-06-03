package com.YFFramework.game.core.module.mapScence.world.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.UtilString;
	import com.YFFramework.core.utils.net.SWFData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.module.mapScence.manager.TransferPointManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.yf2d.view.avatar.BuildingEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.MovieClipBuilding;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingEffect2DViewEx;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/** 背景地图上面的特效背景  ,,传送点 暂时读取的是地图xx2d配置  不是 策划表 配置 
	 * 2012-7-20 下午7:10:57
	 *@author yefeng
	 */
	public class BgMapEffectView
	{
		protected var _totalDict:Array;

		/**特效高度
		 */
		protected static const EffectViewHeight:int=100;
		protected static const EffectViewWidth:int=100;

		/**特效范围矩阵的 y坐标偏移量
		 */
//		protected static const EffectViewY:int=20;
		/** 建筑特效在该范围内显示 不在该范围内进行移出显示列表
		 */
		protected var _checkedViewRect:Rectangle;
		
		protected var nameIndex:int;
		
		/**存储传送点 用于副本中 传送点的显示和隐藏
		 */		
		private var _transferArr:Array;
		/**传送点 显示 副本时候需要隐藏
		 */		
		public var transferVisible:Boolean;
		public function BgMapEffectView()
		{
			nameIndex=0;
			_transferArr=[];
			transferVisible=true;
			_totalDict=[];
			_checkedViewRect=new Rectangle(-EffectViewWidth,-EffectViewHeight);
			addEvents();
			resize();
		}
		private function addEvents():void
		{
			ResizeManager.Instance.regFunc(resize);
			//进入副本时候，控制传送点的显示和隐藏
			YFEventCenter.Instance.addEventListener(GlobalEvent.ExitAppearable,onTransferEvent);
		}
		/**传送点的显示和隐藏     副本控制 
		 */		
		private function onTransferEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.ExitAppearable: ///副本 中的传送点的显示和隐藏
					transferVisible=Boolean(e.param);
					for each(var transferView:ThingEffect2DViewEx in _transferArr)
					{
						transferView.visible=transferVisible;
					}
					break;
			}
		}
		protected function resize():void
		{
			_checkedViewRect.width=StageProxy.Instance.getWidth()+EffectViewWidth*2;
			_checkedViewRect.height=StageProxy.Instance.getHeight()+EffectViewHeight*2;
		}
		/**切换场景 释放前一个 场景资源
		 */		
		public function disposePreRes():void
		{
			if(_totalDict)disposeAllChildren();
			_transferArr=[];
			transferVisible=true;
//			_totalDict=new Dictionary();
			_totalDict=[];
		}
		
		/**
		 * @param xxObj   地图配置文件
		 */		
		public function initData(xxObj:Object):void
		{
			TransferPointManager.Instance.clear();
			/// 进行创建 建筑
			var buildObj:Object=xxObj.building;
			var buildData:Object;
			var building:BuildingEffect2DView;
			var url:String;
//			var mapId:int=DataCenter.Instance.mapSceneBasicVo.mapId;
			var exactName:String;
			var suffix:String;
			var swfBuiding:MovieClipBuilding;
			for(var name:String in buildObj)  ///建筑特效
			{
				suffix=UtilString.getSuffix(name);
				if(suffix=="swf")  //swf特效
				{
					exactName=UtilString.getExactName(name)+".swf";
					url=URLTool.getMapBuilding(exactName);
					for each (buildData in buildObj[name])
					{
						swfBuiding=MovieClipBuilding.getMovieClipBuilding(null,30);
						_totalDict.push(swfBuiding);
						swfBuiding.buldingUrl=url;
						swfBuiding.updateFunc=swfBuildingUpdatePos;
						swfBuiding.setMapXY(buildData.x,buildData.y);
						swfBuiding.scaleY=buildData.scaleY;
						swfBuiding.scaleX=buildData.scaleX;
						swfBuiding.rotation=buildData.rotation;
					}

				}
				else // atf特效
				{
					exactName=UtilString.getExactName(name)+".atfMovie";
					url=URLTool.getMapBuilding(exactName);
					for each (buildData in buildObj[name])
					{
						building=YF2dMovieClipPool.getBuildingEffect2DView();
						_totalDict.push(building);
						building.buldingUrl=url;
						building.callBack=buildingUpdatePos;
						building.setMapXY(buildData.x,buildData.y);
						building.scaleY=buildData.scaleY;
						building.rotationZ=buildData.rotation;
						if(buildData.scaleX<0)building.oppsiteX=-1;
						else building.oppsiteX=1;
						building.scaleX=Math.abs(buildData.scaleX);
					}
				}
			}
			
			var actionData:ATFActionData;
			//处理传送点  //// var skipArr:Array=xxObj.skip; //[{selfX,selfY,x,y,mapId,mapName}]  //selfX selfY 是传送点自己的坐标  x y mapId  mapName是另一个地图的信息
			var skipArr:Array=xxObj.skip;
			var transferView:ThingEffect2DViewEx;
			url=CommonEffectURLManager.TransferPtURL;
			actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			for each(var skipData:Object in skipArr)		///地图跳转点
			{
				transferView=new ThingEffect2DViewEx();
				transferView.callBack=transferUpdatePos;
				transferView.text=skipData.mapName;
				_totalDict.push(transferView);
				transferView.setMapXY(skipData.selfX,skipData.selfY);
				_transferArr.push(transferView);
				transferView.visible=transferVisible;
				TransferPointManager.Instance.put(skipData.selfX,skipData.selfY);
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
		/**加载建筑数据
		 */		
		private function loadBuildingData(building:BuildingEffect2DView):void
		{
			var mapId:int=DataCenter.Instance.getMapId();
			var actionData:ATFActionData=SourceCache.Instance.getRes2(building.buldingUrl,mapId) as ATFActionData;
			if(actionData)
			{
				building.initData(actionData);
				building.start();
				building.playDefault();
			}
			else 
			{
				SourceCache.Instance.addEventListener(building.buldingUrl,complete);
				SourceCache.Instance.loadRes(building.buldingUrl,{effectView:building,exsitFlag:mapId},mapId);
			}

		}
		
		
		private function loadSWFBuildingData(building:MovieClipBuilding):void
		{
			var mapId:int=DataCenter.Instance.getMapId();
			var swfData:SWFData=SourceCache.Instance.getRes2(building.buldingUrl,SourceCache.ExistAllScene) as SWFData;
			if(swfData)
			{
				var mc:MovieClip=swfData.getMovieClip();
				building.initMC(mc,30); 
				building.start(); 
				building.playDefault();
			}
			else 
			{
				SourceCache.Instance.addEventListener(building.buldingUrl,swfComplete);
				SourceCache.Instance.loadRes(building.buldingUrl,{effectView:building,exsitFlag:mapId},SourceCache.ExistAllScene,null,null,false,true);
			}
			
		}
		
		/**  更新特效坐标
		 */		
		private function buildingUpdatePos(building:BuildingEffect2DView):void
		{
			if(!building.isDispose)
			{
				if(_checkedViewRect.contains(building.x,building.y))
				{
					addEffectView(building);
					if(building.start())
					{
						building.playDefault();
					}
					if(!building.dataInit)
					{
						loadBuildingData(building);
						building.dataInit=true;
					}
				}
				else 
				{
					removeEffectView(building);
					building.stop();
				}
			}
		}
		
		/**  更新特效坐标
		 */		
		private function swfBuildingUpdatePos(building:MovieClipBuilding):void
		{
			if(!building.isDispose)
			{
				if(_checkedViewRect.contains(building.x,building.y))
				{
					addSWFEffectView(building);
					if(building.start())
					{
						building.playDefault();
					}
					if(!building.dataInit)
					{
						loadSWFBuildingData(building);
						building.dataInit=true;
					}
				}
				else 
				{
					removeSWFEffectView(building);
					building.stop();
				}
			}
		}
		
		/**传送 
		 */		
		private function transferUpdatePos(transferView:ThingEffect2DViewEx):void
		{
			if(!transferView.isDispose)
			{
				if(_checkedViewRect.contains(transferView.x,transferView.y))
				{
					addEffectView(transferView);
				}
				else  
				{
					removeEffectView(transferView);
				}
			}
		}

		
		
		
		private function swfComplete(e:YFEvent):void
		{
			var url:String=e.type;
			var data:Object=e.param;
			var effectView:MovieClipBuilding;
			var exsitFlag:Object;
			var swfData:SWFData=SourceCache.Instance.getRes(url) as SWFData;
			var mc:MovieClip
			for each (var obj:Object in data)
			{
				effectView=obj.effectView as MovieClipBuilding;
				exsitFlag=obj.exsitFlag;
				if(!effectView.isDispose) ///如果没有进行内存释放
				{
					mc=swfData.getMovieClip();
					effectView.initMC(mc,30);
					effectView.start();
					effectView.playDefault();
				}
			}
			SourceCache.Instance.removeEventListener(url,swfComplete);
			//			print(this,"资源"+url+"加载完成了");
		}

		/**
		 */
		private function complete(e:YFEvent):void
		{
			var url:String=e.type;
			var data:Object=e.param;
			var effectView:Object;
//			var exsitFlag:Object;
			var actionData:ATFActionData=SourceCache.Instance.getRes(url) as ATFActionData;
			for each (var obj:Object in data)
			{
				effectView=obj.effectView;
//				exsitFlag=obj.exsitFlag;
				if(!effectView.isDispose) ///如果没有进行内存释放
				{
					effectView.initData(actionData);
					effectView.start();
					effectView.playDefault();
				}
			}
			SourceCache.Instance.removeEventListener(url,complete);
//			print(this,"资源"+url+"加载完成了");
		}
		
		/**添加建筑
		 */
		private function addEffectView(view:DisplayObject2D):void
		{
			if(!LayerManager.BgEffectLayer.contains(view))LayerManager.BgEffectLayer.addChild(view);
		}
		
		private function removeEffectView(view:DisplayObject2D):void
		{
			if(LayerManager.BgEffectLayer.contains(view)) LayerManager.BgEffectLayer.removeChild(view);
		}
		
		
		private function addSWFEffectView(view:MovieClipBuilding):void
		{
			if(!LayerManager.flashEffectLayer.contains(view))LayerManager.flashEffectLayer.addChild(view);
		}
		
		private function removeSWFEffectView(view:MovieClipBuilding):void
		{
			if(LayerManager.flashEffectLayer.contains(view)) LayerManager.flashEffectLayer.removeChild(view);
		}

		
		private function disposeAllChildren():void
		{
			for each(var view:Object in _totalDict)
			{
				if(view is DisplayObject2D)
				{
					removeEffectView(DisplayObject2D(view));
					if(view is BuildingEffect2DView)  //建筑特效
					{
						YF2dMovieClipPool.toBuildingEffect2DViewPool(BuildingEffect2DView(view));
					}
					else view.dispose();
				}
				else if(view is MovieClipBuilding) //MovieClipBulding
				{
					removeSWFEffectView(MovieClipBuilding(view));
					MovieClipBuilding.toMovieClipPlayerPool(MovieClipBuilding(view));
				}
			}
		}
		
	}
}