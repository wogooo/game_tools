package com.YFFramework.core.yf2d.core
{
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.yf2d.display.Scence2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.material.Program3DManager;
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.utils.Color;
	
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
	import flash.text.TextField;

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
		private var shader2d:Sprite2DMaterial;
//		private var interaction:Interaction;
		
//		private var _caheTexture:Texture;
		/**保持引用
		 */		
		private var stage3d:Stage3D;
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
		
		public function initData(stage:Stage,bgColor:uint=0xFFFFFF):void
		{
//			YFStageProxy.Instance.initStage(stage);
			this.stage=stage;
			r=Color.getRed(bgColor)/255;
			g=Color.getGreen(bgColor)/255;
			b=Color.getBlue(bgColor)/255;
			initContext();
			configureStage(); 
//			interaction=new Interaction()
		}
		/** 响应鼠标事件
		 * @param stagePoint
		 * @param dict  响应鼠标事件的数组
		 * @param e  鼠标事件
		 */		
		private function initContext():void
		{
			stage3d=stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE,onContextRequest);  ///context3d可能不断重复创建
			stage3d.addEventListener(ErrorEvent.ERROR,onContextError);
			var requestContext3D:Function = stage3d.requestContext3D;
			if (requestContext3D.length == 1) requestContext3D(Context3DRenderMode.AUTO);
			else requestContext3D(Context3DRenderMode.AUTO,"baselineConstrained"); //  /// baseline     baselineConstrained
//			print(this,"requestContext3D长度:"+requestContext3D.length);
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
//			Alert.show("stage3dOk");
			var stage3d:Stage3D=e.currentTarget as Stage3D;
			var _isRecreate:Boolean=false;//是否为重复创建
			if(context3d)  ///重新创建了context3d
			{
				
				context3d.dispose(); ///如果多次请求，释放前一次的资源
				_isRecreate=true;
			}
			context3d=stage3d.context3D;
//			print(this,"此处没有移除消息侦听,因为有可能多次请求");
			if(context3d==null) throw new Error("您的计算机不支持硬件加速,请您升级驱动");
			//context3d.enableErrorChecking=false; ////
			context3DErrorChecking=false
//			scence.x=stage3d.x;                  
//			scence.y=stage3d.y;
			scence.setXY(stage3d.x,stage3d.y);
			resizeScence(stage.stageWidth,stage.stageHeight);
			context3d.setDepthTest(true, Context3DCompareMode.ALWAYS);   /////这句很重要 是解决深度关系 
			setCulling(Context3DTriangleFace.BACK);
 
			 
			context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			//// cache ---
//			_caheTexture=context3d.createTexture(stage.stageWidth,stage.stageHeight,Context3DTextureFormat.BGRA,true);
//			context3d.setRenderToTexture(_caheTexture,true);
			
			//---- 
			Program3DManager.initShader(context3d);

			
			if(shader2d) //释放上一个context的 shader
			{
				shader2d.dispose();
			}
			shader2d=new Sprite2DMaterial(context3d);
			TextureHelper.Instance.initData(context3d);//初始化材质生成器
			//重置材质数量
			TextureNumManager.reset();
			UpdateTT.AnalysseIt=180;
			if(!_isRecreate)   //第一次创建
			{
				scence.dispatchEventWith(YF2dEvent.CONTEXT_First_CREATE);
			}
			else   ///重复创建   材质需要 重新初始化
			{
				scence.dispatchEventWith(YF2dEvent.CONTEXT_Re_CREATE_InitActionData);
				scence.dispatchEventWith(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip);

			}
		}
		 
		public function disposeContext3D():void
		{
			if(context3d)
			{
				if(context3d.driverInfo!="Disposed")
				{
					context3d.dispose();
				}
			}
		}
		
		/**  
		 * @param antiAlias  的值 最好不要超过 4 一般取2就可以了  要求更高 可以取4
		 * 
		 * 一般resize时朝较小的 尺寸时比较好   就是比初始的resize小比较好 假如比初始的size大的话当屏幕太大 有可能会卡屏   具体 设置 应该遵循  初始程序swf是大尺寸的 这样可以rezie到小尺寸  然后又可以reize到初始尺寸 
		 * 这样比较好 也就是 resize后的的尺寸 必须小于等于初始尺寸比较好  这样做也是为了防止意外卡屏   
		 */		
		public function  resizeScence(stageWidth:Number,stageHeight:Number,antiAlias:int=0):void
		{
			if(context3d)
			{
				if(context3d.driverInfo!="Disposed")
				{
					if(stageWidth!=0&&stageHeight!=0)
					{
						ScenceProxy.Instance.initScence(scence.x,scence.y,stageWidth,stageHeight);///设置渲染大小
						context3d.configureBackBuffer(stageWidth,stageHeight,antiAlias);   ///设置渲染大小
					}
				}
			}
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
			if(context3d.driverInfo!="Disposed")
			{
//				context3d.setRenderToBackBuffer(); 
				context3d.clear(r,g,b);
				scence.render(context3d,shader2d);  
				context3d.present();
//				TextureHelper.Instance.update();
			}
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