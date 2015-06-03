package com.YFFramework.core.ui.yfComponent
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**  管理窗口弹出
	 * @author yefeng
	 *2012-4-20下午9:49:04
	 */
	public class PopUpManager
	{
		/**模态的 宽高
		 */		
		private static const ModalWidth:int=3000;
		private static const ModalHeight:int=3000;
		private static var dict:Dictionary;
		private static var _clickdict:Dictionary;
		private static var _clickParamdict:Dictionary;
		private static var PopLayer:Sprite; 
		public function PopUpManager() 
		{
		}
		
		public static function initPopUpManager(popLayer:Sprite):void
		{
			dict=new Dictionary();
			_clickdict=new Dictionary();
			_clickParamdict=new Dictionary();
			PopLayer=popLayer;
		}
		
		/** 设置为模态窗口 则给 modalColor传上颜色值即可， 不设置为模态窗口 则将模态值设为负数即可
		 * lightBg单击背景 背景是否发生闪烁
		 */
		public static function addPopUp(display:DisplayObject,parent:Sprite=null,x:Number=0,y:Number=0,modelColor:int=-1,alpha:Number=0,clickCall:Function=null,param:Object=null,modelHole:Rectangle=null,lightBg:Boolean=true):void 
		{
			display.x=x;
			display.y=y;
			if(parent==null) parent=PopLayer;
			//单击时 背景是否发生闪烁 
			addObj(display,parent,modelColor,alpha,clickCall,param,modelHole,lightBg);
		}
		
		/**居中对象
		 */		
		public static function centerPopUp(display:DisplayObject):void
		{
			display.x = (StageProxy.Instance.stage.stageWidth - display.width) * 0.5;
			display.y = (StageProxy.Instance.stage.stageHeight-display.height) * 0.5;
		}
		public static function centerPopUpWidthWH(display:DisplayObject,w:Number,h:Number):void
		{
			display.x = (StageProxy.Instance.stage.stageWidth - w) * 0.5;
			display.y = (StageProxy.Instance.stage.stageHeight-h) * 0.5;
		}
		/**向中下居中
		 */		
		public static function centerDownPopUp(display:DisplayObject):void
		{
			
			display.x = (StageProxy.Instance.stage.stageWidth - display.width) * 0.5;
			display.y = StageProxy.Instance.stage.stageHeight-130;
		}
		
		
		public static function contains(display:DisplayObject):Boolean
		{
			return dict[display]?true:false;
		}
		
		public static function removePopUp(obj:DisplayObject):void
		{
			if(contains(obj))
			{
				var sp:PopUpSprite=dict[obj];
				sp.removeEventListener(MouseEvent.CLICK,onSpClick);
				//			if(sp.contains(obj))sp.removeChild(obj);
				if(obj.parent)obj.parent.removeChild(obj)
				if(sp.parent)sp.parent.removeChild(sp);
				sp.dispose();
				sp=null;
				delete dict[obj];
				delete _clickdict[obj];
				delete _clickParamdict[obj];
			}
		}
		/**		给对象进行挖洞      displayObject对象 是动画引导层 不具备鼠标交互    但是popUp层又具备鼠标交互功能  所以 displayObject不能放在鼠标交互曾 只能放到disable层但是模态框 必须放到 pop层来挡住鼠标响应 
		 * lightBg单击背景 背景是否发生闪烁
		 * 
		 */		
		private static function addObj(obj:DisplayObject,parent:Sprite,modelColor:int,alpha:Number,clickCall:Function,param:Object,modelHole:Rectangle=null,lightBg:Boolean=true):void
		{
			var sp:PopUpSprite

			if(!contains(obj))
			{
				sp=new PopUpSprite(lightBg);
				sp.addChild(obj);
				parent.addChild(sp);
				dict[obj]=sp;
				if(clickCall!=null)sp.addEventListener(MouseEvent.CLICK,onSpClick);
			}
			else 
			{
				sp=dict[obj];
				sp.addChild(obj);
				parent.addChild(sp);
			}
			sp.display=obj;
			_clickdict[obj]=clickCall;
			_clickParamdict[obj]=param;
			if(modelColor>-1)
			{
				if(!modelHole) //不进行挖洞
				{
					Draw.DrawRect(sp.getMask().graphics, ModalWidth, ModalHeight,modelColor,alpha,-200,-200);
					sp.bottomMask()
				}
				else //挖洞 
				{
					sp.getMask().graphics.clear();  
					sp.getMask().graphics.beginFill(modelColor,alpha);
					sp.getMask().graphics.drawRect(-200,-200,ModalWidth,ModalHeight); 
					sp.getMask().graphics.drawRect(modelHole.x,modelHole.y,modelHole.width,modelHole.height); //挖洞
					sp.getMask().graphics.endFill();
//					sp.topMask();
					// 将 遮罩 放到  pop层 
					PopLayer.addChild(sp);
					parent.addChild(obj);  // obj放 parent不具有交互性的一层 也就是游戏的newGuide层
//					sp.x=obj.x;
//					sp.y=obj.y;
				}
			}

		}
		private static function onSpClick(e:MouseEvent):void	
		{
			var sp:PopUpSprite=e.currentTarget as PopUpSprite;
			var obj:DisplayObject=sp.getContent();
			if(obj)
			{
				if(_clickdict[obj]!=null)_clickdict[obj](_clickParamdict[obj]);
			}
		}
	}
}