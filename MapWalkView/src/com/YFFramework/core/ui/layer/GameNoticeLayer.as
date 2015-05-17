package com.YFFramework.core.ui.layer
{
	/**@author yefeng
	 * 2013 2013-3-20 下午7:03:16 
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/** 文字提示 
	 */	
	public class GameNoticeLayer extends AbsView
	{
		
		private static const OperatorFilter:GlowFilter=new GlowFilter(0x9999FF,1,6,6);
		
		private static var _pool:Vector.<TextField>=new Vector.<TextField>();
		public function GameNoticeLayer()
		{
			super(false);
		}
		
		private static function creeateText():TextField
		{
			var txt:TextField=new TextField();
			var tf:TextFormat=new TextFormat();
			tf.size=30;
			txt.defaultTextFormat=tf;
			txt.autoSize="left";
			return txt;
		}
		
		/**设置操作方面的notice
		 */		
		public function setOperatorNotice(str:String):void
		{	
			var txt:TextField;
			if(_pool.length>0)
				txt=_pool.pop();
			else     
				txt=creeateText();
			
			txt.text=str;
			txt.width=500;
			txt.width=txt.textWidth;
			txt.filters=[OperatorFilter];
			addChild(txt);
			PopUpManager.centerPopUp(txt);
			txt.y=StageProxy.Instance.getHeight();
			TweenLite.to(txt,1,{y:StageProxy.Instance.getHeight()-160,ease:Linear.easeInOut,onComplete:completeOperator,onCompleteParams:[txt]});
		}
		 
		private function completeOperator(txt:TextField):void
		{
			TweenLite.to(txt,1.3,{alpha:0,y:StageProxy.Instance.getHeight()-260,onComplete:completeTween,onCompleteParams:[txt],ease:Linear.easeIn,delay:0.5});
		}
		private function completeTween(txt:TextField):void
		{
			removeChild(txt);
			txt.filters=[];
			txt.text="";
			txt.alpha=1;
			_pool.push(txt);
		}
	}
}