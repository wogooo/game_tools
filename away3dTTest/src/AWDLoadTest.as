package
{
	import away3d.animators.*;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicOffCenterLens;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.core.render.DefaultRenderer;
	import away3d.core.render.DepthRenderer;
	import away3d.core.render.PositionRenderer;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.events.*;
	import away3d.library.*;
	import away3d.library.assets.*;
	import away3d.lights.*;
	import away3d.loaders.misc.*;
	import away3d.loaders.parsers.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.primitives.*;
	import away3d.utils.Cast;
	
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#FFFFFF",frameRate="30", quality="LOW",width="1000",height="800")]
	public class AWDLoadTest extends Sprite
	{
		public static var SignatureSwf:Class;
		
		
		//ogre diffuse texture
		[Embed(source="ogre/ogre_diffuse.jpg")]
		public static var OgreDiffuse:Class;
		
		//ogre normal map texture
		[Embed(source="ogre/ogre_normals.png")]
		public static var OgreNormals:Class;
		
		//ogre specular map texture
		[Embed(source="ogre/ogre_specular.jpg")]
		public static var OgreSpecular:Class;
		
		//solider ant model
		[Embed(source="ogre/ogre.md2",mimeType="application/octet-stream")]
		public static var OgreModel:Class;
		
		//pre-cached names of the states we want to use
		public static var stateNames:Array = ["stand", "sniffsniff", "deathc", "attack", "crattack", "run", "paina", "cwalk", "crpain", "cstand", "deathb", "salute_alt", "painc", "painb", "flip", "jump"];
		
		//engine variables
		private var _view : View3D;
		private var _scene : Scene3D;
		private var _camera : Camera3D;
		private var _hoverCtrl : HoverController;
		
		private var moveCamera : Boolean;
		private var lastPanAngle : Number;
		private var lastTiltAngle : Number;
		private var lastMouseX : Number;
		private var lastMouseY : Number;
		
		//scene objects
		private var _floor:Mesh;
		private var _hero:Mesh;
		
		//navigation variables
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _animationSet:VertexAnimationSet;
		
		/**
		 * Constructor
		 */
		public function AWDLoadTest()
		{
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			initEngine();
			//add listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			
			loadModel();
		}
		
		private function loadModel():void
		{
			var url:String="onkba/onkba.awd"
			url="onkba/PolarBear.awd"
			
			AssetLibrary.enableParser(AWD2Parser);
			var loader:Movie3dLoader=new Movie3dLoader();
			loader.loadCompleteCallBack=movie3dComplete;
			loader.initData(url);
		}
		
		private function movie3dComplete(mesh:Mesh,data:Object):void
		{
			_hero=mesh;
			_hero.material=new ColorMaterial(0xFFFF00);
//			LayerManager.RoleLayerRoot.addChild(_hero);
			_view.scene.addChild(_hero);
			play();
			updatePos();
		}
		
		
		private function play(acion:String="Breathe"):void
		{
			var transition:CrossfadeTransition = new CrossfadeTransition(0.5);
			
			SkeletonAnimator(_hero.animator).play(acion);
		}
		
		
		private function initEngine():void
		{
			var lens:OrthographicOffCenterLens=new OrthographicOffCenterLens(-Math.ceil(stage.stageWidth / 2), Math.ceil(stage.stageWidth / 2), -Math.ceil(stage.stageHeight / 2), Math.ceil(stage.stageHeight / 2));
			
			_scene = new Scene3D();
			_camera = new Camera3D();
			
			_camera.lens=lens;
			//			camera.lens.far=15000;
			_camera.lens.near=0.1;  ///0.1
			_camera.lens.far = 30000; ///3000
			_camera.z = -1000;
			_view = new View3D(_scene, _camera);
			_view.antiAlias = 2;
			
			_view.camera=_camera;
			addChild(_view);
			
			_hoverCtrl = new HoverController(_camera, null, 180, 22, 1500);
			
			//			_hoverCtrl.panAngle =-518
			//			_hoverCtrl.tiltAngle=-51;
		}
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (moveCamera)
			{
				_hoverCtrl.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				_hoverCtrl.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			_view.render();
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			//			moveCamera = true;
			lastPanAngle = _hoverCtrl.panAngle;
			lastTiltAngle = _hoverCtrl.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			//	updatePos();
			trace("angle:",_hoverCtrl.panAngle,_hoverCtrl.tiltAngle);
			//			_mesh.rotationY +=10
			
			if (e.ctrlKey)//按住ctrl，点击舞台，定位黄色方块
			{
				var cube : Mesh = new Mesh(new CubeGeometry(2, 2, 2, 1, 1, 1, false), new ColorMaterial(0xFFFF00));
				_scene.addChild(cube);
				//	cube.position = getScreenTo3DPosition(_view, e.stageX, e.stageY, 0);//将舞台坐标，转为away3d坐标，d是转换后3d坐标的y坐标值，你就想象有一条直线与y＝d这个平面相交的点，
				
				//				cube.position =flashTo3d(e.stageX,e.stageY);
				cube.position=    flashTo3d (e.stageX,e.stageY);
				moveCamera=true
			}
			if(e.altKey)
			{
				updatePos(e.stageX,e.stageY);
				
			}
		}
		
		private function updatePos(mapX:int=300,mapY:int=300):void
		{
			if(_hero)
			{
				var vet:Vector3D=flashTo3d(mapX,mapY);
				_hero.position=vet;
				Draw.DrawCircle(graphics,2,mapX,mapY,0xFF0000);
			}
		}
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			moveCamera = false;
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			_move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
		/**  坐标转化
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */
		private function flashTo3d(px:Number,py:Number):Vector3D
		{
			return _view.unproject(px,py,1); ///值必须为1 
		}
		
		
		
		
		
		
	}
}
