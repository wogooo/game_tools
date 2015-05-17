package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	
	/**
	 * ...
	 * @author Gao Bo (gaobo.xxx@gmail.com)
	 */
	[SWF(frameRate="60")]
	public class Main extends Sprite
	{
		private var _view : View3D;
		private var _scene : Scene3D;
		private var _camera : Camera3D;
		private var _hoverCtrl : HoverController;
		
		private var moveCamera : Boolean;
		private var lastPanAngle : Number;
		private var lastTiltAngle : Number;
		private var lastMouseX : Number;
		private var lastMouseY : Number;
		
		private var cover : BitmapData;
		private var markDot : Shape;
		private var mark : Vector3D;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initEngine();
			initMaterail();
			initObject();
			initListener();
		}
		
		private function initEngine():void
		{
			_scene = new Scene3D();
			_camera = new Camera3D();
			_view = new View3D(_scene, _camera);
			_view.antiAlias = 2;
			_hoverCtrl = new HoverController(_camera, null, 45, 45, 100);
			
			addChild(_view);
		}
		
		private function initMaterail():void
		{
			cover = new BitmapData(64, 64, false, 0xCCCCCC);
		}
		
		private function initObject():void
		{
			mark = new Vector3D(0, 0, 10);
			markDot = new Shape();
			addChild(markDot);
			with (markDot)
			{
				graphics.beginFill(0xFF0000);
				graphics.drawCircle(0, 0, 10);
				graphics.endFill();
			}
			
			var tri : Trident = new Trident();
			_scene.addChild(tri);
			
			var cube : Mesh = new Mesh(new CubeGeometry(20, 20, 20, 1, 1, 1, false), new ColorMaterial(0xCCCCCC));
			_scene.addChild(cube);
		}
		
		private function initListener():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_view.addEventListener(MouseEvent.MOUSE_WHEEL, onMosueWheel);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
			if (e.ctrlKey)//按住ctrl，点击舞台，定位黄色方块
			{
				var cube : Mesh = new Mesh(new CubeGeometry(2, 2, 2, 1, 1, 1, false), new ColorMaterial(0xFFFF00));
				_scene.addChild(cube);
				cube.position = getScreenTo3DPosition(_view, e.stageX, e.stageY, 0);//将舞台坐标，转为away3d坐标，d是转换后3d坐标的y坐标值，你就想象有一条直线与y＝d这个平面相交的点，
			}
			moveCamera = true;
			lastPanAngle = _hoverCtrl.panAngle;
			lastTiltAngle = _hoverCtrl.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			moveCamera = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private function onMouseLeave(e : Event) : void
		{
			moveCamera = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private function onMosueWheel(e : MouseEvent) : void
		{
			_hoverCtrl.distance -= e.delta;
		}
		
		private function onEnterFrame(e : Event) : void
		{
			if (mark)
			{
				var markPosition : Vector3D = _view.project(mark);//将一个away3d坐标，转为舞台坐标，红色圆球一直指示转换后的舞台坐标
				markDot.x = markPosition.x;
				markDot.y = markPosition.y;
				
			}
			if (moveCamera)
			{
				_hoverCtrl.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				_hoverCtrl.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			_view.render();
		}
		
		private function onResize(e : Event = null) : void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
		
		private function getScreenTo3DPosition(view : View3D, $x:Number, $y:Number, d : Number) : Vector3D
		{
		   var _np : Vector3D = new Vector3D(0,1,0);
		   var _d : Number = d;
		   var _intersect : Vector3D = new Vector3D();
		   
		   var pMouse : Vector3D = view.unproject($x, $y);
		   var cam : Vector3D = view.camera.position;
		   var d0 : Number = _np.x * cam.x + _np.y * cam.y + _np.z * cam.z - _d;
		   var d1 : Number = _np.x * pMouse.x + _np.y * pMouse.y + _np.z * pMouse.z - _d;
		   var m : Number = d1 / ( d1 - d0 );
		   
		   _intersect.x = pMouse.x + ( cam.x - pMouse.x ) * m;
		   _intersect.y = pMouse.y + ( cam.y - pMouse.y ) * m;
		   _intersect.z = pMouse.z + ( cam.z - pMouse.z ) * m;
		   return _intersect;
		}
	
	}

}