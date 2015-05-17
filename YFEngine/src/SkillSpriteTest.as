package
{
	/**@author yefeng
	 *2013-3-22下午8:52:02
	 */
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.materials.ColorMaterial;
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.movie3d.avartar.AbsAnimator3D;
	import com.YFFramework.core.movie3d.avartar.ActionName;
	import com.YFFramework.core.movie3d.avartar.RolePart3DData;
	import com.YFFramework.core.movie3d.core.Layer3DManager;
	import com.YFFramework.core.movie3d.core.Movie3dLoader;
	import com.YFFramework.core.movie3d.core.YFEngine;
	import com.YFFramework.core.movie3d.skill2d.Movie3D;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.MapTexture;
	
	[SWF(width="800", height="600")]
	public class SkillSpriteTest extends Sprite
	{
		private var _movie:Movie3D;
		private var _hero:AbsAnimator3D;
		public function SkillSpriteTest()
		{
			super();
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
		
		private function initObjects():void
		{
			
			var url:String="onkba/onkba.awd"
			url="onkba/PolarBear.awd"
			AssetLibrary.enableParser(AWD2Parser);
			
			var loader:Movie3dLoader=new Movie3dLoader();
			loader.loadCompleteCallBack=movie3dComplete;
			loader.initData(url);
			
			_hero=new AbsAnimator3D();
			Layer3DManager.RoleLayerRoot.addChild(_hero);

			
			
			
			_movie=new Movie3D();
			_movie.start();
			Layer3DManager.RoleLayerRoot.addChild(_movie);
			var tt:String="44021.yf2d";
//			SourceCache.Instance.addEventListener(tt,onCompleteIt)
			SourceCache.Instance.loadRes(tt);
			
			
			
			
			
			

			
			
			
			
//			_hero.addEffect(_movie);

		}
		private function onCompleteIt(e:ParamEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onCompleteIt);
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			_movie.initData(actionData);
			_movie.playDefault();
			
			
			
			
		}
		
		private function movie3dComplete(mesh:Mesh,data:Object):void
		{
			mesh.material=new ColorMaterial(0xFFFF00);
			_hero.updateCloth(meshToRolePart3DData(mesh));
			///两者结合可以防止 模型不显示出来
			_hero.setMapXY(100,100);
			var px:int=stage.stageWidth*0.5;
			var py:int=stage.stageHeight*0.5
			_hero.moveToPt(px,py,8,completeWalk);	
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

		private function completeWalk(obj:Object):void
		{
			_hero.play(ActionName.Stand);
		}
		private function initYF2dObject():void
		{
			var sp1:Sprite2D=new Sprite2D();
			var mapTexture:MapTexture=new MapTexture();
			mapTexture.updateSize(1024,1024);
			var bmp1:BitmapData=new BitmapData(512,512,true,0xFF336699);
			sp1.setTextureData(mapTexture);
			var texture1:Texture=TextureHelper.Instance.getTexture(bmp1);
			sp1.setFlashTexture(texture1);
			Layer3DManager.BottomLayerRoot.addChild(sp1);

			
			var sp2:Sprite2D=new Sprite2D();
			var bmp2:BitmapData=new BitmapData(256,256,true,0xFFFF0000);
			mapTexture=new MapTexture();
			mapTexture.updateSize(256,256);
			sp2.setTextureData(mapTexture);
			var texture2:Texture=TextureHelper.Instance.getTexture(bmp2);
			sp2.setFlashTexture(texture2);
			Layer3DManager.TopLayerRoot.scence.addChild(sp2);
			sp2.x=300;
			sp2.y=400;

		}

		private function initLiteners():void
		{
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
//			_movie.setFlashPosition(-stage.stageWidth*0.5,stage.stageHeight*0.5);
//			_movie.x=-stage.stageWidth*0.5
//			_movie.z=stage.stageHeight*0.5;
//			_movie.y=stage.stageHeight*0.5;
			
			_hero.moveToPt(e.stageX,e.stageY,8,completeWalk);	


		}
		private function onResize(e:Event=null):void
		{
			ResizeManager.Instance.resize();///摄像机投影需要
		}
		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void 
		{
			UpdateManager.Instance.update();
			YFEngine.Instance.render();
		}


	}
}