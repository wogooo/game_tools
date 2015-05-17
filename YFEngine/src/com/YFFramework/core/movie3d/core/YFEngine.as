package com.YFFramework.core.movie3d.core
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicOffCenterLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFDispather;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import yf2d.core.ScenceProxy;
	import yf2d.core.YF2d;
	import yf2d.textures.TextureHelper;

	/**@author yefeng
	 *2013-3-17下午9:46:24
	 */
	public class YFEngine extends YFDispather
	{
		/**引擎初始化完成 
		 */		
		public static const CompleteInit:String="CompleteInit";
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var stage3DProxy : Stage3DProxy;
		
		private var _away3dView:View3D;
		private var _hoverController:HoverController;
		
		private var _bottom2d:YF2d;
		
		private var _top2d:YF2d;

		private var _stage:Stage;
		private var _root:DisplayObjectContainer;
		
		private static var _instance:YFEngine;
		
		/**SPrite3d坐标转化 中间量 
		 */ 
		private var _sprite3DPosition:Vector3D;
		public function YFEngine()
		{
			_sprite3DPosition=new Vector3D();
		}
		public static  function get Instance():YFEngine
		{
			if(_instance==null) _instance=new YFEngine();
			return _instance;
		}
		
//		public function getCamera3D():Camera3D
//		{
//			return _away3dView.camera;
//		}
		
		public function start(root:DisplayObjectContainer,stage:Stage):void
		{
			this._stage=stage;
			_root=root;
			initListeners();
			initProxies();
		}
		
		private function initListeners():void
		{
			ResizeManager.Instance.regFunc(resize);
		}
		
		
		/**
		 * Initialise the Stage3D proxies
		 */
		private function initProxies():void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(_stage);
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0xFFFFFF;
		}
		public function getRenderWidth():Number
		{
			return _away3dView.width;
		}
		public function getRenderHeight():Number
		{
			return  _away3dView.height;
		}
		private function resize():void
		{
			ScenceProxy.Instance.initScence(stage3DProxy.stage3D.x,stage3DProxy.stage3D.y,_stage.stageWidth,_stage.stageHeight);
			stage3DProxy.context3D.configureBackBuffer(_stage.stageWidth,_stage.stageHeight,4);
			var lens:OrthographicOffCenterLens=new OrthographicOffCenterLens(-Math.ceil(_stage.stageWidth / 2), Math.ceil(_stage.stageWidth / 2), -Math.ceil(_stage.stageHeight / 2), Math.ceil(_stage.stageHeight / 2));
			_away3dView.camera.lens=lens;
			//			camera.lens.far=15000;
			_away3dView.camera.lens.near=0.1;  ///0.1
			_away3dView.camera.lens.far = 30000; ///3000
			_away3dView.camera.z = -1000;

			_away3dView.width=_stage.stageWidth;
			_away3dView.height=_stage.stageHeight;
			
		}
		
		private function onContextCreated(event : Stage3DEvent) : void
		{
			initAway3D();
			initYF2d();
			initLayer();
			resize();
		}
		
		private function initLayer():void
		{
			Layer3DManager.BottomLayerRoot=_bottom2d.scence;
			Layer3DManager.TopLayerRoot=_top2d.scence;
			Layer3DManager.RoleLayerRoot=_away3dView.scene;
			dispatchEventWith(CompleteInit);
		}
		
		/**
		 * Initialise the Away3D views
		 */
		private function initAway3D() : void
		{
			// Create the first Away3D view which holds the cube objects.
			
			
			var lens:OrthographicOffCenterLens=new OrthographicOffCenterLens(-Math.ceil(_stage.stageWidth / 2), Math.ceil(_stage.stageWidth / 2), -Math.ceil(_stage.stageHeight / 2), Math.ceil(_stage.stageHeight / 2));
		
			var _scene:Scene3D = new Scene3D();
			var _camera:Camera3D = new Camera3D();
			_camera.lens=lens;
			//			camera.lens.far=15000;
			_camera.lens.near=0.1;  ///0.1
			_camera.lens.far = 30000; ///3000
			_camera.z = -1000;
			_away3dView = new View3D(_scene, _camera);
			_away3dView.antiAlias = 2;
			_away3dView.camera=_camera;   
			_away3dView.width=_stage.stageWidth;
			_away3dView.height=_stage.stageHeight;
			//			away3dView = new View3D();
			_away3dView.stage3DProxy = stage3DProxy;
			_away3dView.shareContext = true;
			
			_hoverController = new HoverController(_away3dView.camera, null, 180, 35, 1500);
			_root.addChild(_away3dView);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			_stage.addEventListener(Event.ENTER_FRAME,onUpdate);
			
		}
