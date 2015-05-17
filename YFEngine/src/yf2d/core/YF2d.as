package yf2d.core
{
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	
	import yf2d.display.AbsSprite2D;
	import yf2d.display.Scence2D;
	import yf2d.material.Sprite2DMaterial;

	/**
	 *  优化 ：texture 不用时 则即时dispose 只保存BitmapData 用时在生成Textue 因为Texture的数量有限制
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:28:54
	 */
	public final class YF2d
	{
		public var scence:Scence2D;

		private var context3d:Context3D;
//		private static var _instance:YF2d;
//		private var stage:Stage;
//		private var _stage3d:Stage3D;		
//		private var r:Number;
//		private var g:Number;
//		private var b:Number;
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var shader2d:Sprite2DMaterial;
//		private var interaction:Interaction;
//		private var _materialId:int; /// 1表示渲染  BatchMaterial  2 表示渲染 Sprite2D
		public function YF2d()
		{
		}
		public function initData(stage3d:Stage3D,stagewidth:int,stageHeight:int):void
		{
			context3d=stage3d.context3D;
//			this._stage3d=stage3d;
			this.stageWidth=stageWidth;
			this.stageHeight=stageHeight;
			scence=new Scence2D();
			
			scence.x=stage3d.x;                  
			scence.y=stage3d.y;
//			resizeScence(stage.stageWidth,stage.stageHeight);
//			context3d.setDepthTest(true, Context3DCompareMode.ALWAYS);   /////这句很重要 是解决深度关系 
			//context3d.setCulling(Context3DTriangleFace.NONE); ///剔除的部分  表示不进行剔除
//			setCulling(Context3DTriangleFace.BACK);
//			context3d.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);  ////设置alpha值
			shader2d=new Sprite2DMaterial(stage3d.context3D);
//			TextureHelper.Instance.initData(context3d);//初始化材质生成器
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
		
		
//		private function initContext():void
//		{
////			var stage3d:Stage3D=stage.stage3Ds[0];
////			stage3d.addEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
////			stage3d.addEventListener(ErrorEvent.ERROR,onContextError);
////			stage3d.requestContext3D();
//		}
//		private function onContextError(e:ErrorEvent):void
//		{
//			/////  text  需要书写 
//			//trace('context3d请求失败 ，请检查 html有 wmode="direct" 这一项,假如存在这一项还有错误，可能是您的驱动版本太低，建议升级驱动');
//			var errorInfo:String='context3d请求失败 ，请检查 html有 wmode="direct" 这一项,假如存在这一项还有错误，可能是您的驱动版本太低，建议升级驱动';
//			trace(errorInfo)
//			var text:TextField=new TextField();
//			stage.addChild(text);
//			text.text=errorInfo;
//			text.width=500;
//			text.textColor=0xFF0000;
//			text.autoSize="left";
//			text.background=true;
//			text.backgroundColor=0x000000;
//			text.x=(stage.stageWidth-text.textWidth)*0.5;
//			text.y=(stage.stageHeight-text.textHeight)*0.5;
//		}
		private function onContextRequest(e:Event):void
		{
//			var stage3d:Stage3D=e.currentTarget as Stage3D;
//			context3d=stage3d.context3D;
//			stage3d.removeEventListener(Event.CONTEXT3D_CREATE,onContextRequest);
//			stage3d.removeEventListener(ErrorEvent.ERROR,onContextError);
//			if(context3d==null) throw new Error("您的计算机不支持硬件加速,请您升级驱动");
//			//context3d.enableErrorChecking=false; ////
//			context3DErrorChecking=false
			//if(context3d.enableErrorChecking) trace("该属性待取消，这个属性只在调试的时候用");
//			scence.x=stage3d.x;                  
//			scence.y=stage3d.y;
//			resizeScence(stage.stageWidth,stage.stageHeight);
//			context3d.setDepthTest(true, Context3DCompareMode.ALWAYS);   /////这句很重要 是解决深度关系 
//			//context3d.setCulling(Context3DTriangleFace.NONE); ///剔除的部分  表示不进行剔除
//			setCulling(Context3DTriangleFace.BACK);
//			context3d.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);  ////设置alpha值
//			shader2d=new Sprite2DMaterial(context3d);
//			TextureHelper.Instance.initData(context3d);//初始化材质生成器
//			scence.dispatchEventWith(YF2dEvent.CONTEXT_CREATE);
		}
		
		/**  
		 * @param antiAlias  的值 最好不要超过 4 一般取2就可以了  要求更高 可以取4
		 * 
		 * 一般resize时朝较小的 尺寸时比较好   就是比初始的resize小比较好 假如比初始的size大的话当屏幕太大 有可能会卡屏   具体 设置 应该遵循  初始程序swf是大尺寸的 这样可以rezie到小尺寸  然后又可以reize到初始尺寸 
		 * 这样比较好 也就是 resize后的的尺寸 必须小于等于初始尺寸比较好  这样做也是为了防止意外卡屏   
		 */		
//		public function  resizeScence(stageWidth:Number,stageHeight:Number):void
//		{
//			ScenceProxy.Instance.initScence(scence.x,scence.y,stageWidth,stageHeight);///设置渲染大小
//		}
		
		
		/**保存30帧频率
		 */		
		public function render():void
		{
			shader2d.setYF2DMaterial();
			scence.render(context3d,shader2d);  
			AbsSprite2D.clearYF2dData(context3d);
		}
	}
}