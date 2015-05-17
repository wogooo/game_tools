package
{
	/**@author yefeng
	 *2013-3-16下午11:59:20
	 */
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.movie3d.avartar.AbsAnimator3D;
	import com.YFFramework.core.movie3d.avartar.ActionName;
	import com.YFFramework.core.movie3d.avartar.MeshUtil;
	import com.YFFramework.core.movie3d.avartar.RolePard3D;
	import com.YFFramework.core.movie3d.avartar.RolePart3DData;
	import com.YFFramework.core.movie3d.core.Layer3DManager;
	import com.YFFramework.core.movie3d.core.Movie3dLoader;
	import com.YFFramework.core.movie3d.core.YFEngine;
	import com.YFFramework.core.movie3d.skill2d.Movie3D;
	import com.YFFramework.core.movie3d.skill2d.YFSprite3D;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.MapTexture;
	
	[SWF(width="800",height="600")]
	public class YFEngineTest extends Sprite
	{
		[Embed(source="test.png")]
		public var BMP:Class;
		
		private var _movie:Movie3D;

		private var _bitmapData:BitmapData
		private var _hero:AbsAnimator3D;
		
		
		private var sprite3d:YFSprite3D;
		public function YFEngineTest()
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
			YFEngine.Instance.addEventListener(YFEngine.CompleteInit,ok);
			YFEngine.Instance.start(this,stage);
		}
		private function ok(e:YFEvent):void
		{
			
			initObjects();
			initYF2dObject();
			initLiteners();
			
		}
		private function initLiteners():void
		{
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private var _px:Number=1;
		private var _py:Number=1;
		private function onMouseDown(e:MouseEvent):void
		{
			//			moveCamera = true;
			if(e.altKey)
			{
//				updatePos(e.stageX,e.stageY);
//				sprite3d.width -=10;
			//	uv 动画设置原理
//				sprite3d.updateUVData(Vector.<Number>([0,0,_px,0,_px,_py,0,_py]));
//				print(this,sprite3d.geometry.UVData);
//				_px -=0.02;
//				_py -=0.02;
//				sprite3d.width -=5;
//				sprite3d.height -=5;

				var vect:Vector3D=sp.parent.position;//mat.transformVector(sp.position);
				var pt:Vector3D=YFEngine.Instance.away3dToFlash(vect);
				var rad:Number=Math.PI*YFEngine.Instance.getTiltAngle()/180;
				var testY:Number=(Math.cos(rad)*sp.y);
				print(this,"testY",rad,testY);
//				pt.y -=testY
				Draw.DrawCircle(graphics,5,pt.x,pt.y,0xFF00FF);
				print(this,pt);
				
				var uv:Vector.<Number>=Vector.<Number>([0, 0, _px, 0, _px, _py, 0, _py])
					sprite3d.geometry.updateUVData(uv);
					_px -=0.01;
					_py -=0.01;
			}
			else
			{
//				if(_hero.clothData)
//				{
					_hero.moveToPt(e.stageX,e.stageY,8,completeWalk,_hero);	
//				}
			}
			
		}
		private function completeWalk(obj:Object):void
		{
			var hero:AbsAnimator3D=obj as AbsAnimator3D;
			if(hero.clothData)
			{
				hero.play(ActionName.Stand);
				print(this,"moveCompletee");

			}
		}
			
		
		private function onResize(e:Event=null):void
		{
			ResizeManager.Instance.resize();///摄像机投影需要
		}


		private function initObjects() : void {
			

			
			var url:String="onkba/onkba.awd"
			url="onkba/PolarBear.awd"
			AssetLibrary.enableParser(AWD2Parser);
			var loader:Movie3dLoader=new Movie3dLoader();
			loader.loadCompleteCallBack=movie3dComplete;
			loader.initData(url);
			_hero=new AbsAnimator3D();
			Layer3DManager.RoleLayerRoot.addChild(_hero);
			
			
			////创建Sprite3d
			_bitmapData=(new BMP() as Bitmap).bitmapData;
//			_bitmapData=Cast.bitmapData(BMP);
			addChild(new Bitmap(_bitmapData));
			sprite3d=new YFSprite3D();
			sprite3d.updateBitmapData(_bitmapData);
			sprite3d.width=100;
			sprite3d.height=300;
			
//			var obj:ObjectContainer3D=new ObjectContainer3D();
//			obj.addChild(sprite3d);
//			Layer3DManager.RoleLayerRoot.addChild(obj);
			Layer3DManager.RoleLayerRoot.addChild(sprite3d);

			var px:int=300;
			var py:int=200
//			obj.position=YFEngine.Instance.flashToSprite3d(px,py,sprite3d.height);
//			sprite3d.position=YFEngine.Instance.flashToModel3d(px,py)//flashToSprite3d(px,py,sprite3d.height);
			Draw.DrawCircle(graphics,2,px,py,0xFF0000);
			
			var trigent:Trident=new Trident();
			Layer3DManager.RoleLayerRoot.addChild(trigent);

		}
		private function onCompleteIt(e:ParamEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onCompleteIt);
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			_movie.initData(actionData);
			_movie.playDefault();
			_movie.y=_movie.z=40;
			
		}

		private var sp:Sprite3D
		private var testHero:AbsAnimator3D
		private function movie3dComplete(mesh:Mesh,data:Object):void
		{
			mesh.material=new ColorMaterial(0xFFFF00);
			mesh.material.bothSides=true
			_hero.updateCloth(meshToRolePart3DData(mesh));
			///两者结合可以防止 模型不显示出来
//			_hero.setMapXY(100,100);
//			var px:int=stage.stageWidth*0.5;
//			var py:int=stage.stageHeight*0.5
//			_hero.moveToPt(px,py,8,completeWalk,_hero);	
//			
			sp=new Sprite3D(new ColorMaterial(0x0000FF),100,200);
			var pF:int=sp.height*0.5
			sp.y=pF
			sp.z=pF
			sp.addEventListener(MouseEvent3D.MOUSE_DOWN,onDown)
				//			_hero.addEffect(sp);

			testHero=new AbsAnimator3D();
			///多少个模型
			var subGeotry:SkinnedSubGeometry=mesh.geometry.subGeometries[0] as SkinnedSubGeometry;
//			print(this,"face:",mesh.geometry.subGeometries.length);
//			print(this,"data:",subGeotry.numTriangles,subGeotry.numVertices,subGeotry.animatedData.length);
			
			
//			var meshClone:Mesh=mesh.clone() as Mesh;
//			var animatorset:SkeletonAnimationSet=new SkeletonAnimationSet(3);
//			var cloneAnimator:SkeletonAnimator=new SkeletonAnimator(animatorset,SkeletonAnimator(mesh.animator).skeleton);
//			for each(var animationNode:AnimationNodeBase in SkeletonAnimationSet(mesh.animator.animationSet).animations)
//			{
//				animatorset.addAnimation(animationNode);
//			}
//			cloneAnimator.updatePosition=false;
//			meshClone.animator=cloneAnimator

			var meshClone:Mesh=MeshUtil.cloneMesh(mesh);
			meshClone.material=new ColorMaterial(0xFF00DD);
			testHero.updateCloth(meshToRolePart3DData(meshClone))
			print(this,"data:",meshClone.animator,_hero.clothData.skeletonAniator);
			Layer3DManager.RoleLayerRoot.addChild(testHero);
			testHero.setMapXY(100,300);
			testHero.play(ActionName.Stand);
			testHero.moveToPt(600,400,4,onCompleteCheck,testHero);

//			testHero.moveToPt(px,py,8);	
			trace("tt",_hero.clothData.skeletonAniator==null,testHero.clothData.skeletonAniator);
			
			_movie=new Movie3D();
			_movie.start();
			Layer3DManager.RoleLayerRoot.addChild(_movie);
			_hero.addEffect(_movie);
			var ff:String="44021.yf2d";
			SourceCache.Instance.addEventListener(ff,onCompleteIt)
			SourceCache.Instance.loadRes(ff);

		}
		private function meshToRolePart3DData(mesh:Mesh,scale:Number=1):RolePart3DData
		{
			var data:RolePart3DData=new RolePart3DData();
			data.mesh=mesh;
			data.scale=scale;
			data.x=0;
			data.y=0;
			data.z=0;
			data.rotationY=0;
			return data;
		}
		private function onCompleteCheck(hero:AbsAnimator3D):void
		{
			hero.play(ActionName.Stand);
			print(this,"ttcomplete");
		}
		

		private function onDown(e:MouseEvent3D):void
		{
		}
			
		private function updatePos(px:Number=100,py:Number=500):void
		{
			Draw.DrawCircle(graphics,2,px,py,0xFF0000);
			_hero.setMapXY(px,py);
			_hero.play(ActionName.Stand);
		}
			
		private function initYF2dObject():void
		{
			
			var sp1:Sprite2D=new Sprite2D();
			var mapTexture:MapTexture=new MapTexture();
			mapTexture.updateSize(2048,2048);
			var bmp1:BitmapData=new BitmapData(2048,2048,true,0xFF336699);
			sp1.setTextureData(mapTexture);
			var texture1:Texture=TextureHelper.Instance.getTexture(bmp1);
			sp1.setFlashTexture(texture1);
			Layer3DManager.BottomLayerRoot.addChild(sp1);
//			sp1.x=400;
//			sp1.y=300;
			var sp2:Sprite2D=new Sprite2D();
			var bmp2:BitmapData=new BitmapData(32,32,true,0xFFFF0000);
			mapTexture=new MapTexture();
			mapTexture.updateSize(32,32);
			sp2.setTextureData(mapTexture);
			var texture2:Texture=TextureHelper.Instance.getTexture(bmp2);
			sp2.setFlashTexture(texture2);
			Layer3DManager.TopLayerRoot.scence.addChild(sp2);
			sp2.x=300;
			sp2.y=400;
		}
		

		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void 
		{
			UpdateManager.Instance.update();
			YFEngine.Instance.render();
			
//			if(testHero)testHero.setMapXY(300,300);

		}
		
		
		
		
		
	}
}