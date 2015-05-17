package
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yf2d.core.YF2d;
	import yf2d.display.DisplayObject2d;
	import yf2d.display.Image;
	import yf2d.display.Scence2D;
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.events.YF2dEvent;
	import yf2d.textures.batch.TextureAnimate;
	import yf2d.textures.sprite2D.Sprite2DTexture;
	import yf2d.utils.TimerLoop;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-12-18 下午08:21:39
	 */
	[SWF(width="1000",height="800")]
	public class Sprite2DTest extends Sprite
	{
		private var scence:Scence2D;
		private var timerLoop:TimerLoop;
		private var yfTexture:TextureAnimate;
		private var len:int;
		private var image:Image;
		private var isDown:Boolean=false;
		
		public function Sprite2DTest()
		{
			stage.frameRate=60;
			super();
			addChild(new Stats());
			YF2d.Instance.initData(stage,stage.stageWidth,stage.stageHeight,0x000000,2);
			scence=YF2d.Instance.scence;
			scence.addEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
		}
		private function onYFEvent(e:YFEvent):void
		{
			scence.removeEventListener(YF2dEvent.CONTEXT_CREATE,onYFEvent);
			initData();
			this.addEventListener(Event.ENTER_FRAME,onFrame);
			stage.addEventListener(Event.RESIZE,onReSize)
		}
		private function onReSize(e:Event):void
		{
			YF2d.Instance.resizeScence(stage.stageWidth,stage.stageHeight);
			ResizeManager.Instance.resize()
		}
		private var _arr:Array;
		protected function initData():void
		{
			var data:BitmapData;
			var w:Number=256;
			var h:Number=256; ///  
			var num:int=600
			_arr=[];
			for (var i:int=0;i!=num;++i)
			{
				data=new BitmapData(w,h,false,0xFFFFFF*Math.random());
				var sprite2d:Sprite2D=new Sprite2D();
				var textureData:Sprite2DTexture=new Sprite2DTexture(data);
				sprite2d.setTextureData(textureData);
				sprite2d.x=stage.stageWidth*Math.random();
				sprite2d.y=stage.stageHeight*Math.random();
				scence.addChild(sprite2d);
				_arr.push(sprite2d);
				data.dispose();

			}
			


		}
		
	
		private function  onFrame(e:Event):void
		{
			YF2d.Instance.render();
			
			for each(var obj:DisplayObject2d in _arr)
			{
				obj.rotationZ +=1;
			}
		}
	}
}

