package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import yf2d.core.YF2d;
	import yf2d.display.Image;
	import yf2d.display.Scence2D;
	import yf2d.display.SpriteBatch;
	import yf2d.display.batch.extensions.Map4096_4096;
	import yf2d.events.YF2dEvent;
	import yf2d.textures.batch.AtlasData;
	import yf2d.textures.batch.Texture2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.batch.TextureScroll;
	
	/**
	 * author :夜枫
	 */
	[SWF(width="1024",height="700")]
	public class Map4096_4096Test extends Sprite
	{
		[Embed(source="4096_4096.jpg")]
		private var Map:Class;
		
		[Embed(source="spritechar2.png")]   // 72  128
		private  var BMD:Class;		
		
		private var map:Bitmap;
		
		private var heroBmp:Bitmap
		private var scence:Scence2D;
		private var sprite2d:SpriteBatch;
		private var image:Image;
		
		private var map4096_4096:Map4096_4096;
		private var hero:Image;
		private var heroTexure:Texture2D
		private var text:TextField;
		
		public function Map4096_4096Test()
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
			trace("函数:",onCreate==init);
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
			heroBmp=new BMD() as Bitmap;
			map4096_4096=new Map4096_4096(map.bitmapData,stage.stageWidth,stage.stageHeight);
			scence.addChild(map4096_4096);
			
			map.bitmapData.dispose();
			
			
			var atlas:AtlasData=new AtlasData(1024,1024); 
			heroTexure=new Texture2D(atlas)	
			heroTexure.copyData(heroBmp.bitmapData,new Rectangle(0,0,heroBmp.width,heroBmp.height),new Point());
			var smallTexture:Texture=TextureHelper.Instance.getTexture(atlas);
			atlas.dispose();
			var sp:SpriteBatch;
			var num:int=0;
			text.text=num+"个对象";
			while(num--)
			{
				hero=new Image(heroTexure);
				hero.x=stage.stageWidth*Math.random()
				hero.y=stage.stageHeight*Math.random()
			//	hero.scaleX=hero.scaleY=0.25
				sp=new SpriteBatch(smallTexture);
				sp.addChild(hero);
				scence.addChild(sp);
			}
			
			
			//创建光影效果
			var myData:BitmapData=new BitmapData(1024,1024,false,0xff0000);
			var   myBase:AtlasData=new AtlasData(1024,1024)
			var texture2d:Texture2D=new Texture2D(myBase);
			texture2d.copyData(myData,myData.rect,new Point())
			var effect:Image=new Image(texture2d);
			effect.pivotX=-effect.width*0.5
				effect.pivotY=-effect.height*0.5
			var myBaseTexture:Texture=TextureHelper.Instance.getTexture(myBase);
			var spbase:SpriteBatch=new SpriteBatch(myBaseTexture)
			scence.addChild(spbase);
			spbase.addChild(effect);
			effect.alpha=0.2
			
		}
		
		private function addEvent():void
		{
			addEventListener(Event.ENTER_FRAME,onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDown);
			stage.addEventListener(Event.RESIZE,onResize)
		}
		
		private function onResize(e:Event):void
		{
			YF2d.Instance.resizeScence(stage.stageWidth,stage.stageHeight);
			
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
					map4096_4096.scroll(0,-speed);
					
					//	image.y	-=speed;
					break;
				case Keyboard.DOWN:
					map4096_4096.scroll(0,speed);
					//	image.y +=speed
					
					break;
				case Keyboard.LEFT:
					map4096_4096.scroll(-speed,0);
					//	image.x -=speed
					break;
				case Keyboard.RIGHT:
					map4096_4096.scroll(speed,0);
					//image.x +=speed
					break;
				
				
				
			}
			
			text.text="坐标"+map4096_4096.getViewRect().topLeft+map4096_4096.getViewRect().bottomRight;
			System.pauseForGCIfCollectionImminent();
		}
		
		
		
	}
}