//		public function get cameraMatrix3D():Matrix3D
//		{
//			return _away3dView.camera.sceneTransform;
//		}
		
		private var moveCamera : Boolean;
		private var lastPanAngle : Number;
		private var lastTiltAngle : Number;
		private var lastMouseX : Number;
		private var lastMouseY : Number;

		private function onUpdate(e:Event):void
		{
		
			if (moveCamera)
			{
				_hoverController.panAngle = 0.3 * (_stage.mouseX - lastMouseX) + lastPanAngle;
				_hoverController.tiltAngle = 0.3 * (_stage.mouseY - lastMouseY) + lastTiltAngle;
			}

		}
			
		
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if(e.ctrlKey)
					{
							moveCamera = true;
							lastPanAngle = _hoverController.panAngle;
							lastTiltAngle = _hoverController.tiltAngle;
							lastMouseX = _stage.mouseX;
							lastMouseY = _stage.mouseY;
							trace("angle:",_hoverController.panAngle,_hoverController.tiltAngle,_hoverController.distance);
//							trace("_camera:",_camera.position,_camera.rotationX,_camera.rotationY,_camera.rotationZ);
					
					}
					
					break;
				case MouseEvent.MOUSE_UP:
					moveCamera=false
					break;
			}
		}
			
			
		public function getTiltAngle():Number
		{
			return _hoverController.tiltAngle;
		}
		

		/**
		 * Initialise the yf2d sprites 
		 */
		private function initYF2d() : void
		{
			// Create the Starling scene to add the checkerboard-background
			TextureHelper.Instance.initData(stage3DProxy.context3D);
			ScenceProxy.Instance.initScence(stage3DProxy.stage3D.x,stage3DProxy.stage3D.y,_stage.stageWidth,_stage.stageHeight);
			_bottom2d=new YF2d();
			_bottom2d.initData(stage3DProxy.stage3D,_stage.stageWidth,_stage.stageHeight);
			_top2d=new YF2d();
			_top2d.initData(stage3DProxy.stage3D,_stage.stageWidth,_stage.stageHeight);
		}
		/**
		 * The main rendering loop
		 */
		public function render() : void 
		{
			stage3DProxy.clear();
			////地面层特效 
			_bottom2d.render()			
			// Render the Away3D layer
			_away3dView.render();
			_top2d.render();

			stage3DProxy.present();
		}
		
		public function update():void
		{
			_hoverController.update();
		}
		/**
		 * flash坐标转化为模型的  3d 坐标    模型转化需要
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		public function flashToModel3d(px:Number,py:Number):Vector3D
		{
			return _away3dView.unproject(px,py,1);
		}
		/**
		 * @param pos   Mesh 的坐标 不是Sprite3d的坐标
		 * @return 
		 */		
		public function away3dToFlash(pos:Vector3D):Vector3D
		{
			return _away3dView.project(pos);
		}

		/**
		 * flash坐标转化为Sprite3D的  3d 坐标    技能 坐标转化需要
		 * height  sprite3d的高度
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		public function flashToSprite3d(px:Number,py:Number,height:Number):Vector3D
		{
			_sprite3DPosition.x=px-_stage.stageWidth*0.5;
			_sprite3DPosition.y=_stage.stageHeight*0.5-py;
//			_sprite3DPosition.z=0;
			return _sprite3DPosition;
		}
		
	}
}