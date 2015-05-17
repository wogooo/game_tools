package com.YFFramework.game.ui.imageText
{
	import com.YFFramework.core.center.manager.update.TimeLine;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;

	/**文字创建
	 * @author yefeng
	 * 2013 2013-3-29 下午12:03:19 
	 */
	public class ImageUtil
	{
		private static var _instance:ImageUtil;
		public function ImageUtil()
		{
		}
		public static function get Instance():ImageUtil
		{
			if(_instance==null) _instance=new ImageUtil();
			return _instance;
		}
		/**
		 * @param timeArr   血条时间轴   根据 timeArr切割血条
		 * @param bloodNum  总血量 
		 * @param playerX  位置X
		 * @param playerY 位置Y
		 * @param textType  文本类型
		 */		
		public function showBloodEx(timeArr:Array,bloodNum:int,playerX:Number,playerY:Number,textType:int=1,completeFunc:Function=null,completeParam:Object=null):void
		{
			var len:int=timeArr.length;
			var bloodArr:Array=[];
			var blood:int=int(bloodNum/len);
			var bloodleft:int=bloodNum%len;
			var item:int;
			for(var i:int=0;i!=len;++i)
			{
				item=blood;
				if(bloodleft>0)
				{
					item ++;
					bloodleft--;
				}
				bloodArr.push(item);
			}
			
			var timeLine:TimeLine=new TimeLine();
			timeLine.completeFunc=completeFunc;
			timeLine.completeParam=completeParam;
			for(i=0;i!=len;++i)
			{
				timeLine.addWait(timeArr[i]);
				timeLine.addFunc(showBloodInit,{bloodNum:bloodArr[i],playerX:playerX,playerY:playerY,textType:textType},0);
			}
			timeLine.start();
		}
		private function showBloodInit(obj:Object):void
		{
			var bloodNum:int=obj.bloodNum;
			var playerX:Number=obj.playerX;
			var playerY:Number=obj.playerY;
			var textType:int=obj.textType;
			showBlood(bloodNum,playerX,playerY,textType);
		}

		
		
		public function showBlood(bloodNum:int,playerX:Number,playerY:Number,textType:int=1):void
		{
			var ui:AbsView=ImageTextManager.Instance.createNumWidthPre(bloodNum.toString(),textType);
			var ui2:AbsView=new AbsView(false);
			ui2.addChild(ui);
			ui.x=-ui.width*0.5;
			ui.y=-ui.height*0.5;
			LayerManager.FightTextLayer.addChild(ui2);
			ui2.x=playerX;
			ui2.y=playerY;
			ui2.scaleX=0;
			ui2.scaleY=0;
			
			var ty:Number=playerY-160;
			TweenLite.to(ui2,0.3,{y:ty,x:ui2.x+10-Math.random()*20,scaleX:3,scaleY:3,ease:Linear.easeInOut,rotationX:30,onComplete:onBloodComplete1,onCompleteParams:[ui2,playerY]});
		}
		private function onBloodComplete1(ui2:AbsView, ty:Number):void  
		{
			TweenLite.to(ui2,0.2,{y:ty-110-Math.random()*10,scaleX:1,scaleY:1,rotationX:0,ease:Linear.easeInOut,onComplete:onBloodComplete2,onCompleteParams:[ui2,ty]});
		}
		private function onBloodComplete2(ui2:AbsView,ty:Number):void
		{
			TweenLite.to(ui2,0.2,{alpha:0,y:ty-100*Math.random(),x:ui2.x+Math.random()*400-200,ease:Linear.easeInOut,onComplete:onBloodComplete3,onCompleteParams:[ui2]});
		}
		private function onBloodComplete3(ui2:AbsView):void
		{
			LayerManager.FightTextLayer.removeChild(ui2);
			var ui:AbsView=ui2.removeChildAt(0) as AbsView;
			ui.alpha=1;
			ui.dispose();
			ui2.dispose();
			ui2=null;
		}
		/**暴击
		 */		
		public function showCrit(bloodNum:int,playerX:Number,playerY:Number):void
		{
			var ui:AbsView=ImageTextManager.Instance.createNumWidthPre(bloodNum.toString(),1);
			ui.alpha=1;
			var ty:Number=playerY-150;
			ui.x=playerX+5;
			ui.y=ty;
			ui.scaleX=ui.scaleY=5;
			ui.alpha=0;
			LayerManager.FightTextLayer.addChild(ui);
			TweenLite.to(ui,0.4,{x:playerX,y:playerY,scaleX:1,scaleY:1,alpha:1,ease:Back.easeInOut,onComplete:buffCritComplete1,onCompleteParams:[ui]});
		}
		private function buffCritComplete1(ui:AbsView):void
		{
			TweenLite.to(ui,2,{x:ui.x+300*Math.random()-150,y:ui.y+300,scaleX:0,scaleY:0,alpha:0,ease:Linear.easeInOut,onComplete:buffCritComplete2,onCompleteParams:[ui]});
		}
		
		private function buffCritComplete2(ui:AbsView):void
		{
			LayerManager.FightTextLayer.removeChild(ui);
			ui.alpha=1;
			ui.dispose();
		}
		public function showBuffAdd(bloodNum:int,playerX:Number,playerY:Number):void
		{
			playerY -=30;
			var ui:AbsView=ImageTextManager.Instance.createNumWidthPre(bloodNum.toString(),2);
			ui.alpha=1;
			var ty:Number=playerY-100;
			ui.x=playerX-ui.width*0.5;
			ui.y=playerY;
			LayerManager.FightTextLayer.addChild(ui);
			TweenLite.to(ui,2,{y:ty,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});

		}
		

		/**  buff加血
		 ***/		
		public function showBuffMinus(bloodNum:int,playerX:Number,playerY:Number):void
		{
			var ui:AbsView=ImageTextManager.Instance.createNumWidthPre(bloodNum.toString(),1);
			ui.alpha=1;
			var ty:Number=playerY-100;
			ui.x=playerX-ui.width*0.5;
			ui.y=ty;
			LayerManager.FightTextLayer.addChild(ui);
			TweenLite.to(ui,2,{y:playerY,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});
		}
		private function buffAddComplete1(ui:AbsView):void
		{
			LayerManager.FightTextLayer.removeChild(ui);
			ui.alpha=1;
			ui.dispose();
		}
		
		
		
	}
}