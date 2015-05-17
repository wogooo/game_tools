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
	public class TextureScrollTest extends Sprite
	{
		[Embed(source="3840_3360.jpg")]
		private var Map:Class;
		
		[Embed(source="spritechar2.png")]   // 72  128
		private  var BMD:Class;		
		
		private var map:Bitmap;
		
		private var heroBmp:Bitmap
		private var scence:Scence2D;
		private var sprite2d:SpriteBatch;
		private var image:Image;
		
		private var texture:TextureScroll;
		private var hero:Image;
		private var heroTexure:Texture2D
		private var text:TextField;

		public function TextureScrollTest()
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
			heroBmp=new BMD() as Bitmap
			//addChild(map);
			var atlasData:AtlasData=new AtlasData(2048,2048);
			

			texture=new TextureScroll(atlasData,stage.stageWidth,stage.stageHeight);
			texture.copyData(map.bitmapData,new Rectangle(0,0,atlasData.width,atlasData.height),new Point(0,0));
			image=new Image(texture);
			image.pivotX=-image.width*0.5;
			image.pivotY=-image.height*0.5;
			
			var  bigTexture:Texture=TextureHelper.Instance.getTexture(atlasData);
			///释放内存  
			atlasData.dispose();
			
			sprite2d=new SpriteBatch(bigTexture);
				sprite2d.addChild(image);
				scence.addChild(sprite2d);
				
			var atlas:AtlasData=new AtlasData(1024,1024); 
			heroTexure=new Texture2D(atlas)	
			heroTexure.copyData(heroBmp.bitmapData,new Rectangle(0,0,heroBmp.width,heroBmp.height),new Point());
			var smallTexture:Texture=TextureHelper.Instance.getTexture(atlas);
			var sp:SpriteBatch=new SpriteBatch(smallTexture);
			scence.addChild(sp);
	
			var num:int=2;
			text.text=num+"个对象";
			while(num--)
			{
				hero=new Image(heroTexure);
				hero.x=stage.stageWidth*Math.random()
				hero.y=stage.stageHeight*Math.random()
				sp.addChild(hero);
	
			}
			

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
					texture.scroll(0,-speed);
					
				//	image.y	-=speed;
					break;
				case Keyboard.DOWN:
					texture.scroll(0,speed);
				//	image.y +=speed
					
					break;
				case Keyboard.LEFT:
					texture.scroll(-speed,0);
				//	image.x -=speed
					break;
				case Keyboard.RIGHT:
					texture.scroll(speed,0);
					//image.x +=speed
					break;


				
			}
		}

		
			
	}
}