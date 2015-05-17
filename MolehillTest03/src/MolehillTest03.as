package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import yf2d.core.YF2d;
	import yf2d.display.Image;
	import yf2d.display.Scence2D;
	import yf2d.display.SpriteBatch;
	import yf2d.events.YF2dEvent;
	import yf2d.events.YFMouseEvent;
	import yf2d.textures.batch.AtlasData;
	import yf2d.textures.batch.TextureAnimate;
	import yf2d.textures.TextureHelper;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-25 下午02:05:48
	 */
	[SWF(width="800",height="600")]
	public class MolehillTest03 extends Sprite
	{
		
		//[Embed(source="molepeople128.jpg")]
	//	[Embed(source="P25_25.jpg")]
	//	[Embed(source="100.png")]
		
		[Embed(source="spritechar2.png")]   // 72  128
		private  var BMD:Class;		
		private var bmpData:BitmapData;
		private var image:Image;
		private var num:int=2
		private var text:TextField;
		private var texture:TextureAnimate
		private var scence:Scence2D;
		private var atlasData:AtlasData;
		private var sprite2d:SpriteBatch;
		private var arr:Vector.<Image>
		public function MolehillTest03()
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
			atlasData=new AtlasData(2048,2048);  ///这里必须为true 
			var bmp:Bitmap=new BMD() as Bitmap;  //对象必须支持透明通道
			var textureData:BitmapData=bmp.bitmapData
			texture=new TextureAnimate(atlasData);         
			texture.copyData(textureData,new Rectangle(0,0,textureData.width,textureData.height),new Point(0,0));
			
			
			var source2:BitmapData=new BitmapData(100,100,false,0x00FF00)
			texture.copyData(source2,new Rectangle(0,0,source2.width,source2.height),new Point(100,0));
			
			var myTexture:Texture=TextureHelper.Instance.getTexture(atlasData)
			sprite2d=new SpriteBatch(myTexture);
			scence.addChild(sprite2d);
			
	//		addChild(new Bitmap(atlasData));
			
			sprite2d.addEventListener(YFMouseEvent.MOUSE_DOWN,onDown)
			arr=new Vector.<Image>();
			

			
			text.text=num+"个对象";

			//addChild(new Bitmap(atlasData));
			sprite2d.x=300
			sprite2d.y=300
				
				
			for(var i:int=0;i!=num;++i)
			{
				addImage();				
			}

			texture.setFrame(0);
			trace("uvdata:",texture.getUVData())

		}
		private function onDown(e:YFMouseEvent):void
		{
			trace("OK")
		}
		private function addEvent():void
		{
			addEventListener(Event.ENTER_FRAME,onFrame)
		}
			
		private var index:int=0;
		private var  time:Number=0;
		private function onFrame(e:Event):void
		{
			for(var i:int=0;i!=num;++i)
			{
				//arr[i].rotationZ	+=2;
			}
			
			YF2d.Instance.render();
			
			
/*	var t:Number=getTimer();
		
			if(t-time>1000)
			{
				++index;
				texture.setFrame(index%2);
				time=t;
			}
*/		}
		
		
		private var offest:int=200
		private function addImage():void
		{
			image=new Image(texture);
/*			image.x=Math.random()*stage.stageWidth;
			image.y=Math.random()*stage.stageHeight;
*/			
/*			image.x=200
			image.y=200
*/
			sprite2d.addChild(image);
			image.x =offest
				image.y =offest
			if(offest==210) image.alpha=0.5;
					offest +=10

			arr.push(image);
			trace(image.x,sprite2d.getBounds(scence));
			trace(image.name)
		}
		
	}
}