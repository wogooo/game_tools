package yf2d.core
{
	import com.YFFramework.core.debug.print;
	
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import yf2d.display.Scence2D;
	import yf2d.events.YF2dEvent;
	import yf2d.material.AbsMaterial;
	import yf2d.material.BatchMaterial;
	import yf2d.material.Sprite2DMaterial;
	import yf2d.textures.TextureHelper;
	import yf2d.utils.Color;

	/**
	 *  优化 ：texture 不用时 则即时dispose 只保存BitmapData 用时在生成Textue 因为Texture的数量有限制
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:28:54
	 */
	public final class YF2d
	{
		public var scence:Scence2D;

		private var context3d:Context3D;
		private static var _instance:YF2d;
		private var stage:Stage;
		private var r:Number;
		private var g:Number;
		private var b:Number;
//		private var stageWidth:Number;
//		private var stageHeight:Number;
		private var shader2d:AbsMaterial;
		private var interaction:Interaction;
		private var _materialId:int; /// 1表示渲染  BatchMaterial  2 表示渲染 Sprite2D
		public function YF2d()
		{
			scence=new Scence2D();
		}
		public static function get Instance():YF2d
		{
			if(!_instance) _instance=new YF2d();
			return _instance;
		}
		public function getDriverInfo():String
		{
			return context3d.driverInfo;
		}
		
		public function initData(stage:Stage,bgColor:uint=0xFFFFFF,materialId:int=1):void
		{
			this.stage=stage;
//			this.stageWidth=stageWidth;
//			this.stageHeight=stageHeight;
			r=Color.getRed(bgColor)/255;
			g=Color.getGreen(bgColor)/255;
			b=Color.getBlue(bgColor)/255;
			_materialId=materialId;
			initContext();
			configureStage(); 
			interaction=new Interaction()
		}
		/** 响应鼠标事件
		 * @param stagePoint
		 * @param dict  响应鼠标事件的数组
		 * @param e  鼠标事件
		 */		
//		public function updateMouseHandle(stagePoint:Point,dict:Array,e:MouseEvent):void
//		{
//			interaction.mouseHandle(stagePoint,dict,e);
//		}
		
		
		private function initContext():void
		{
			var stage3d:Stage3D=stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
			stage3d.addEventListener(ErrorEvent.ERROR,onContextError);
			stage3d.requestContext3D(Context3DRenderMode.AUTO);
		}
		private function onContextError(e:ErrorEvent):void
		{
			/////  text  需要书写 
			//trace('context3d请求失败 ，请检查 html有 wmode="direct" 这一项,假如存在这一项还有错误，可能是您的驱动版本太低，建议升级驱动');
			var errorInfo:String='context3d请求失败 ，请检查 html有 wmode="direct" 这一项,假如存在这一项还有错误，可能是您的驱动版本太低，建议升级驱动';
			trace(errorInfo)
			var text:TextField=new TextField();
			stage.addChild(text);
			text.text=errorInfo;
			text.width=500;
			text.textColor=0xFF0000;
			text.autoSize="left";
			text.background=true;
			text.backgroundColor=0x000000;
			text.x=(stage.stageWidth-text.textWidth)*0.5;
			text.y=(stage.stageHeight-text.textHeight)*0.5;
			
			
		}
		private function onContextRequest(e:Event):void
		{
			var stage3d:Stage3D=e.currentTarget as Stage3D;
			if(context3d)context3d.dispose(); ///如果多次请求，释放前一次的资源
			context3d=stage3d.context3D;
//			stage3d.removeEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
//			stage3d.removeEventListener(ErrorEvent.ERROR,onContextError);
			print(this,"此处没有移除消息侦听,因为有可能多次请求");
			if(context3d==null) throw new Error("您的计算机不支持硬件加速,请您升级驱动");
			//context3d.enableErrorChecking=false; ////
			context3DErrorChecking=false
			//if(context3d.enableErrorChecking) trace("该属性待取消，这个属性只在调试的时候用");
			scence.x=stage3d.x;                  
			scence.y=stage3d.y;
			resizeScence(stage.stageWidth,stage.stageHeight);
			context3d.setDepthTest(true, Context3DCompareMode.ALWAYS);   /////这句很重要 是解决深度关系 
			//context3d.setCulling(Context3DTriangleFace.NONE); ///剔除的部分  表示不进行剔除
			setCulling(Context3DTriangleFace.BACK);
			context3d.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);  ////设置alpha值
			if(_materialId==1)shader2d=new BatchMaterial(context3d);
			else if(_materialId==2)shader2d=new Sprite2DMaterial(context3d);
			TextureHelper.Instance.initData(context3d);//初始化材质生成器
			scence.dispatchEventWith(YF2dEvent.CONTEXT_CREATE);
		}
		
		/**  
		 * @param antiAlias  的值 最好不要超过 4 一般取2就可以了  要求更高 可以取4
		 * 
		 * 一般resize时朝较小的 尺寸时比较好   就是比初始的resize小比较好 假如比初始的size大的话当屏幕太大 有可能会卡屏   具体 设置 应该遵循  初始程序swf是大尺寸的 这样可以rezie到小尺寸  然后又可以reize到初始尺寸 
		 * 这样比较好 也就是 resize后的的尺寸 必须小于等于初始尺寸比较好  这样做也是为了防止意外卡屏   
		 */		
		public function  resizeScence(stageWidth:Number,stageHeight:Number,antiAlias:int=2):void
		{
			ScenceProxy.Instance.initScence(scence.x,scence.y,stageWidth,stageHeight);///设置渲染大小
			context3d.configureBackBuffer(stageWidth,stageHeight,antiAlias);   ///设置渲染大小
		}
		
		private function configureStage():void
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
		}
		
		/**保存30帧频率
		 */		
		public function render():void
		{
			context3d.clear(r,g,b);
			scence.render(context3d,shader2d);  
			context3d.present();
		}
		
		public function set context3DErrorChecking(value:Boolean):void{		context3d.enableErrorChecking=value; 		}
		
		/**
		 * @param triangleFaceToCull  the culling mode. One of Context3DTriangleFace.   
		 * 默认值时 Context3DTriangleFace.BACK   当对象旋转到反面时  请将 triangleFaceToCull值设为 Context3DTriangleFace.NONE  当无旋转对象时 最好设置为back
		 */
		public function setCulling(triangleFaceToCull:String):void
		{
			context3d.setCulling(triangleFaceToCull);
		}
	}
}