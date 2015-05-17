package com.YFFramework.core.movie3d.core 
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**只load Mesh和骨骼数据数据 不创建贴图
	 * @author yefeng
	 *2013-3-17下午10:52:59
	 */
	public class Movie3dLoader
	{
		
		/**  骨骼数据 骨骼动画总控制器 
		 */ 
		private var _animator:SkeletonAnimator;
		///骨骼数据  类似 2d 的序列帧数据   也就是各个动作数据
		private var _animationSet:SkeletonAnimationSet;

		/**mesh数据 
		 */ 
		private var _mesh:Mesh;
		/** 该load传递的数据
		 */		
		private var _data:Object;
		
		/**加载完成触发
		 */ 
		public var loadCompleteCallBack:Function;
		/**进度回调
		 */		
		public var progressCallBack:Function;
		private var _request:URLRequest;
		public function Movie3dLoader()
		{
		}
		
		
		public function initData(url:String,data:Object=null):void
		{
			_data=data;
			_request=new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, parseAWD);
			loader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loader.load(_request);
			
		}
		private function loadProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null)progressCallBack(e,_data);
		}
		private function ioError(e:IOErrorEvent):void
		{
			var loader:URLLoader = e.target as URLLoader;
			print(this,"流错误，地址:"+_request.url);
		}
		private function parseAWD(e:Event):void
		{
			var loader:URLLoader = e.target as URLLoader;
			var loader3d:Loader3D = new Loader3D(false);
			loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete, false, 0, true);  ///AWD内部数据  骨骼数据 Mesh数据全部load 完成后触发
			loader3d.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, false, 0, true);
			loader3d.loadData(loader.data, null, null, new AWD2Parser());
			
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.removeEventListener(Event.COMPLETE, parseAWD);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioError);

		}
		
		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			
//			print(this,"event.asset.assetType:"+event.asset.assetType);
			
			if (event.asset.assetType == AssetType.SKELETON) { ///骨骼动画数据     类似 2d 的序列帧
				//create a new skeleton animation set
				_animationSet = new SkeletonAnimationSet(3);
				var skeleton:Skeleton=event.asset as Skeleton;
				//wrap our skeleton animation set in an animator object and add our sequence objects
				_animator = new SkeletonAnimator(_animationSet,skeleton , true);
				///打印骨骼里面的骨头信息 获取骨骼索引
//				skeleton.jointFromName(
					///保持当前动作  各个骨头的的矩阵位置    做 粒子绑定骨骼时 需要  获取矩阵  
				//粒子跟随骨骼移动粒子 	
//				_animator.globalPose
				for each (var skeletonJoint:SkeletonJoint in skeleton.joints)
				{
					print(this,"skeletonName:",skeletonJoint.name);
				}
				
			} 
			else if (event.asset.assetType == AssetType.ANIMATION_NODE)  /// 单个动作的 数据
			{  ///
				//add each animation node to the animation set
				var animationNode:SkeletonClipNode = event.asset as SkeletonClipNode;
				_animationSet.addAnimation(animationNode);
//				print(this,"name",animationNode.name);
//				var state:AnimationS
				

			} 
			else if (event.asset.assetType == AssetType.MESH) 
			{ ///mesh  网格
				
				_mesh = event.asset as Mesh;
//				_mesh.castsShadows=false;
			}
		}
		/**
		 * Check if all resource loaded
		 */
		private function onResourceComplete(e:LoaderEvent):void
		{
			var loader3d:Loader3D = e.target as Loader3D;
			loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_mesh.animator=_animator;
//			_mesh.scale(1);
			_animator.updatePosition=false;////此句话重要，表示不要更新位置 
			if(loadCompleteCallBack!=null)	loadCompleteCallBack(_mesh,_data);
			dispose();
		}
		
		private function dispose():void
		{
			_request=null;
			_animator=null;
			_animationSet=null;
			_mesh=null;
			_data=null;
			loadCompleteCallBack=null;
			progressCallBack=null;

		}

	}
}