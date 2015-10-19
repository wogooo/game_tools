package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.sprite2D.LowMapData;
	import com.YFFramework.core.yf2d.display.sprite2D.Sprite2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.SimpleTexture2D;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import atfMovie.ATFMovieAnalysse;
	import atfMovie.ATFSkillEffect;
	
	import data.ATFActionData;
	
	import util.ActionUtil;
	
	import utils.ui.Tree;
	import utils.ui.events.TreeEvent;
	import utils.ui.treeAssets.TreeBase;
	import utils.ui.treeAssets.TreeContainer;
	
	[SWF(width="1200",height="800")]
	public class ATFMovie extends Sprite
	{
		private var _movie:ATFSkillEffect;
		private var _bg:Sprite2D;
		
		private var  _mytree:Tree; 
		private var container:AbsView;
		
		
		private var actionData:ATFActionData;
		
		private var xml:XML;
		
		
		private var _bgUrl:String="assets/bg.jpg"
		
		public function ATFMovie()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE

			initUI();
			addEvent();
//			var sp:Sprite=new Sprite();
//			addChild(sp);
			
			var file:File = File.desktopDirectory;
			
			file = FileUtil.createDirectory("E:\\createMovie");
			ActionDataCreate.Instance.init(stage.stageWidth,stage.stageHeight,file,this._movie);
		}
		
		private function addEvent():void
		{
			_mytree.addEventListener(TreeEvent.ITEM_CLICK,onTreeClick);
			
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDragDrop);
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragDrop);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke); ///双击文件打开

		}
		private function onInvoke(e:InvokeEvent):void
		{
			var arr:Array=e.arguments;
			if(arr.length>0)
			{
				var url:String=arr[0];
				var myF:File=File.desktopDirectory;
				myF.nativePath=url;
				openFileMovie(myF);
			}
		}

		
		
		private function initPlay(action:int,direction:int=-1,loop:Boolean=true):void
		{
			if(direction<=0)direction=1;
			_movie.play(action,direction,loop);
		}
		
		private function getDirection(file:TreeBase):int
		{
			var direction:int=-1;
			switch(file.title)
			{
				case "上":
					direction=TypeDirection.Up;
					break;
				case "右上":
					direction=TypeDirection.RightUp;
					break;
				case "右":
					direction=TypeDirection.Right;
					break;
				case "右下":
					direction=TypeDirection.RightDown;
					break;
				case "下":
					direction=TypeDirection.Down;
					break;

			}
			return direction;
		}
		private function getAction(file:TreeBase):int
		{
			var act:int=-1;
			switch(file.title)
			{
				case "待机":
					act=TypeAction.Stand
					break;
				case "全部":
					act=TypeAction.Stand
					break;
				case "行走":
					act=TypeAction.Walk
					break;
				case "攻击":
					act=TypeAction.Attack
					break;
				case "受击":
					act=TypeAction.Injure
					break;
				case "死亡":
					act=TypeAction.Dead
					break;
				case "战斗待机":
					act=TypeAction.FightStand
					break;
				case "特殊攻击1":
					act=TypeAction.SpecialAtk_1
					break;
				case "特殊攻击2":
					act=TypeAction.SpecialAtk_2;
					break;
				case "特殊攻击3":
					act=TypeAction.SpecialAtk_3;
					break;
				case "特殊攻击4":
					act=TypeAction.SpecialAtk_4;
					break;	 
			}
			return act;
		}
		

		private function onTreeClick(e:TreeEvent):void
		{
			var file:TreeBase=e.file;

			var action:int=getAction(file);
			var direction:int=1;
			if(action==-1) //点击 的方向
			{
				action=getAction(TreeContainer(file.parent).treeFolder);
				direction=getDirection(file);
			}
			else 
			{
				direction=TypeDirection.Down;
			}

			initPlay(action,direction,true);
			ActionDataCreate.Instance.start();
		}
		
		protected function initUI():void
		{
			container=new AbsView();
			addChild(container);
			Draw.DrawRect(container.graphics,150,500); 
			
			_mytree=new Tree();
			container.addChild(_mytree);
			_mytree.y=100;

			initYF2d();
			initDisplay(); 
			initBg();
		}
		private function initDisplay():void
		{
			_movie=new ATFSkillEffect();
			_movie.start();
			YF2d.Instance.scence.addChild(_movie);
			_movie.setXY(400,416);
			
		} 
		private function initBg():void
		{
			_bg=new Sprite2D();
			YF2d.Instance.scence.addChildAt(_bg,0);
			var loader:IconLoader=new IconLoader();
			loader.loadCompleteCallback=call;
			loader.initData(_bgUrl)
		} 
		private function call(bitmap:Bitmap,data:Object):void
		{
			var content:BitmapData=bitmap.bitmapData;
			var w:int=content.width;
			var h:int=content.height;
			var lowmapData:LowMapData=BitmapDataUtil.getValideBitmapData(content);
			var texture2D:SimpleTexture2D=new SimpleTexture2D();
			texture2D.setTextureRect(0,0,w,h); 
			texture2D.setUVData(Vector.<Number>([0,0,lowmapData.u,lowmapData.v]));
			_bg.setTextureData(texture2D);
//			_bg.lowMapData=lowmapData;
//			_bg.setAtlas(lowmapData.bitmapData);
			var texture:Texture=TextureHelper.Instance.getTexture(lowmapData.bitmapData) as Texture;
			_bg.setFlashTexture(texture);
			_bg.setXY(w*0.5,h*0.5);
			_bg.visible = false;
		}
				
		private function initYF2d():void   
		{
			StageProxy.Instance.configure(stage);
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_First_CREATE,onContext3dCreate);
			YF2d.Instance.initData(stage,0xFFFFFF);
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
		}
		private function onResize(e:Event):void
		{
			ResizeManager.Instance.resize();
			YF2d.Instance.resizeScence(StageProxy.Instance.stage.stageWidth,StageProxy.Instance.stage.stageHeight);
		}
		
		private function onContext3dCreate(e:YF2dEvent=null):void
		{
			addEventListener(Event.ENTER_FRAME,onFrame);
			
		}
		
		
		private function onFrame(e:Event):void
		{
			MovieUpdateManager.Instance.update();
			YF2d.Instance.render();
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
					if(file.type==FileNameExtension.ATFMovie )
						NativeDragManager.acceptDragDrop(this);
					break;
				case NativeDragEvent.NATIVE_DRAG_DROP:
					
					if(file.type==FileNameExtension.ATFMovie)
					{
						openFileMovie(file);
					}
					break;
			}
		}  
		
		private function  openFileMovie(file:File):void
		{
			var bytes:ByteArray=new ByteArray();
			var stream:FileStream=new FileStream();
			stream.open(file,FileMode.READ);
			stream.readBytes(bytes,0,stream.bytesAvailable);
			stream.close();
			bytes.position=0;
			actionData=ATFMovieAnalysse.handleATFBytes(bytes);
			_movie.initData(actionData);
			_movie.playDefault();
			initTree();
		}
		
		
		
		private function initTree():void
		{
//			var myxml:XML = <node label="Root">  
//							  <node label="Folder 1">  
//								<node label="File 1"/>  
//								<node label="File 2"/>  
//							  </node>  
//							  <node label="Folder 2">  
//								<node label="File 3"/>  
//								<node label="File 4"/>  
//							  </node>  
//							</node>  
//			
//			// mytree is the instance name of your tree on Stage  
//			_mytree.fillData(myxml);  
			
			if(actionData)
			{
				var actObj:Object;
				var directObj:Object;
				var xml:XML=<actions label="全部" value="-10"  />;/// -10值表示全部
				var actionNode:XML;
				var actionLabel:String;
				var directionNode:XML;
				var directionLabel:String;
				for each  (var act:int in actionData.headerData["action"])
				{
					actionNode=<action />
					actionLabel=ActionUtil.GetActionName(act);
					actionNode.@label=actionLabel;
					actionNode.@value=act;
					for each(var direct:int in actionData.headerData[act]["direction"])
					{
						directionNode=<direction />;
						directionLabel=ActionUtil.getDirectionName(direct);
						directionNode.@label=directionLabel;
						directionNode.@value=direct;
						directionNode.@parentValue=act;
						actionNode.appendChild(directionNode);
					}
					xml.appendChild(actionNode);
				}
				var root:XML=<root />
				root.appendChild(xml);
				xml=root;	
				
				////添加血条  默认 血条位置 是在 0 0处
//				var bloodNode:XML=<blood label="血条" value="-20" />
//				xml.appendChild(bloodNode);
				//				.dataProvider=xml;
				//		trace(xml);
				_mytree.fillData(xml); 
			}
		}

		
		
		
		
		
	}
}