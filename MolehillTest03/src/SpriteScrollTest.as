package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import yf2d.core.YF2d;
	import yf2d.display.Image;
	import yf2d.display.Scence2D;
	import yf2d.display.SpriteBatch;
	import yf2d.display.SpriteScroll;
	import yf2d.events.YF2dEvent;
	import yf2d.textures.batch.AtlasData;
	import yf2d.textures.batch.Texture2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.batch.TextureScroll;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-12-4 下午05:38:20
	 */
	[SWF(width="1200",height="800")]
	public class SpriteScrollTest extends Sprite
	{
		[Embed(source="3840_3360.jpg")]
		private var Map:Class;
		
		
		private var map:Bitmap;
		
		private var heroBmp:Bitmap
		private var scence:Scence2D;
		private var sprite2d:SpriteScroll;
		private var image:Image;
		
		private var hero:Image;
		private var heroTexure:Texture2D
		private var text:TextField;
		
		public function SpriteScrollTest()
		{
			YF2d.Instance.initData(stage,stage.stageWidth,stage.stageHeight,0x114477);
			scence=YF2d.Instance.scence;
			scence.addEventListener(YF2dEvent.CONTEXT_CREATE,onCreate);
			
			addChild(new Stats());
		}
		private function onCreate(e:YF2dEvent):void
		{
			scence.removeEventListener(YF2dEvent.CONTEXT_CREATE,onCreate);
			init();
			addEvent();
		}
		
		private function init():void
		{
			text=new TextField();
			addChild(text);
			text.x=0;
			text.y=50
			text.textColor=0xFF0000;
			text.width=200
			
			
			
			map=new Map() as Bitmap;
		
			sprite2d=new SpriteScroll(stage.stageWidth,stage.stageHeight);
			sprite2d.initTexture(map.bitmapData,new Rectangle(0,0,2048,2048),new Point());
			scence.addChild(sprite2d);
			
			
			
		}
		
		private function addEvent():void
		{
			addEventListener(Event.ENTER_FRAME,onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDown);
		}
		private function onFrame(e:Event):void
		{
			YF2d.Instance.render();
		}
		
		private var speed:int=10;
		private function onDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					sprite2d.scroll(0,-speed);
					
					//	image.y	-=speed;
					break;
				case Keyboard.DOWN:
					sprite2d.scroll(0,speed);
					//	image.y +=speed
					
					break;
				case Keyboard.LEFT:
					sprite2d.scroll(-speed,0);
					//	image.x -=speed
					break;
				case Keyboard.RIGHT:
					sprite2d.scroll(speed,0);
					//image.x +=speed
					break;
				
				
				
			}
			
			text.text="坐标:"+sprite2d.getCoordinate();
		}
		
		
		
	}
}