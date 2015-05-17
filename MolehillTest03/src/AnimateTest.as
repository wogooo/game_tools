package
{
	import com.YFFramework.core.event.YFEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Point;
	
	import yf2d.core.YF2d;
	import yf2d.display.Image;
	import yf2d.display.Scence2D;
	import yf2d.display.SpriteBatch;
	import yf2d.events.YF2dEvent;
	import yf2d.events.YFMouseEvent;
	import yf2d.textures.batch.AtlasData;
	import yf2d.textures.batch.Texture2D;
	import yf2d.textures.batch.TextureAnimate;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.face.ITextureBase;
	import yf2d.utils.TimerLoop;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-12-18 下午08:21:39
	 */
	[SWF(width="800",height="600")]
	public class AnimateTest extends Sprite
	{
		private var scence:Scence2D;
		private var timerLoop:TimerLoop;
		private var yfTexture:TextureAnimate;
		private var len:int;
		private var image:Image;
		private var isDown:Boolean=false;
		public function AnimateTest()
		{
			super();
			addChild(new Stats());
			YF2d.Instance.initData(stage,stage.stageWidth,stage.stageHeight,0x000000);
			scence=YF2d.Instance.scence;
			scence.addEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
		}
		private function onYFEvent(e:YFEvent):void
		{
			scence.removeEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
			initData();
			this.addEventListener(Event.ENTER_FRAME,onFrame);

		}
		protected function initData():void
		{
			var data:BitmapData;
			var w:Number=120;
			var h:Number=80;
			var atlasData:AtlasData=new AtlasData();
			yfTexture=new TextureAnimate(atlasData);
			var pt:Point=new Point();
			len=3;
			for(var i:int=0;i!=len;++i)
			{
				data=new BitmapData(w,h,false,0xFFFFFF*Math.random());
				yfTexture.copyData(data,data.rect,pt)
				pt.x +=data.width;
			}
			var texture:Texture=TextureHelper.Instance.getTexture(atlasData);
			var sp:SpriteBatch=new SpriteBatch(texture);
			
			image=new Image(yfTexture);
			image.x=300;
			image.y=200
			sp.addChild(image);
			
			image.addEventListener(YFMouseEvent.MOUSE_DOWN,function (e:YFMouseEvent):void{ isDown=true	})
			image.addEventListener(YFMouseEvent.MOUSE_UP,function (e:YFMouseEvent):void{isDown=false })
			scence.addChild(sp);
			
			timerLoop=new TimerLoop(300,update);
			timerLoop.start();
		}
		
	
		private function  onFrame(e:Event):void
		{
			timerLoop.update();
			YF2d.Instance.render();
			if(isDown)
			{
				image.x=stage.mouseX;
				image.y=stage.mouseY
			}

		}
		
		private var index:int=0;
		private function update():void
		{
			yfTexture.setFrame(index%len);
			index++;
			
		}
	}
}

