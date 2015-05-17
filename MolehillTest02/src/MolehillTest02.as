package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import gpu2d.core.GEventCenter;
	import gpu2d.core.Gpu2d;
	import gpu2d.display.GDisplayObject;
	import gpu2d.display.GImage;
	import gpu2d.display.GSprite;
	import gpu2d.events.GEvent;
	import gpu2d.events.GMouseEvent;
	
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-21 下午03:44:38
	 */
	[SWF(width="800",height="600",background="#336699")]
	public class MolehillTest02 extends Sprite
	{
		[Embed(source="molepeople128.jpg")]
		private  var BMD:Class;
		private var bmp:Bitmap;
		
		private  var image:GImage;
		private  var image2:GImage;
		
		private var text:TextField;
		private var container:GSprite;
		public function MolehillTest02()
		{
			init();
		}
		
		private function init():void
		{
				
			trace('STAGE:',stage)
			text=new TextField();
			text.width=500
			text.height=2000
			text.text="测试::"
			addChild(text);
			addChild(new Stats());
			text.mouseEnabled=false
			bmp=new BMD() as Bitmap;
			bmp.x=300
			//addChild(bmp)
				
				
				
			Gpu2d.Instance.initData(stage,800,600,0x336699);
			GEventCenter.Instance.addEventListener(GEvent.CONTEXT_CREATE,onCreate);
		}
		private	function onCreate(e:GEvent):void
		{
			container=new GSprite();
			image=new GImage(bmp.bitmapData,512,512);
			image.x=image.y=100
/*			image.scaleX=image.scaleY=0.5;
*/		//  Gpu2d.Instance.addRootContainer(image);
			container.addChild(image);
			trace("width,height:",image.width,image.height)
			image2=new GImage(bmp.bitmapData,256,256);
			//  image2.visible=false;
			container.addChild(image2);
			
			//Gpu2d.Instance.addRootContainer(image2);
		//	image2.scaleX=image2.scaleY=0.5
/*			container.pivotX=400
			container.pivotY=200;
*/			
			trace(container.width,container.height,"--1")
			//container.scaleY=container.scaleX=0.5
			container.x=container.y=100
			trace(container.width,container.height,"--2")
			
	//	container.scaleX=container.scaleY=0.5;
			//container2.x +=200
			//	container2.y +=200
/*			container.pivotX=image2.width*0.5;
			container.pivotY=image2.height*0.5;
*/			
/*			image2.alpha=.3;
			image2.scaleX=image2.scaleY=0.3
			image2.pivotX=image2.width*0.5
			image2.pivotY=image2.height*0.5
*/			//image2.rotation=30;
			image2.name="image2";
			image2.alpha=1
			//image2.visible=false
			//container.rotation=30
			container.addEventListener(GMouseEvent.MOUSE_DOWN,onGMouseEvent);
			container.addEventListener(GMouseEvent.MOUSE_UP,onGMouseEvent);
			//image2.addEventListener(GMouseEvent.MOUSE_MOVE,onGMouseEvent);
			container.addEventListener(GMouseEvent.CLICK,onGMouseEvent);
			container.addEventListener(GMouseEvent.MOUSE_OVER,onGMouseEvent);
			container.addEventListener(GMouseEvent.MOUSE_OUT,onGMouseEvent);
			Gpu2d.Instance.addRootContainer(container);
			
			var image3:GImage
			for(var i:int=0;i<500;++i)
			{
				image3=new GImage(bmp.bitmapData,128,128);
				image3.x =Math.random()*stage.stageWidth
				image3.y =Math.random()*stage.stageHeight
					
			//	container.addChild(image3);
			Gpu2d.Instance.addRootContainer(image3);

			}
			
			addEventListener(Event.ENTER_FRAME,update)
			
		//	Gpu2d.Instance.render();
		}
		private function update(e:Event):void
		{
			//image.rotation++;

		//	container.rotation++;
			//	trace("rotation:",image2.rotation)
			//image2.rotation++;
		//	var num:int=container.numChildren;
		//	var child:GDisplayObject;
/*		for(var i:int=0;i!=num;++i)
			{
				child=container.getChildAt(i);
			//	child.x += 2
				//child.y +=3;
			//	child.rotation +=20*Math.random();
				//if(child.x>stage.stageWidth-child.width)  child.x=0;
			//	if(child.y>stage.stageHeight-child.height) child.y=0
			}
*/		Gpu2d.Instance.render();
		
		

		}
		
		private var index:int=0
		private function onGMouseEvent(e:GMouseEvent):void
		{
			//trace("x,y,target,currentTarget,handler,name::",e.type,e.localX,e.localY,e.target,e.currentTarget,e.handler,e.handler.name)
			
			text.appendText("click----"+e.type+index+"\n");
			index++;
			
			switch(e.type)
			{
				case GMouseEvent.MOUSE_DOWN:
					break;
				case GMouseEvent.MOUSE_UP:
			}
			
		}
	}
}