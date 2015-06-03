package com.YFFramework.game.core.module.mapScence.world.view
{
	/**
	 * 只进行地图滚屏处理
	 * @author yefeng
	 *2012-4-22下午10:44:18
	 */ 
	import com.YFFramework.core.FlashConfig;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.loader.map.MapLoader;
	import com.YFFramework.core.net.loader.map.MapLoaderQueen;
	import com.YFFramework.core.net.loader.map.TileMapLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.core.world.mapScence.map.TileView;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.display.sprite2D.LowMap;
	import com.YFFramework.core.yf2d.display.sprite2D.LowMapData;
	import com.YFFramework.core.yf2d.textures.sprite2D.SimpleTexture2D;
	import com.YFFramework.core.yf2d.utils.getTwoPower;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.view.player.CameraProxy;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	////超大地图  暂未实现
	public class BgMapView 
	{
		/**小图片的宽高
		 */		
		protected static const SliceWidth:int=256;
		protected static const SliceHeight:int=256;
		
		protected static const SliceWidth_Half:int=SliceWidth*0.5;
		protected static const SliceHeight_Half:int=SliceHeight*0.5;
		
		/**释放材质宽度
		 */
		protected static const SceneWidth_Half:int=1500;
		/**释放材质高度
		 */
		protected static const SceneHeight_Half:int=750;

		protected static const Left:int=-SliceWidth_Half-SceneWidth_Half;
		
		protected static const Right:int=SliceWidth_Half+SceneWidth_Half;
		
		/**上层
		 */
		protected static const Top:int=-SliceHeight-SceneHeight_Half;
		/**底部 
		 */		
		protected static const Bottom:int=SliceHeight+SceneHeight_Half;



		/** 质量差的图片    
		 */
		private var  _lowBmp:LowMap;
		/**质量高的图片数组   保存已经加载进来的图片
		 */
//		private var _highBmpDict:Dictionary;
		private var _highBmpDict:Array;
		/**_保存舞台上的对象  _stageDict >=  _checkDict
		 */
//		private var _stageDict:Dictionary;
		private var _stageDict:Dictionary;
	
		
		/** _checkDict返回的当前在舞台上应该显示的图片数组 检测数组 检测当前在舞台上的对象 和  _stageDict进行对比 剔除不应该在舞台上的对象   _checkDict内的对象始终只保存当前舞台上显示的对象
		 */
		private var _checkDict:Dictionary;
		/**处于加载状态的图片数组
		 */
		private var _loadDict:Dictionary;
		/**网格数据 待加上来
		 */
		private var gridData:Object;
		private var _mapSceneBasicVo:MapSceneBasicVo;
		/**窗口中央点在地图上的坐标
		 */		
		private var _centerMapX:int;
		/** 窗口中央点 在地图上的坐标位置
		 */
		private var _centerMapY:int;
		
		
		/**切片个数 
		 */
		private var _slicePicLen:int;
		/**列数
		 */		
		private var _column:int;
		/**行数
		 */		
		private var _row:int;
		
		/**已经下载了的图片数
		 */
		private var _loadedLen:int;

		/// 图像进行更新   updateBgMap  执行所需要的临时变量
		private var _leftMapX:int;
		private var _rightMapX:int;
		private var _topMapY:int;
		private var _bottomMapY:int;
		///得到 各个方向的索引值
		private var _leftIndex:int;/// x 方向最小
		private var _rightIndex:int; // x 方向最大
		private var _topIndex:int;/// y方向最小
		private var _bottomIndex:int;//  y方向最大
		private var _maxXIndex:int;
		private var _maxYIndex:int;
		
		/// 开始 加载这个范围内的 图片
//		private var _indexStr:String;//数组索引字符串
		private var _index:int;
		
		/**用于atf地图的加载
		 */
		private var _loader:MapLoader;  //用于atf地图的加载
		private var _loaderQueen:MapLoaderQueen;
		/**   常规bitmapData 地图的加载
		 */		
//		private var _tileMapLoader:TileMapLoader;
		
		private var _picUrl:String;
		
		private var _mapId:int;
		/** 高像素图片容器 
		 */	
		private var _highBmpContainer:DisplayObjectContainer2D;
		public function BgMapView()
		{
			initUI();
			addEvents();
		}
		private function initUI():void
		{
			_loaderQueen=MapLoaderQueen.Instance//new MapLoaderQueen();
			_lowBmp=new LowMap();  ////添加低像素 图片容器
			LayerManager.BgMapLayer.addChildAt(_lowBmp,0);
			_highBmpContainer=new DisplayObjectContainer2D();
			LayerManager.BgMapLayer.addChild(_highBmpContainer); 
		}
		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMove,onMapScenceEvent);
		}
		
		private function onMapScenceEvent(e:YFEvent):void
		{
			var data:Object=e.param;
			///场景地图移动
//			LayerManager.BgMapLayer.x =data.bgMapX;
//			LayerManager.BgMapLayer.y =data.bgMapY;
			LayerManager.BgMapLayer.setXY(data.bgMapX,data.bgMapY);
			var centerPt:Point=getCenterMapX(CameraProxy.Instance.x,CameraProxy.Instance.y,CameraProxy.Instance.mapX,CameraProxy.Instance.mapY);
			_centerMapX=centerPt.x;
			_centerMapY=centerPt.y;
//			var t:Number=getTimer();
			updateBgMap(); 
			
//			trace("map::",getTimer()-t);
		}
		
		/**消除地图跳转bug 
		 */		
		public function updateResizeForBug():void
		{
			LayerManager.BgMapLayer.setXY(LayerManager.BgMapLayer.x,LayerManager.BgMapLayer.y);
			var centerPt:Point=getCenterMapX(CameraProxy.Instance.x,CameraProxy.Instance.y,CameraProxy.Instance.mapX,CameraProxy.Instance.mapY);
			_centerMapX=centerPt.x;
			_centerMapY=centerPt.y;
			updateBgMap(); 
		}
		/** 场景切换 进入新场景
		 */		
		public function updateMapChange(mapSceneBasicVo:MapSceneBasicVo):void
		{
			_loaderQueen.reset();
			_lowBmp.disposeAllData();
			removeAllHighPic();///释放所有的图切片
			this._mapSceneBasicVo=mapSceneBasicVo;
			_column=Math.ceil((_mapSceneBasicVo.width/SliceWidth));
			_row=Math.ceil((_mapSceneBasicVo.height/SliceHeight));
//			_slicePicLen=Math.ceil((_mapSceneBasicVo.width/SliceWidth))*Math.ceil((_mapSceneBasicVo.height/SliceHeight));
			_slicePicLen=_column*_row;
			_maxXIndex=Math.ceil(_mapSceneBasicVo.width/SliceWidth)-1;
			_maxYIndex=Math.ceil(_mapSceneBasicVo.height/SliceHeight)-1;
			_loadedLen=0;
			_mapId=DataCenter.Instance.getMapId();
			loadThumbPic();

		}
		/** 加载低像素的小图片 
		 */
		private function loadThumbPic():void
		{
			var url:String=URLTool.getLowMapImage(_mapSceneBasicVo.resId);
			var mapId:int=DataCenter.Instance.mapSceneBasicVo.mapId;
			
			var loader:MapLoader=new MapLoader();
			loader.loadCompleteCallBack=thumbLoadComplete;
			loader.load(url,mapId);
		}
		
		private function thumbLoadComplete(bytes:ByteArray,mapId:int):void
		{
			if(mapId==DataCenter.Instance.getMapId())
			{
				_lowBmp.atfBytes=bytes;
				var w:int=DataCenter.Instance.mapSceneBasicVo.width*0.1;
				var h:int=DataCenter.Instance.mapSceneBasicVo.height*0.1;
				_lowBmp.renderWidth=getTwoPower(w);
				_lowBmp.renderHeight=getTwoPower(h);
				var u:Number=w/_lowBmp.renderWidth;
				var v:Number=h/_lowBmp.renderHeight;
				var texture2D:SimpleTexture2D=new SimpleTexture2D();
				texture2D.setTextureRect(0,0,w,h); 
				texture2D.setUVData(Vector.<Number>([0,0,u,v]));
				_lowBmp.setTextureData(texture2D);
				_lowBmp.createFlashTexture();//创建材质
				_lowBmp.pivotX=-w*0.5; 
				_lowBmp.pivotY=-h*0.5;
				_lowBmp.scaleX=10; 
				_lowBmp.scaleY=10;
				if(!LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.addChildAt(_lowBmp,0);
			}
		}
		
		/**  移除并释放所有的高质量图片
		 */
		private  function removeAllHighPic():void
		{
			
			for each (var tileMap:TileView in _highBmpDict)
			{
				if(_highBmpContainer.contains(tileMap)) _highBmpContainer.removeChild(tileMap);
//				tileMap.dispose(true);
				TileView.toTileViewPool(tileMap);
			}
			
//			_highBmpDict=new Dictionary();
			_highBmpDict=[];
			_stageDict=new Dictionary();
			_loadDict=new Dictionary(); 
				

		}
		
		
	
		
		
		/**得到舞台中央点在地图上的坐标位置
		 */
		private function getCenterMapX(heroX:int,heroY:int,heroMapX:int,heroMapY:int):Point
		{
			///地图上的 mapX mapY坐标
			var centerMapPt:Point=new Point();
			centerMapPt.x=heroMapX-heroX+StageProxy.Instance.stage.stageWidth*0.5;
			centerMapPt.y=heroMapY-heroY+StageProxy.Instance.stage.stageHeight*0.5;
			return centerMapPt;
		}
		
		/** 优化更新背景地图  下载 小地图  以及显示与删除小地图
		 */
		private function updateBgMap():void
		{

			///进行定位 
			_leftMapX=_centerMapX-StageProxy.Instance.getWidth()*0.5;
			_rightMapX=_centerMapX+StageProxy.Instance.getWidth()*0.5;
			_topMapY=_centerMapY-StageProxy.Instance.getHeight()*0.5;
			_bottomMapY=_centerMapY+StageProxy.Instance.getHeight()*0.5;
			///得到 各个方向的索引值
			_leftIndex=int((_leftMapX/SliceWidth)-0.5);/// x 方向最小   // +0.5的offset去进行扩展
			_rightIndex=int((_rightMapX/SliceWidth)+0.5);  // x 方向最大
			_topIndex=int((_topMapY/SliceHeight)-0.5);/// y方向最小
			_bottomIndex=int((_bottomMapY/SliceHeight)+0.5);//  y方向最大
			_rightIndex=_rightIndex>_maxXIndex?_maxXIndex:_rightIndex;;
			_bottomIndex=_bottomIndex>_maxYIndex?_maxYIndex:_bottomIndex;
			 
			_checkDict=new Dictionary();   //优化去掉
			
			for(var i:int=_leftIndex;i<=_rightIndex;++i)  /// x  方向
			{
				for(var j:int=_topIndex;j<=_bottomIndex;++j)  ///  y 方向
				{
					
					_index=j*_column+i;
					if(_highBmpDict[_index])
					{  ///当该照片存在
						if(!_highBmpContainer.contains(_highBmpDict[_index]))
						{
							_highBmpContainer.addChild(_highBmpDict[_index]);
							_highBmpDict[_index].setXY(i*SliceWidth+SliceWidth*0.5,j*SliceHeight+SliceHeight*0.5);
							//丢进舞台数组
							_stageDict[_index]=_highBmpDict[_index];
						}///丢进当前舞台检测数组
						_checkDict[_index]=_highBmpDict[_index];
						_highBmpDict[_index].reCreateTexture();//检测是否需要重新创建材质
					}
					else if(!_loadDict[_index])///加载该图片          /// i  - j 索引 对应的图片名称  i_j
					{
						_loadDict[_index]=true;
//						if(FlashConfig.Instance.canUseATf())  //高版本 使用atf文件
//						{
							_picUrl=URLTool.getMapSliceImage(_mapSceneBasicVo.resId,j,i);
							_loader=new MapLoader();
//							_loader.loadCompleteCallBack=hignPicLoadCallback;
//							_loader.load(_picUrl,{x:i*SliceWidth+SliceWidth*0.5,y:j*SliceHeight+SliceHeight*0.5,index:_index,mapId:_mapId});
							_loaderQueen.addLoader(_loader,_picUrl,{x:i*SliceWidth+SliceWidth*0.5,y:j*SliceHeight+SliceHeight*0.5,index:_index,mapId:_mapId},hignPicLoadCallback);
//							return ;///  每帧 只处理一次加载
//						} 
//						else   //低版本的flash 使用常规图片
//						{
//							_picUrl=URLTool.getMapSliceImageBitmap(_mapSceneBasicVo.resId,j,i);
//							_tileMapLoader=new TileMapLoader();
//							_loader.loadCompleteCallBack=hignPicLoadCallback2;
//							_loader.load(_picUrl,{x:i*SliceWidth+SliceWidth*0.5,y:j*SliceHeight+SliceHeight*0.5,index:_index,mapId:_mapId});
//						}
					}
				}
//				if(getTimer()-t>=3&&getTimer()-_preTime<=30)
//				{
//					_preTime=getTimer();
//					return ;	
//				}
			}
			
			//剔除不应该存在于舞台上的对象  
			cleanBgMap(); 
		}
		
		/** atf地图加载
		 */
		private function hignPicLoadCallback(bytes:ByteArray,data:Object):void
		{
			var mapId:int=data.mapId;
			if(mapId==_mapId) //当前场景加载的图片 
			{
				var tileMap:TileView=TileView.getTileView(containsMap);
				tileMap.atfBytes=bytes;
				var texture2D:SimpleTexture2D=new SimpleTexture2D();
				texture2D.setTextureRect(0,0,SliceWidth,SliceHeight);
				tileMap.setTextureData(texture2D);
				/// create flash Texture
				tileMap.createFlashTexture();
				tileMap.setXY(data.x,data.y);
				_highBmpContainer.addChild(tileMap);
				_highBmpDict[data.index]=tileMap;
				_stageDict[data.index]=_highBmpDict[data.index];
				_loadDict[data.index]=null;  
				delete _loadDict[data.index];
				++_loadedLen; 
//				if(_loadedLen==_slicePicLen) 
//				{
//					if(LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.removeChild(_lowBmp);
//				}	
			}
		}
		
		/**
		 * @param tileView   tileView是否在当前场景上显示 材质释放后 重新创建材质时候需要
		 */
		private function containsMap(tileView:TileView):Boolean
		{
			var worldX:Number=tileView.x+LayerManager.BgMapLayer.x+LayerManager.YF2dContainer.x;
			var worldY:Number=tileView.y+LayerManager.BgMapLayer.y+LayerManager.YF2dContainer.y;
			if(worldX>-SliceWidth_Half&&worldX<StageProxy.Instance.getWidth()+SliceWidth_Half&&worldY>-SliceHeight_Half&&worldY<StageProxy.Instance.getHeight()+SliceHeight_Half)
			{
				return true;  //创建材质
			}
//			else
//			if(worldX>Left&&worldX<StageProxy.Instance.getWidth()+Right&&worldY>Top&&worldY<StageProxy.Instance.getHeight()+Bottom)
//			{
//				return true;  //不做任何处理
//			}
			return false;  //释放地图材质 
		} 
		
		
		/**低版本 flash 地图加载
		 */
//		private function hignPicLoadCallback2(bitmapData:BitmapData,data:Object):void
//		{
//			var mapId:int=data.mapId;
//			if(mapId==_mapId) //当前场景加载的图片 
//			{
//				var tileMap:TileView=TileView.getTileView();
//				tileMap.setAtlas(bitmapData);
//				var texture2D:SimpleTexture2D=new SimpleTexture2D();
//				texture2D.setTextureRect(0,0,SliceWidth,SliceHeight);
//				tileMap.setTextureData(texture2D);
//				/// create flash Texture
//				tileMap.createFlashTexture();
//				tileMap.setXY(data.x,data.y);
//				_highBmpContainer.addChild(tileMap);
//				_highBmpDict[data.index]=tileMap;
//				_stageDict[data.index]=_highBmpDict[data.index];
//				_loadDict[data.index]=null;
//				delete _loadDict[data.index];
//				++_loadedLen; 
//				if(_loadedLen==_slicePicLen) 
//				{
//					if(LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.removeChild(_lowBmp);
//				}	
//			}
//		}
		
		
//		private var _cleanIndex:int=0;
//		private static const CleanLen:int=50;
		 
		/** 处理舞台上图片个数 使其处于最少状态 
		 */
		private function  cleanBgMap():void
		{
//			var t:Number=getTimer();
//			_cleanIndex++;
//			if(_cleanIndex>=CleanLen)
//			{
				for (var str:String in _stageDict)
				{
					//当checkstr不存在 则将其移除去
					if(!_checkDict[str])
					{	
						_highBmpContainer.removeChild(_stageDict[str]);
						delete _stageDict[str]
					}
				}
//				_cleanIndex=0;
//			}
//			trace("bgView:",getTimer()-t);
		}
		
		
		
	}
}