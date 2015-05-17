package
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
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Vector3D;
	
	import yf2d.core.ScenceProxy;
	import yf2d.core.YF2d;
	import yf2d.textures.TextureHelper;

	/**@author yefeng
	 *2013-3-17下午9:46:24
	 */
	public class EngineInit extends YFDispather
	{
		/**引擎初始化完成 
		 */		
		public static const EngineInit:String="EngineInit";
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var stage3DProxy : Stage3DProxy;
		
		private var _away3dView:View3D;
		private var hoverController:HoverController;
		
		private var _bottom2d:YF2d;
		
		private var _top2d:YF2d;

		private var _stage:Stage;
		private var _root:DisplayObjectContainer;
		public function EngineInit(root:DisplayObjectContainer,stage:Stage)
		{
			this._stage=stage;
			_root=root;
		}
		
		public function start():void
		{
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
			stage3DProxy.color = 0x0;
		}
		private function resize():void
		{
			ScenceProxy.Instance.initScence(stage3DProxy.stage3D.x,stage3DProxy.stage3D.y,_stage.stageWidth,_stage.stageHeight);
			stage3DProxy.context3D.configureBackBuffer(_stage.stageWidth,_stage.stageHeight,4);
			var lens:OrthographicOffCenterLens=new OrthographicOffCenterLens(-Math.ceil(_stage.stageWidth / 2), Math.ceil(_stage.stageWidth / 2), -Math.ceil(_stage.stageHeight / 2), Math.ceil(_stage.stageHeight / 2));
			_away3dView.camera.lens=lens;
			_away3dView.width=_stage.stageWidth;
			_away3dView.height=_stage.stageHeight;
		}
		
		private function onContextCreated(event : Stage3DEvent) : void
		{
			initAway3D();
			resize();
			initYF2d();
			initLayer();
		}
		
		private function initLayer():void
		{
			LayerManager.BottomLayerRoot=_bottom2d.scence;
			LayerManager.TopLayerRoot=_top2d.scence;
			LayerManager.RoleLayerRoot=_away3dView.scene;
			dispatchEventWith(EngineInit);
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
			_away3dView.antiAlias = 0;
			_away3dView.camera=_camera;   
			_away3dView.width=_stage.stageWidth;
			_away3dView.height=_stage.stageHeight;
			//			away3dView = new View3D();
			_away3dView.stage3DProxy = stage3DProxy;
			_away3dView.shareContext = true;
			
			hoverController = new HoverController(_away3dView.camera, null, 90, 22, 1500);
			
			_root.addChild(_away3dView);
		}
		
		/**
		 * Initialise the yf2d sprites
		 */
		private function initYF2d() : void
		{
			// Create the Starling scene to add the checkerboard-background
			TextureHelper.Instance.initData(stage3DProxy.context3D);
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
			// Clear the Context3D object
			stage3DProxy.clear();
			////地面层特效 
			_bottom2d.render()			
			// Render the Away3D layer
			_away3dView.render();
			_top2d.render();
			stage3DProxy.present();
		}
		/**
		 * flash坐标转化为  3d 坐标
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		public function flashTo3d(px:Number,py:Number):Vector3D
		{
			return _away3dView.unproject(px,py,0.01);
		}
	}
}