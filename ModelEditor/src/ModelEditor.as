package
{
	/**@author yefeng
	 *2013-3-25下午9:30:27
	 */
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.movie3d.avartar.AbsAnimator3D;
	import com.YFFramework.core.movie3d.avartar.ActionName;
	import com.YFFramework.core.movie3d.avartar.RolePart3DData;
	import com.YFFramework.core.movie3d.base.AbsGameEngine;
	import com.YFFramework.core.movie3d.core.Layer3DManager;
	import com.YFFramework.core.movie3d.core.Movie3dLoader;
	import com.YFFramework.core.movie3d.core.YFEngine;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.text.SimpleText;
	import com.YFFramework.core.utils.UtilString;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.InvokeEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.globalization.Collator;
	
	import view.MainUIView;
	
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.SimpleTexture2D;
	import yf2d.textures.sprite2D.Sprite2DTexture;
	
	[SWF(width="1000",height="650")]
	public class ModelEditor extends AbsGameEngine
	{
		
		private static const Glow:GlowFilter=new GlowFilter(0xFF0000,1,10,10);
		
		private static const assetsURL:String="assets/shadow.png";
		private static const BgUrl:String="assets/bg.jpg";
		private static const ShadowX:int=560;
		private static const ShadowY:int=520;
		private var _bgLayer:Sprite2D;
		private var _hero:AbsAnimator3D;
		/**人物阴影 
		 */		
		private var roleShadow:Sprite2D;
		
		private var _mainUI:MainUIView;
		
		private var _flashX:Number=0;
		private var _flashY:Number=0;
		
		private var typeRole:int;
		/**主模型
		 */		
		private static const Type_MainModel:int=1;
		/**材质
		 */		
		private static const Type_Material:int=2;
		/**参照模型
		 */		
		private static const Type_RefModel:int=3;
		public function ModelEditor()
		{
		}
		override protected function initComplete(e:YFEvent=null):void
		{
			super.initComplete(e);
			initAllUI();
		}
		/**加载皮肤资源
		 */		
		private function loadSkin():void
		{
			
		}
		
		private function initAllUI():void
		{
			initBg();
			initMainUI();
			initRole();
			addEvents();
			resize();
		}
		private function initRole():void
		{
			roleShadow=new Sprite2D();
			Layer3DManager.BottomLayerRoot.addChild(roleShadow);
			roleShadow.x=ShadowX;
			roleShadow.y=ShadowY;
			initShadowData();
			_hero=new AbsAnimator3D();
			Layer3DManager.RoleLayerRoot.addChild(_hero);
		}
		private function initShadowData():void
		{
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=shadowComplete
			loader.initData(assetsURL);
		}
		private function shadowComplete(content:Bitmap,data:Object):void
		{
			var bitmapData:BitmapData=content.bitmapData;
			var w:int=bitmapData.width;
			var h:int=bitmapData.height;
			var copyData:Object=BitmapDataUtil.getValideBitmapData(bitmapData);
			var simpleTexture:SimpleTexture2D=new SimpleTexture2D();
			simpleTexture.setTextureRect(0,0,w,h);
			simpleTexture.setUVData(Vector.<Number>([0,0,copyData.u,copyData.v]));
			roleShadow.setTextureData(simpleTexture);
			var flashTexture:Texture=TextureHelper.Instance.getTexture(copyData.data as BitmapData);
			roleShadow.setFlashTexture(flashTexture);
		}
			
		
		private function resize():void
		{
//			_hero.setMapXY(roleShadow.x,roleShadow.y-1);
//			_hero.moveToPt();
			roleShadow.x=ShadowX;
			roleShadow.y=ShadowY;
//			_hero.forceUpdate(roleShadow.x,roleShadow.y);
			_hero.setMapXY(roleShadow.x,roleShadow.y);
		}
		
		private function initBg():void
		{
			_bgLayer=new Sprite2D();
			Layer3DManager.BottomLayerRoot.addChild(_bgLayer);
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=bgLoaded;
			loader.initData(BgUrl);
		}
		/** bgLoaded
		 */
		private function bgLoaded(content:Bitmap,data:Object):void
		{
			var bitmapData:BitmapData=content.bitmapData;
			var w:int=content.bitmapData.width;
			var h:int=content.bitmapData.height;
			var myData:Object=BitmapDataUtil.getValideBitmapData(bitmapData);
			_bgLayer.setAtlas(myData.data as BitmapData);
			var spTexture:SimpleTexture2D=new SimpleTexture2D();
			spTexture.setUVData(Vector.<Number>([0,0,myData.u,myData.v]));
			spTexture.setTextureRect(0,0,w,h);
			_bgLayer.setTextureData(spTexture);
			var flashTexture:Texture=TextureHelper.Instance.getTexture(_bgLayer.getAtlas());
			_bgLayer.setFlashTexture(flashTexture);
			_bgLayer.x=w*0.5;
			_bgLayer.y=h*0.5;
		}
		/**初始化主界面
		 */		
		private function initMainUI():void
		{
			_mainUI=new MainUIView();
			addChild(_mainUI);
		}
		/**打开文件 
		 */		
		private function addEvents():void
		{
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDragDrop);
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragDrop);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke); ///双击文件打开
			ResizeManager.Instance.regFunc(resize);
			
			
			///事件侦听
			//模型Y轴旋转变化
			YFEventCenter.Instance.addEventListener(MainUIView.RotationYChange,onGloableEvent);
			YFEventCenter.Instance.addEventListener(MainUIView.XChange,onGloableEvent);
			YFEventCenter.Instance.addEventListener(MainUIView.YChange,onGloableEvent);
			YFEventCenter.Instance.addEventListener(MainUIView.ScaleChange,onGloableEvent);

		}
		private function onGloableEvent(e:YFEvent):void
		{
			var data:Object=e.param;
			var pos:Vector3D;
			var vect:Vector3D;
			switch(e.type)
			{
				case MainUIView.RotationYChange://模型绕Y轴旋转 
					_hero.updateRotationY(int(data));
					break;
				case MainUIView.XChange://
					_flashX=Number(data);
					pos=YFEngine.Instance.flashToModel3d(_flashX+ShadowX,_flashY+ShadowY);
					vect=globleTolocal3D(pos,_hero);
					_hero.clothData.rolePart3DData.mesh.position=vect;
					_hero.forceUpdate(_hero._mapX,_hero._mapY);
					break;
				case MainUIView.YChange://
					_flashY=Number(data);
					pos=YFEngine.Instance.flashToModel3d(_flashX+ShadowX,_flashY+ShadowY);
					vect=globleTolocal3D(pos,_hero);
					_hero.clothData.rolePart3DData.mesh.position=vect;
					_hero.forceUpdate(_hero._mapX,_hero._mapY);
					break;
				case MainUIView.ScaleChange://
					_hero.updateScale(Number(data));
					break;
			}
		}
		
		/**世界坐标转化为局部坐标
		 * @param vect
		 * @param container
		 * @return 
		 * 
		 */		
		private function globleTolocal3D(vect:Vector3D,container:ObjectContainer3D):Vector3D
		{
			var mat:Matrix3D=container.transform;
			mat.invert();
			var myVect:Vector3D=mat.transformVector(vect);
			return myVect;
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			var arr:Array=e.arguments;
			if(arr.length>0)
			{
				var url:String=arr[0];
				openFile(url);
			}
		}
		private function onDragDrop(e:NativeDragEvent):void
		{
			//将拖入的文件以数组形式获得，指定拖入的数据是文件数组形式
			var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			//获得拖入的第一个文件
			var file:File = File(files[0]);
			switch(e.type)
			{				
				case NativeDragEvent.NATIVE_DRAG_ENTER:  
					if(file.isDirectory||file.type==".awd"||file.type==".png"||file.type==".jpg")
						NativeDragManager.acceptDragDrop(this);
					break;
				case NativeDragEvent.NATIVE_DRAG_DROP:
					typeRole=Type_MainModel;
					if(_mainUI.isInMaterial())
					{
						typeRole=Type_Material;
						glowObj(_mainUI.materialBtn);
					}
					else if(_mainUI.isInRefModel())
					{
						typeRole=Type_RefModel;
						glowObj(_mainUI.refModelBtn);
					}
					else 
					{
						typeRole=Type_MainModel;
						glowObj(_mainUI.modelBtn);
					}
					//当在副宠一参照物时
					if(file.type==".png"||file.type==".jpg")
					{
//						//处理原图片 file 
						initLoadPic(file.url);
					}
					else
					{
						///处理二进制图片
						openFile(file.url);
					}
					break;
			}
		}  

		private function initLoadPic(url:String):void
		{
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=picLoaded;
			loader.initData(url);	
		}
		private function picLoaded(bitmap:Bitmap,data:Object):void
		{
			_hero.clothData.updateMaterial(bitmap.bitmapData);
		}
			
			
		private function openFile(url:String):void
		{
			
			var suffix:String=UtilString.getSuffix(url);
			switch(suffix)
			{
				case "awd":
					loadAWD(url);
					break;
			}
		}
		/**加载awd 
		 */		
		private function loadAWD(url:String):void
		{
			var loader:Movie3dLoader=new Movie3dLoader();
			loader.loadCompleteCallBack=awdLoaded;
			loader.initData(url);
		}
		/**awd加载
		 */		
		private function awdLoaded(mesh:Mesh,data:Object):void
		{
			initMeshData(mesh);
		}
		
		/**初始化所有的数据
		 */		
		private function initMeshData(mesh:Mesh):void
		{
			mesh.material=new ColorMaterial(0xFF334466);
			mesh.material.bothSides=true;
			_hero.updateCloth((meshToRolePart3DData(mesh)));
			_hero.forceUpdate(_hero.roleDyVo.mapX,_hero.roleDyVo.mapY);

			_hero.play(ActionName.Stand);
			_mainUI.resetRotationY();
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
		
		private function glowObj(obj:DisplayObject):void
		{
			obj.filters=[Glow];
			
		}
		private function removeGlow(obj:DisplayObject):void
		{
			obj.filters=[];
		}
		
		private function initMaterial(model:AbsAnimator3D,bitmapData:BitmapData):void
		{
			model.clothData.updateMaterial(bitmapData);
		}
		
	}
}
