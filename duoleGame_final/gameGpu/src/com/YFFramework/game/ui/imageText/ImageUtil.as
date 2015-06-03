package com.YFFramework.game.ui.imageText
{
	import com.YFFramework.core.center.manager.update.TimeLine;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightDamageType;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

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
		 * damageType  伤害类型   值在FightDamageType里面
		 */		
		public function showBloodEx(timeArr:Array,bloodNum:int,flashContainer:Sprite,playerY:Number,textType:int=1,completeFunc:Function=null,completeParam:Object=null,damageType:int=1):void
		{
//			if(completeFunc!=null)
//			{
//				completeFunc(completeParam);
//			}
//			return ;

			var isBlood:Boolean=true;
			if(timeArr)
			{
				if(bloodNum>0)
				{
					switch(damageType)
					{
						case FightDamageType.MISS: // miss
							switch(textType)
							{
								case TypeImageText.Monster: //怪物 
									showMonsterMiss(flashContainer,playerY,timeArr[0]);
									break;
								case TypeImageText.Role: //角色 
									showRoleMiss(flashContainer,playerY,timeArr[0]);
									break;
							}
							break;
						case FightDamageType.CRIT:
							switch(textType)
							{
								case TypeImageText.Monster: //怪物 
									showMonsterCrit(flashContainer,playerY,timeArr[0]);
									break;
								case TypeImageText.Role: //角色 
									showRoleCrit(flashContainer,playerY,timeArr[0]);
									break;
							}
							break;
						case FightDamageType.CURE:  //加血  复活
						case FightDamageType.REVIVE:
							isBlood=false;
							break;
					}

					
					
					
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
					var myT:int;
					for(i=0;i!=len;++i)
					{
						myT=timeArr[i];
						if(myT<=0)myT=1;
						timeLine.addWait(myT);
						timeLine.addFunc(showBloodInit,{bloodNum:bloodArr[i],flashContainer:flashContainer,playerY:playerY,textType:textType,isBlood:isBlood},0);
					}
					timeLine.start();

				}
				else   /// miss 
				{
					if(damageType==FightDamageType.MISS)
					{
						switch(textType)
						{
							case TypeImageText.Monster: //怪物 
								showMonsterMiss(flashContainer,playerY,timeArr[0]);
								break;
							case TypeImageText.Role: //角色 
								showRoleMiss(flashContainer,playerY,timeArr[0]);
								break;
						}
					}
				}
			}
			else if(completeFunc!=null)
			{
				completeFunc(completeParam);
			}

		}
		
		private function showBloodInit(obj:Object):void
		{
			var bloodNum:int=obj.bloodNum;
			var flashContainer:Sprite=obj.flashContainer;
			var playerY:Number=obj.playerY;
			var textType:int=obj.textType;
			var isBlood:Boolean=obj.isBlood;
			if(bloodNum>0)
			{
				showBloodIt(bloodNum,flashContainer,playerY,textType,isBlood);
			}
//			else 
//			{
//				switch(textType)
//				{
//					case TypeImageText.Monster: //怪物 
//						showMonsterMiss(flashContainer,playerY);
//						break;
//					case TypeImageText.Role: //角色 
//						showRoleMiss(flashContainer,playerY);
//						break;
//				}
//			}
		}

		
		
		/**bloodNum 显示掉血量 
		 * flashContainer承载该血量的UI 
		 * textType  类型  是怪物类型掉血 还是人物类型掉血
		 * bloodFirstY  出现的位置
		 */		
		private function showBloodIt(bloodNum:int,flashContainer:Sprite,bloodFirstY:int,textType:int=1,isBlood:Boolean=true):void
		{
			var view:AbsView;
			switch(textType)
			{
				case TypeImageText.Monster: //怪物类型
					if(isBlood)
					{
						view=ImageTextManager.Instance.createMonsterBlood(String(bloodNum));
					}
					else 
					{
						view=ImageTextManager.Instance.createAddHp(String(bloodNum));
					}
					break;
				case TypeImageText.Role://角色类型
					if(isBlood)
					{
						view=ImageTextManager.Instance.createRoleBlood(String(bloodNum));
					}
					else 
					{
						view=ImageTextManager.Instance.createAddHp(String(bloodNum));
					}
					break;
			} 
			bloodFirstY=bloodFirstY-120;
			view.y=bloodFirstY;
			flashContainer.addChild(view);
			view.x=-view.width*0.5;
//			TweenLite.to(view,2,{y:bloodFirstY-300,alpha:0.1,onComplete:onShowbloodItComplete1,onCompleteParams:[view,flashContainer]});
			TweenLite.to(view,0.15,{y:bloodFirstY-50,scaleX:1.5,scaleY:1.5,onComplete:onShowbloodItComplete1,onCompleteParams:[view,flashContainer,bloodFirstY-100]});

		} 
		private function onShowbloodItComplete1(view:AbsView,flashContainer:Sprite,y:Number):void
		{
			TweenLite.to(view,0.4,{y:y,scaleX:1,scaleY:1,x:view.x+120*Math.random(),onComplete:onShowbloodItComplete2,onCompleteParams:[view,flashContainer]});
			
//			if(flashContainer.contains(view))flashContainer.removeChild(view); 
		}
		private function onShowbloodItComplete2(view:AbsView,flashContainer:Sprite):void 
		{
			if(flashContainer.contains(view))
			{
				flashContainer.removeChild(view);
			}
			view.dispose();
		}

		
		
		/**显示怪物暴击
		 */		
		private function showMonsterCrit(flashContainer:Sprite,bloodFirstY:Number,delay:Number):void
		{
			var t:TimeOut=new TimeOut(delay,showMonsterCritInit,{flashContainer:flashContainer,bloodFirstY:bloodFirstY})
			t.start();
//			bloodFirstY=bloodFirstY-120;
//			var bmp:Bitmap=ImageTextManager.Instance.createMonsterCrit();
//			flashContainer.addChild(bmp);
//			bmp.y=bloodFirstY;
//			bmp.scaleX=1;
//			bmp.scaleY=1;
//			TweenLite.to(bmp,0.7,{y:bloodFirstY-100,scaleX:1.5,scaleY:1.5,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		private function showMonsterCritInit(obj:Object):void
		{
			var flashContainer:Sprite=obj.flashContainer as Sprite;
			var bloodFirstY:Number=obj.bloodFirstY;
			bloodFirstY=bloodFirstY-120;
			var bmp:Bitmap=ImageTextManager.Instance.createMonsterCrit();
			flashContainer.addChild(bmp); 
			bmp.y=bloodFirstY;
			bmp.scaleX=1;
			bmp.scaleY=1;
			TweenLite.to(bmp,0.7,{y:bloodFirstY-100,scaleX:1.5,scaleY:1.5,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		
		
		
		/** 显示玩家暴击
		 */
		private function showRoleCrit(flashContainer:Sprite,bloodFirstY:Number,delay:Number):void
		{
			var t:TimeOut=new TimeOut(delay,showRoleCritInit,{flashContainer:flashContainer,bloodFirstY:bloodFirstY})
			t.start();
//			bloodFirstY=bloodFirstY-120;
//			var bmp:Bitmap=ImageTextManager.Instance.createRoleCrit();
//			flashContainer.addChild(bmp);
//			bmp.y=bloodFirstY;
//			bmp.scaleX=1;
//			bmp.scaleY=1;
//			TweenLite.to(bmp,0.7,{y:bloodFirstY-100,delay:delay,scaleX:1.5,scaleY:1.5,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		private function showRoleCritInit(obj:Object):void
		{
			var flashContainer:Sprite=obj.flashContainer as Sprite;
			var bloodFirstY:Number=obj.bloodFirstY;
			bloodFirstY=bloodFirstY-120;
			var bmp:Bitmap=ImageTextManager.Instance.createRoleCrit();
			flashContainer.addChild(bmp);
			bmp.y=bloodFirstY;
			bmp.scaleX=1;
			bmp.scaleY=1;
			TweenLite.to(bmp,0.7,{y:bloodFirstY-100,scaleX:1.5,scaleY:1.5,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}

		/**显示怪物miss
		 */
		private function showMonsterMiss(flashContainer:Sprite,bloodFirstY:Number,delay:Number):void
		{
			var t:TimeOut=new TimeOut(delay,showMonsterMissInit,{flashContainer:flashContainer,bloodFirstY:bloodFirstY})
			t.start();
//			var bmp:Bitmap=ImageTextManager.Instance.createMonsterMiss();
//			flashContainer.addChild(bmp);
//			bmp.y=playerY;
//			bmp.scaleX=1;
//			bmp.scaleY=1;
//			TweenLite.to(bmp,1,{y:playerY-250,delay:delay,scaleX:1,scaleY:1,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		private function showMonsterMissInit(obj:Object):void
		{
			var flashContainer:Sprite=obj.flashContainer as Sprite;
			var bloodFirstY:Number=obj.bloodFirstY;
			var bmp:Bitmap=ImageTextManager.Instance.createMonsterMiss();
			flashContainer.addChild(bmp);
			bmp.y=bloodFirstY;
			bmp.scaleX=1;
			bmp.scaleY=1;
			TweenLite.to(bmp,1,{y:bloodFirstY-250,scaleX:1,scaleY:1,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}

		/**显示人物miss
		 */
		private function showRoleMiss(flashContainer:Sprite,bloodFirstY:Number,delay:Number):void
		{
			var t:TimeOut=new TimeOut(delay,showRoleMissInit,{flashContainer:flashContainer,bloodFirstY:bloodFirstY})
			t.start();
//			var bmp:Bitmap=ImageTextManager.Instance.createRoleMiss();
//			flashContainer.addChild(bmp);
//			bmp.y=playerY;
//			bmp.scaleX=1;
//			bmp.scaleY=1;
//			TweenLite.to(bmp,0.8,{y:playerY-250,delay:delay,scaleX:1,scaleY:1,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		
		private function showRoleMissInit(obj:Object):void
		{
			var flashContainer:Sprite=obj.flashContainer as Sprite;
			var bloodFirstY:Number=obj.bloodFirstY;
			var bmp:Bitmap=ImageTextManager.Instance.createRoleMiss();
			flashContainer.addChild(bmp);
			bmp.y=bloodFirstY;
			bmp.scaleX=1;
			bmp.scaleY=1;
			TweenLite.to(bmp,0.8,{y:bloodFirstY-250,scaleX:1,scaleY:1,ease:Back.easeOut,onComplete:onBitmapCompeete,onCompleteParams:[bmp]});
		}
		
		
		private function onBitmapCompeete(bmp:Bitmap):void
		{
			if(bmp.parent)bmp.parent.removeChild(bmp);
		}
		
		
		/**buff加血
		 */
		public function showBuffHpAdd(bloodNum:int,flashContainer:Sprite,playerY:Number,textType:int):void
		{

			var ui:AbsView;
			switch(textType)
			{
				case TypeImageText.Monster: //怪物 
					ui=ImageTextManager.Instance.createAddHp(String(bloodNum));
					break;
				case TypeImageText.Role://角色
					ui=ImageTextManager.Instance.createAddHp(String(bloodNum));
					break;
			}
			ui.alpha=1;
			flashContainer.addChild(ui);
			ui.x=-ui.width*0.5;
			ui.y=playerY;
			TweenLite.to(ui,2,{y:playerY-100,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});
		}
		
		/**  buff扣血
		 ***/		
		public function showBuffHpMinus(bloodNum:int,flashContainer:Sprite,playerY:Number,textType:int):void
		{

			var ui:AbsView;
			switch(textType)
			{
				case TypeImageText.Monster: //怪物 
					ui=ImageTextManager.Instance.createMonsterBlood(String(bloodNum));
					break;
				case TypeImageText.Role://角色
					ui=ImageTextManager.Instance.createRoleBlood(String(bloodNum));
					break;
			}
			ui.alpha=1;
			ui.y=playerY;
			ui.x=-ui.width*0.5;
			flashContainer.addChild(ui);
			TweenLite.to(ui,2,{y:0,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});
		}
		private function buffAddComplete1(ui:AbsView):void
		{
			if(ui.parent)ui.parent.removeChild(ui);
			ui.alpha=1;
			ui.dispose();
		}
		
		/**buff蓝
		 */
		public function showBuffMpAdd(bloodNum:int,flashContainer:Sprite,playerY:Number,textType:int):void
		{

			var ui:AbsView;
			switch(textType)
			{
				case TypeImageText.Monster: //怪物 
					ui=ImageTextManager.Instance.createAddMp(String(bloodNum));
					break;
				case TypeImageText.Role://角色
					ui=ImageTextManager.Instance.createAddMp(String(bloodNum));
					break;
			}
			ui.alpha=1;
			flashContainer.addChild(ui);
			ui.x=-ui.width*0.5;
			ui.y=playerY;
			TweenLite.to(ui,2,{y:playerY-100,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});
		}
 
		/**  buff扣蓝
		 ***/		
		public function showBuffMpMinus(bloodNum:int,flashContainer:Sprite,playerY:Number,textType:int):void
		{

			var ui:AbsView;
			switch(textType)
			{
				case TypeImageText.Monster: //怪物 
					ui=ImageTextManager.Instance.createMinusMp(String(bloodNum));
					break;
				case TypeImageText.Role://角色
					ui=ImageTextManager.Instance.createMinusMp(String(bloodNum));
					break;
			}
			ui.alpha=1;
			ui.y=playerY;
			ui.x=-ui.width*0.5;
			flashContainer.addChild(ui);
			TweenLite.to(ui,2,{y:0,alpha:0,ease:Linear.easeNone,onComplete:buffAddComplete1,onCompleteParams:[ui]});
		}

		
		
	}
}