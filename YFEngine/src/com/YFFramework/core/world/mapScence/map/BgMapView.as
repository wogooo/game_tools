package com.YFFramework.core.world.mapScence.map
{
	/**
	 * 只进行地图滚屏处理
	 * @author yefeng
	 *2012-4-22下午10:44:18
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.map.MapLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	import com.YFFramework.game.core.global.DataCenter;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import yf2d.display.DisplayObjectContainer2D;
	import yf2d.display.sprite2D.Map2D;
	import yf2d.textures.sprite2D.SimpleTexture2D;
	
	////超大地图  暂未实现
	public class BgMapView 
	{
		/**小图片的宽高
		 */		
		protected static const SliceWidth:int=256;
		protected static const SliceHeight:int=256;
		
		/**低像素图片的宽 高
		 */		
		protected static const MipMapWidth:int=512;
		
		protected static const MipMapHeight:int=512;
		
		/** 质量差的图片    
		 */
		private var  _lowBmp:Map2D;
		/**质量高的图片数组   保存已经加载进来的图片
		 */
		private var _highBmpDict:Dictionary;
		/**_保存舞台上的对象  _stageDict >=  _checkDict
		 */
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
		private var _indexStr:String;//数组索引字符串
		private var _loader:MapLoader;
		private var _picUrl:String;
		
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
			_lowBmp=new Map2D(0,0);  ////添加低像素 图片容器
			LayerManager.BgMapLayer.addChild(_lowBmp);
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
			LayerManager.BgMapLayer.x =data.bgMapX;
			LayerManager.BgMapLayer.y =data.bgMapY;
			var centerPt:Point=getCenterMapX(HeroProxy.x,HeroProxy.y,HeroProxy.mapX,HeroProxy.mapY);
			_centerMapX=centerPt.x;
			_centerMapY=centerPt.y;
			updateBgMap(); 
		}
		/** 场景切换 进入新场景
		 */		
		public function updateMapChange(vo:MapSceneBasicVo):void
		{
			enterMap(vo);
		}
		
		/** 进入地图   功能待完善
		 */
		private function enterMap(mapSceneBasicVo:MapSceneBasicVo):void
		{
			if(_lowBmp.atfBytes)
			{	
				_lowBmp.disposeATFBytes();
				_lowBmp.disposeFlashTexture();
			}
			removeAllHighPic();///释放所有的图切片
			this._mapSceneBasicVo=mapSceneBasicVo;
			_slicePicLen=Math.ceil((_mapSceneBasicVo.width/SliceWidth))*Math.ceil((_mapSceneBasicVo.height/SliceHeight));
			_loadedLen=0;
			loadThumbPic();
		}
		/** 加载低像素的小图片 
		 */
		private function loadThumbPic():void
		{
			var url:String=URLTool.getMapLowImage(_mapSceneBasicVo.resId);
			var mapId:int=DataCenter.Instance.mapSceneBasicVo.mapId;
			SourceCache.Instance.addEventListener(url,thumbLoadComplete);
			SourceCache.Instance.loadRes(url,mapId,mapId);
		}
		
		
		/**  移除并释放所有的高质量图片
		 */
		private  function removeAllHighPic():void
		{
			for each (var tileMap:TileView in _highBmpDict)
			{
				if(LayerManager.BgMapLayer.contains(tileMap)) LayerManager.BgMapLayer.removeChild(tileMap);
			//	tileMap.dispose();
				//tileMap=null;
				tileMap.dispose(true);
			}
			
			_highBmpDict=new Dictionary();
			_stageDict=new Dictionary();
			_checkDict=new Dictionary();
			_loadDict=new Dictionary(); 
				

		}
		
		private function thumbLoadComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			var mapId:int=int(Vector.<Object>(e.param)[0]);
			var atfBytes:ByteArray=SourceCache.Instance.getRes2(url,mapId) as ByteArray;
			_lowBmp.atfBytes=atfBytes;
			/// createm  rect
			var texture2D:SimpleTexture2D=new SimpleTexture2D();
			texture2D.setTextureRect(0,0,MipMapWidth,MipMapHeight);
			_lowBmp.setTextureData(texture2D);
			/// create flash Texture
			_lowBmp.createFlashTexture();
			_lowBmp.pivotX=-_lowBmp.width*0.5;
			_lowBmp.pivotY=-_lowBmp.height*0.5;
			////对低像素图片进行缩放
			_lowBmp.scaleX=_mapSceneBasicVo.width/MipMapWidth;
			_lowBmp.scaleY=_mapSceneBasicVo.width/MipMapHeight;
			
			SourceCache.Instance.removeEventListener(url,thumbLoadComplete);
			if(!LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.addChildAt(_lowBmp,0);
			atfBytes=null;
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
			_leftMapX=_centerMapX-StageProxy.Instance.stage.stageWidth*0.5;
			_rightMapX=_centerMapX+StageProxy.Instance.stage.stageWidth*0.5;
			_topMapY=_centerMapY-StageProxy.Instance.stage.stageHeight*0.5;
			_bottomMapY=_centerMapY+StageProxy.Instance.stage.stageHeight*0.5;
			///得到 各个方向的索引值
			_leftIndex=int(_leftMapX/SliceWidth);/// x 方向最小
			_rightIndex=int(_rightMapX/SliceWidth);  // x 方向最大
			_topIndex=int(_topMapY/SliceHeight);/// y方向最小
			_bottomIndex=int(_bottomMapY/SliceHeight);//  y方向最大
			_maxXIndex=Math.ceil(_mapSceneBasicVo.width/SliceWidth)-1;
			_maxYIndex=Math.ceil(_mapSceneBasicVo.height/SliceHeight)-1;
			_rightIndex=_rightIndex>_maxXIndex?_maxXIndex:_rightIndex;
			_bottomIndex=_bottomIndex>_maxYIndex?_maxYIndex:_bottomIndex;
			
			/// 开始 加载这个范围内的 图片
//			indexStr:String;//数组索引字符串
//			loader:UILoader;
//			picUrl:String;
			_checkDict=new Dictionary(); 
			
			//是否有需要加载的图片 有的话则显示低像素图片，没有的话则显示高像素的图片
		//	var isLoad:Boolean=false;
			for(var i:int=_leftIndex;i<=_rightIndex;++i)  /// x  方向
			{
				for(var j:int=_topIndex;j<=_bottomIndex;++j)  ///  y 方向
				{
					_indexStr=getDictStr(i,j);
					if(_highBmpDict[_indexStr])
					{  ///当该照片存在
						if(!LayerManager.BgMapLayer.contains(_highBmpDict[_indexStr]))
						{
							LayerManager.BgMapLayer.addChild(_highBmpDict[_indexStr]);
							TileView(_highBmpDict[_indexStr]).createFlashTexture();////创建flash材质
							
							_highBmpDict[_indexStr].x=i*SliceWidth+SliceWidth*0.5;  ////这里要注意    stage3d需要加上 半宽  半高----------------------------------------------
							_highBmpDict[_indexStr].y=j*SliceHeight+SliceHeight*0.5;
							//丢进舞台数组
							_stageDict[_indexStr]=_highBmpDict[_indexStr];
						}///丢进当前舞台检测数组
						_checkDict[_indexStr]=_highBmpDict[_indexStr];
					}
					else if(!_loadDict[_indexStr])///加载该图片          /// i  - j 索引 对应的图片名称  i_j
					{
					//	isLoad=true;
						_loadDict[_indexStr]=true;
						_picUrl=URLTool.getMapSliceImage(_mapSceneBasicVo.resId,j,i);
						_loader=new MapLoader();
						_loader.loadCompleteCallBack=hignPicLoadCallback;
						_loader.load(_picUrl,{x:i*SliceWidth+SliceWidth*0.5,y:j*SliceHeight+SliceHeight*0.5,indexStr:_indexStr});
					}
				}
			}
			
			//剔除不应该存在于舞台上的对象  
			cleanBgMap();
//			if(isLoad)
//			{	//有加载的图片 显示低像素图片 
//				if(!LayerManager.BgMapLayer.contains(_lowBmp))	LayerManager.BgMapLayer.addChild(_lowBmp);
//			}
//			else 
//			{	///没有加载的图片  移除低像素图片
//				if(LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.removeChild(_lowBmp);
//			}
		}
		
		private function hignPicLoadCallback(bytes:ByteArray,data:Object):void
		{
			var tileMap:TileView=new TileView();
			tileMap.atfBytes=bytes;
			var texture2D:SimpleTexture2D=new SimpleTexture2D();
			texture2D.setTextureRect(0,0,SliceWidth,SliceHeight);
			tileMap.setTextureData(texture2D);
			/// create flash Texture
			tileMap.createFlashTexture();
			_highBmpContainer.addChild(tileMap);
			tileMap.x=data.x;
			tileMap.y=data.y;
			_highBmpDict[data.indexStr]=tileMap;
			_stageDict[data.indexStr]=_highBmpDict[data.indexStr];
			_loadDict[data.indexStr]=null;
			delete _loadDict[data.indexStr];
			++_loadedLen;
			if(_loadedLen==_slicePicLen) 
			{
				if(LayerManager.BgMapLayer.contains(_lowBmp))LayerManager.BgMapLayer.removeChild(_lowBmp);
			}
			
		}
		
		/** 处理舞台上图片个数 使其处于最少状态 
		 */
		private function  cleanBgMap():void
		{
			var map:TileView;
			for (var str:String in _stageDict)
			{
				//当checkstr不存在 则将其移除去
				if(!_checkDict[str])
				{	
					map=_stageDict[str];
					if(LayerManager.BgMapLayer.contains(map))
						LayerManager.BgMapLayer.removeChild(map);
					map.disposeFlashTexture();
					delete _stageDict[str]
				}
			}
		}
		
		/**  返回索引对应的字典数组属性名称
		 */
		private function getDictStr(xIndex:int,yIndex:int):String
		{
			return xIndex+"_"+yIndex;
		}
		
		
		
		
	}
}