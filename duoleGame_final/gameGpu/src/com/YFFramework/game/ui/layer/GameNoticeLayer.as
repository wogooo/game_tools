package com.YFFramework.game.ui.layer
{
	/**@author yefeng
	 * 2013 2013-3-20 下午7:03:16 
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.graphic.ShapeMovieClip;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.dolo.ui.tools.EnterFrameMove;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	/** 文字提示 
	 */	
	public class GameNoticeLayer extends AbsView{
		
		public static var textSize:int = 17;
		public static var space:int = 9;
		public static var textColor:int = 0xFFFF99;
		public static var bold:Boolean = true;
		protected var showTime:Number = 1.2;
		protected var displayCount:int=3;
		public static var yPosAdd:int = 50;
		private static const OperatorFilter:GlowFilter=new GlowFilter(0x000000,1,2,2,5,1);
		
		private static var _pool:Vector.<TextField>=new Vector.<TextField>();
		private static var showY:int=-1;
		private static var showCount:int = 0;
		
		private var _noticeContainer:Sprite;
		
		public function GameNoticeLayer(){
			super(false);
			this.mouseEnabled = false;
			_noticeContainer=new Sprite;
			addChild(_noticeContainer);
		}
		
		private static function createText(textSize:int,textColor:int):TextField{
			var txt:TextField=new TextField();
			var tf:TextFormat=new TextFormat();
			tf.size=textSize;
			tf.color = textColor;
			tf.bold = bold;
			txt.defaultTextFormat=tf;
			txt.autoSize="left";
			txt.mouseEnabled=false;
			txt.selectable=false;
			return txt;
		}
		
		/**设置操作方面的notice
		 */		
		public function setOperatorNotice(str:String):void{	
			var txt:TextField;
			if(_pool.length>0)	txt=_pool.pop();
			else	txt=createText(textSize,textColor);
			
			txt.htmlText=str;
			txt.width=500;
			txt.width=txt.textWidth+5;
			txt.filters=[OperatorFilter];
			txt.y = 0;
			var sp:Sprite =new Sprite();
			sp.addChild(txt);
			sp.mouseChildren=false;
			sp.mouseEnabled=false;
			var len:int=_noticeContainer.numChildren;
			for(var i:int=0;i<len;i++){
				new EnterFrameMove(_noticeContainer.getChildAt(i),-1.5,textSize+space);
			}
			_noticeContainer.addChild(sp);
			PopUpManager.centerPopUp(sp);
			sp.y = getFirstPos();
			
			showCount ++;
			txt.alpha = 0.5;
			if(_noticeContainer.numChildren>displayCount)	_noticeContainer.removeChildAt(0);
			TweenLite.to(txt,0.45,{alpha:1,y:txt.y-25,ease:Cubic.easeOut,onComplete:completeOperator,onCompleteParams:[txt]});
		}
		
		
		/**鼠标双击地面取消自动寻路
		 */
		public function setClickNotice(str:String,mX:Number,mY:Number):void
		{
//			print(this,"双击取消自动寻路..待做？？");
			var txt:TextField=createText(12,0xFFFF00);
			txt.text="双击取消自动寻路";
			txt.x=mX+10;
			txt.y=mY;
			txt.filters=[OperatorFilter];
			if(txt.x+txt.textWidth>StageProxy.Instance.getWidth()) txt.x=mX-txt.textWidth-15;
			addChild(txt);
			txt.mouseEnabled=false;
			TweenLite.to(txt,1.1,{y:mY-100,alpha:0.3,onComplete:clickComplete,onCompleteParams:[txt],ease:Linear.easeIn});
			
		}
		private function clickComplete(txt:TextField):void
		{
			if(contains(txt))removeChild(txt);
		}
			
		
		protected function getFirstPos():int{
			var num:int = int(StageProxy.Instance.getHeight()/2)+yPosAdd;
			if(num > StageProxy.Instance.getHeight() - textSize*3){
				num = StageProxy.Instance.getHeight() - textSize*3;
			}
			return num;
		}
		
		private function completeOperator(txt:TextField):void{
			setTimeout(moveOut,showTime*1000,txt);
		}
		
		private function moveOut(txt:TextField):void{
			TweenLite.to(txt,0.7,{alpha:0,y:txt.y-30,onComplete:completeTween,onCompleteParams:[txt],ease:Cubic.easeOut,delay:0.5});
		}
		
		private function completeTween(txt:TextField):void{
			var sp:Sprite = txt.parent as Sprite;
			if(sp&&sp.parent)  sp.parent.removeChild(sp);
			txt.filters=[];
			txt.text="";
			txt.alpha=1;
			_pool.push(txt);
		}

		/**单纯的播放特效
		 * positionX  positionY  动画的位置  是世界地图坐标  mapX  mapY
		 * @param loop  该特效是否 循环播放     一般人物待机 时需要
		 * @param timesArr   特效时间轴
		 * @param completeFunc 每次特效播放完之后调用
		 * @param completeParam	参数
		 * @param totalTimes   特效播放的时间   这个这间之后 将移除特效   不管是否处于循环播放状态 所以 当是循环播放时  需要将 值 设为很大     
		 */
		public function playCommonEffect(actionData:ActionData,loop:Boolean=false):void{
//			var movie:ShapeMovieClip=new ShapeMovieClip();
//			LayerManager.NoticeLayer.addChild(movie);
//			centerUpCommonEffect(movie);
//			movie.initData(actionData);
//			movie.start();
//			movie.playDefault(loop,playComplete,movie,true);
			var movie:ShapeMovieClip=playEffect(actionData,loop);
			centerUpCommonEffect(movie);
		}
		/**播放特效
		 */
		public function playEffect(actionData:ActionData,loop:Boolean=false,x:Number=0,y:Number=0):ShapeMovieClip
		{
			var movie:ShapeMovieClip=new ShapeMovieClip();
			LayerManager.NoticeLayer.addChild(movie);
			movie.initData(actionData);
			movie.start();
			movie.playDefault(loop,playComplete,movie,true);
			movie.x=x;
			movie.y=y;
			return movie;
		}

		
		
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void{
			var movie:ShapeMovieClip=data as ShapeMovieClip;
			if(LayerManager.NoticeLayer.contains(movie))	LayerManager.NoticeLayer.removeChild(movie);
			movie.dispose();
		}
		
		/**向上居中 普通效果
		 */
		private function centerUpCommonEffect(obj:DisplayObject):void{
			obj.x=StageProxy.Instance.getWidth()*0.5;
			obj.y=StageProxy.Instance.getHeight()*0.5-100;
		}
	}
}