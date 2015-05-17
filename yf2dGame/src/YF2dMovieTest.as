package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.SWFProfiler;
	import com.YFFramework.core.debug.Stats;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.net.loader.yf2d.YF2dLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dChatArrow;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dMovieClip;
	import com.YFFramework.core.utils.net.SourceCache;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	
	import yf2d.core.YF2d;
	import yf2d.display.Scence2D;
	import yf2d.display.sprite2D.Map2D;
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.display.sprite2D.YF2dGameNameLabel;
	import yf2d.events.YF2dEvent;
	import yf2d.events.YF2dMouseEvent;
	import yf2d.textures.sprite2D.SimpleTexture2D;
	import yf2d.textures.sprite2D.Sprite2DTexture;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-12-18 下午08:21:39
	 */
	[SWF(width="1200",height="800")]
	public class YF2dMovieTest extends Sprite
	{
		private var scence:Scence2D;
		private var movie:YF2dMovieClip;	
		private var  _lowBmp:Map2D;
		public function YF2dMovieTest()
		{		
			if(stage)
			{
				StageProxy.Instance.configure(stage);
				stage.frameRate=30;
				super();
				addChild(new Stats());
				SWFProfiler.init(stage,this);
				YF2d.Instance.initData(stage,0xFFFFFF,2);
				scence=YF2d.Instance.scence;
				scence.addEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
			}
			
			
			
		}
		private function onYFEvent(e:YF2dEvent):void
		{
			scence.removeEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
			initUI()
			this.addEventListener(Event.ENTER_FRAME,onFrame);
			
		}
	
		private function initUI():void{
		var loader:UISLoader=new UISLoader();
		var arr:Vector.<Object>=new Vector.<Object>();
		arr.push({url:"http://stage3d.game.com/common/loading/uiSkin.swf"},{url:"http://stage3d.game.com/common/loading/fightUI.swf"},{url:"http://stage3d.game.com/common/loading/face.swf"});
		loader.load(arr)
		loader.loadCompleteCallBack=complete
	}
	private function complete(data:Object):void
	{
		
		////创建你冒泡对象
		var _chatArrow:YF2dChatArrow=new YF2dChatArrow();
		_chatArrow.text="你好吗？？？我真的很好"
		scence.addChild(_chatArrow);
		_chatArrow.x=200;
		_chatArrow.y=200;
		
		initData();
	}
		
		protected function initData():void
		{
			movie=new YF2dMovieClip();
//			scence.addChild(movie);
			movie.x=stage.stageWidth*0.5;
			movie.y=stage.stageHeight*0.5
				
			movie.addEventListener(YF2dMouseEvent.MOUSE_OVER,onMouseEvent);
			movie.addEventListener(YF2dMouseEvent.MOUSE_OUT,onMouseEvent);

			var url:String="2201.yf2d";//"10000.yf2d"//
			var loader:YF2dLoader=new YF2dLoader();
			loader.load(url);
			loader.loadCompleteCallback=callBack;
			
			Draw.DrawCircle(graphics,2,stage.stageWidth*0.5,stage.stageHeight*.5,0xFF0000)
			
				_lowBmp=new Map2D(0,0);
				scence.addChild(_lowBmp);
				var testUrl:String="0_0.map"// 265
				SourceCache.Instance.addEventListener(testUrl,completeLoad);
				SourceCache.Instance.loadRes(testUrl)
		}
		
		private function completeLoad(e:ParamEvent):void
		{
			var atfBytes:ByteArray=SourceCache.Instance.getRes2(e.type) as ByteArray;
			_lowBmp.atfBytes=atfBytes;
			/// createm  rect
			var texture2D:SimpleTexture2D=new SimpleTexture2D();
			texture2D.setTextureRect(0,0,256,256);
			_lowBmp.setTextureData(texture2D);
//			_lowBmp.pivotX=-_lowBmp.width*0.5;
//			_lowBmp.pivotY=-_lowBmp.height*0.5;
			_lowBmp.scaleX=10;
			_lowBmp.scaleY=10;
			
			/// create flash Texture
			_lowBmp.createFlashTexture();
			////对低像素图片进行缩放
			
			
		
			
		}
		
		
		private function onMouseEvent(e:YF2dMouseEvent):void
		{
			trace(e.handler)
			switch(e.type)
			{	
				case YF2dMouseEvent.MOUSE_OVER:
					buttonMode=true
					Mouse.cursor=MouseCursor.BUTTON;
					break;
				case YF2dMouseEvent.MOUSE_OUT:
					buttonMode=false;
					Mouse.cursor=MouseCursor.AUTO;
					break;
			}
		}
		
		private function callBack(loader:YF2dLoader,data:Object):void
		{
			var sprite2d:Sprite2D=new Sprite2D();
			var myData:BitmapData=new BitmapData(256,256,false,0xFFFFFF);
			var sprite2dTexture:Sprite2DTexture=new Sprite2DTexture(myData);
			sprite2d.setTextureData(sprite2dTexture);
			sprite2d.setFlashTexture(sprite2dTexture.getFlashTexture());
			scence.addChildAt(sprite2d,0);
			sprite2d.width=3000
			sprite2d.height=3000   ////背景地图....
			
			var actionData:YF2dActionData=loader.actionData;
			movie.initData(actionData);
			movie.start();
		//	movie.playDefault();
			movie.play(TypeAction.Stand,TypeDirection.Left);
//			movie.stop()
			movie.gotoAndStop(0,1,6);
		//	movie.play(TypeAction.Attack,TypeDirection.Down)
			
				

//			var animator:AbsAnimatorView=new AbsAnimatorView();
//			scence.addChild(animator);
//			animator.updateCloth(actionData);
//			animator.startPlay();
//			animator.play(TypeAction.Stand,TypeDirection.Left);
//			animator.x=300;
//			animator.y=500;
			
		////创建文本
			var txt:YF2dGameNameLabel=new YF2dGameNameLabel();
			scence.addChild(txt);
			txt.setText("天下无敌啊");
			txt.setText("ssss");
			txt.x=200
			txt.y=400
				
			txt.colorTransform=new ColorTransform(1.5, 0, 0.1, 1, -61, -71, -176);
				
				

		}
		
		
		private function  onFrame(e:Event):void
		{
			YF2d.Instance.render();
			UpdateManager.Instance.update();
		}
		
	}
}

