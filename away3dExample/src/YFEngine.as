package
{
	/**@author yefeng
	 *2013-3-16下午11:59:20
	 */
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.textures.BitmapTexture;
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.MapTexture;
	
	[SWF(width="1200",height="800")]
	public class YFEngine extends Sprite
	{
		
		// Materials
		private var cubeMaterial : TextureMaterial;
		
		// Objects
		private var cube1 : Mesh;
		private var cube2 : Mesh;
		private var cube3 : Mesh;
		private var cube4 : Mesh;
		private var cube5 : Mesh;
		private var engine:EngineInit;
		
		private var _hero:Mesh;
		public function YFEngine()
		{
			init();
		}

		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			engine=new EngineInit(this,stage);
			engine.addEventListener(EngineInit.EngineInit,ok);
			engine.start();
//			initProxies();
		}
		private function ok(e:YFEvent):void
		{
			initMaterials();
			initObjects();
			initYF2dObject();
			initLiteners();
			
		}
		private function initLiteners():void
		{
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onResize(e:Event=null):void
		{
			ResizeManager.Instance.resize();///摄像机投影需要
		}


		/**
		 * Initialise the materials
		 */
		private function initMaterials() : void {
			//Create a material for the cubes
			var cubeBmd:BitmapData = new BitmapData(128, 128, false, 0x0);
			cubeBmd.perlinNoise(7, 7, 5, 12345, true, true, 7, true);
			cubeMaterial = new TextureMaterial(new BitmapTexture(cubeBmd));
			cubeMaterial.gloss = 20;
			cubeMaterial.ambientColor = 0x808080;
			cubeMaterial.ambient = 1;
		}
		private function initObjects() : void {
			// Build the cubes for view 1
			var cG:CubeGeometry = new CubeGeometry(300, 300, 300);
			cube1 = new Mesh(cG, cubeMaterial);
			cube2 = new Mesh(cG, cubeMaterial);
			cube3 = new Mesh(cG, cubeMaterial);
			cube4 = new Mesh(cG, cubeMaterial);
			cube5 = new Mesh(cG, cubeMaterial);
			
			// Arrange them in a circle with one on the center
			cube1.x = -750;
			cube2.z = -750;
			cube3.x = 750;
			cube4.z = 750;
			cube1.y = cube2.y = cube3.y = cube4.y = cube5.y = 150;
			
			// Add the cubes to view 1
			LayerManager.RoleLayerRoot.addChild(cube1);
			LayerManager.RoleLayerRoot.addChild(cube2);
			LayerManager.RoleLayerRoot.addChild(cube3);
			LayerManager.RoleLayerRoot.addChild(cube4);
			LayerManager.RoleLayerRoot.addChild(cube5);
			LayerManager.RoleLayerRoot.addChild(new WireframePlane(2500, 2500, 20, 20, 0xbbbb00, 1.5, WireframePlane.ORIENTATION_XZ));
			
			
			var url:String="assets/PolarBear.awd"
			var loader:Movie3dLoader=new Movie3dLoader();
			loader.loadCompleteCallBack=movie3dComplete;
			loader.initData(url);
			
		}
		private function movie3dComplete(mesh:Mesh,data:Object):void
		{
			_hero=mesh;
			LayerManager.RoleLayerRoot.addChild(_hero);
			updatePos();
			play();
			
		}
		private function updatePos(px:Number=100,py:Number=100):void
		{
			_hero.position=engine.flashTo3d(px,py);
			Draw.DrawCircle(graphics,1,px,py,0xFF0000);

		}
			
		
		private function play(acion:String="Breathe"):void
		{
			 var transition:CrossfadeTransition = new CrossfadeTransition(0.5);

			 SkeletonAnimator(_hero.animator).play(acion);
		}
		
		
		
		private function initYF2dObject():void
		{
			
			var sp1:Sprite2D=new Sprite2D();
			var mapTexture:MapTexture=new MapTexture();
			mapTexture.updateSize(256,256);
			var bmp1:BitmapData=new BitmapData(256,256,true,0xFF336699);
			sp1.setTextureData(mapTexture);
			var texture1:Texture=TextureHelper.Instance.getTexture(bmp1);
			sp1.setFlashTexture(texture1);
			LayerManager.BottomLayerRoot.addChild(sp1);
			sp1.x=400;
			sp1.y=300;
			var sp2:Sprite2D=new Sprite2D();
			var bmp2:BitmapData=new BitmapData(256,256,true,0xFFFF0000);
			sp2.setTextureData(mapTexture);
			var texture2:Texture=TextureHelper.Instance.getTexture(bmp2);
			sp2.setFlashTexture(texture2);
			LayerManager.TopLayerRoot.scence.addChild(sp2);
			sp2.x=300;
			sp2.y=400;
		}
		

		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void 
		{
			engine.render();
		}

		
		
		
	}
}