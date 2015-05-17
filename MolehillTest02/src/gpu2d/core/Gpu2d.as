package gpu2d.core
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import gpu2d.display.GDisplayObject;
	import gpu2d.display.GQuad;
	import gpu2d.display.GStage;
	import gpu2d.errors.SingletonError;
	import gpu2d.events.GEvent;
	import gpu2d.events.GMouseEvent;
	import gpu2d.utils.Color;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:28:54
	 */
	public final class Gpu2d
	{
		public var context3d:Context3D;
		private static var _instance:Gpu2d;
		private var gStage:GStage;
		private var stage:Stage;
		private var r:Number;
		private var g:Number;
		private var b:Number;
		private var stageWidth:Number;
		private var stageHeight:Number;
		public function Gpu2d()
		{
			if(_instance) throw new SingletonError();
		}
		public static function get Instance():Gpu2d
		{
			if(!_instance) _instance=new Gpu2d();
			return _instance;
		}
		
		public function initData(stage:Stage,stageWidth:Number,stageHeight:Number,bgColor:uint=0xFFFFFF):void
		{
			GRenderSupport.Instance.configureWH(stageWidth,stageHeight);
			this.stage=stage;
			this.stageWidth=stageWidth;
			this.stageHeight=stageHeight
			r=Color.getRed(bgColor)/255;
			g=Color.getGreen(bgColor)/255;
			b=Color.getBlue(bgColor)/255;
			initContext();
			configureStage();
		}
		
		public function addRootContainer(container:GDisplayObject):void
		{
			gStage.addChild(container);
		}
		
		private function initContext():void
		{
			gStage=new GStage();
			var stage3d:Stage3D=stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
			stage3d.addEventListener(ErrorEvent.ERROR,onContextError);
			stage3d.requestContext3D();
		}
		private function onContextError(e:ErrorEvent):void
		{
			/////  text  需要书写 
			trace('context3d请求失败 ，请检查 html有 wmode="direct" 这一项,假如存在这一项还有错误，可能是您的驱动版本太低，建议升级驱动');
		}
		private function onContextRequest(e:Event):void
		{
			var stage3d:Stage3D=e.currentTarget as Stage3D;
			gStage.x=stage3d.x;
			gStage.y=stage3d.y;
			context3d=stage3d.context3D;
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
			stage3d.removeEventListener(ErrorEvent.ERROR,onContextError);
			if(context3d==null) throw new Error("您的计算机部支持硬件加速,请您升级驱动");
			
			context3d.enableErrorChecking=false; ////
		//	if(context3d.enableErrorChecking) trace("该属性待取消，这个属性只在调试的时候用");
			context3d.configureBackBuffer(stageWidth,stageHeight,4);
			context3d.setCulling(Context3DTriangleFace.NONE); ///剔除的部分  表示不进行剔除
			context3d.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);  ////设置alpha值
			regProgram();
			VertexData.Instance.initContext(context3d);
		//	addEvent();
			
			GEventCenter.Instance.dispatchEvent(new GEvent(GEvent.CONTEXT_CREATE));
		}
		
		private function configureStage():void
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
		}
		////  所有的program 创建
		private function regProgram():void
		{
			GQuad.regProgramRGB();  // rgb 类型的 program     不带alpha 的program

		}
		
		public function render():void
		{
			context3d.clear(r,g,b);
			gStage.render();
		//	context3d.drawTriangles(VertexData.Instance.indexBuffer, 0, GQuad.FaceNum);
			
			context3d.present();
		}
		
		private function addEvent():void
		{
			stage.addEventListener(MouseEvent.CLICK,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseEvent);
		}
		
		private var currentTarget:GDisplayObject;
		private var mouseDownObj:GDisplayObject;
		private var mouseUpObj:GDisplayObject;
		private function handleMouseEvent(e:MouseEvent):void
		{
			var stagePoint:Point=new Point(stage.mouseX-gStage.x,stage.mouseY-gStage.y);
			var obj:GDisplayObject=gStage.hitTestPoint(stagePoint);
			if(obj==null&&currentTarget)
			{
				event=new GMouseEvent(GMouseEvent.MOUSE_OUT,currentTarget,true);
				event.stageX=stagePoint.x;
				event.stageY=stagePoint.y;
				currentTarget.dispatchEvent(event);
				currentTarget=null;
				return ;
			}
			if(!(obj&&obj.mouseEnable)) return ;
			var localPoint:Point=obj.globalToLocal(stagePoint);
			var event:GMouseEvent;
			switch(e.type)
			{
				case MouseEvent.CLICK:
					if(mouseDownObj==mouseUpObj&&mouseDownObj)
					{
						event=new GMouseEvent(GMouseEvent.CLICK,obj,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						mouseDownObj.dispatchEvent(event);
					}
					break;
				case MouseEvent.MOUSE_DOWN:
						event=new GMouseEvent(GMouseEvent.MOUSE_DOWN,obj,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						obj.dispatchEvent(event);
						mouseDownObj=obj;
					break;
				case MouseEvent.MOUSE_UP:
						event=new GMouseEvent(GMouseEvent.MOUSE_UP,obj,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						obj.dispatchEvent(event);
						mouseUpObj=obj;
					break;
				case MouseEvent.MOUSE_MOVE:
					event=new GMouseEvent(GMouseEvent.MOUSE_MOVE,obj,true,localPoint.x,localPoint.y);
					event.stageX=stagePoint.x;
					event.stageY=stagePoint.y;
					obj.dispatchEvent(event);

					////创建 mouseOver   mouseOut事件
					if(!currentTarget)
					{
						currentTarget=obj;
						event=new GMouseEvent(GMouseEvent.MOUSE_OVER,currentTarget,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						currentTarget.dispatchEvent(event);
						return ;
					}
					else if (currentTarget!=obj)
					{
						event=new GMouseEvent(GMouseEvent.MOUSE_OUT,currentTarget,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						currentTarget.dispatchEvent(event);
						
						event=new GMouseEvent(GMouseEvent.MOUSE_OVER,currentTarget,true,localPoint.x,localPoint.y);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						obj.dispatchEvent(event);
						currentTarget=obj;
						return ;
					}
					break;
				default:
					return ;
					break;
			}

		}
		
	}
}