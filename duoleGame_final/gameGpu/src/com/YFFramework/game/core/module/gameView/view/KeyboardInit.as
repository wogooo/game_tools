package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.mapScence.manager.MouseFollowManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/** 游戏中所有的全局的 键盘响应都在该类中实例化
	 * @author yefeng
	 *2012-8-11下午2:45:23
	 */
	public class KeyboardInit
	{
		
		/**当前时间
		 */ 
		private var _currentTime:Number;
		private static const SpaceCD:int=1000;///1秒按一次
		public function KeyboardInit()
		{
			_currentTime=getTimer();
			intAllKeyboard();
		}
		private function intAllKeyboard():void
		{
			var escKeyItem:KeyBoardItem=new KeyBoardItem(Keyboard.ESCAPE,escFunc);///按下esc键盘后响应
			////初始化   1 --9 键盘 
			var keyItem1:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_1,onkeyDown);
			var keyItem2:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_2,onkeyDown);
			var keyItem3:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_3,onkeyDown);
			var keyItem4:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_4,onkeyDown);
			var keyItem5:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_5,onkeyDown);
			var keyItem6:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_6,onkeyDown);
			var keyItem7:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_7,onkeyDown);
			var keyItem8:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_8,onkeyDown);
			var keyItem9:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_9,onkeyDown);
			var keyItem0:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_0,onkeyDown);
			//qwertasdfg
			var keyItemQ:KeyBoardItem=new KeyBoardItem(Keyboard.Q,onkeyDown);
			var keyItemW:KeyBoardItem=new KeyBoardItem(Keyboard.W,onkeyDown);
			var keyItemE:KeyBoardItem=new KeyBoardItem(Keyboard.E,onkeyDown);
			var keyItemR:KeyBoardItem=new KeyBoardItem(Keyboard.R,onkeyDown);
			var keyItemT:KeyBoardItem=new KeyBoardItem(Keyboard.T,onkeyDown);
			var keyItemA:KeyBoardItem=new KeyBoardItem(Keyboard.A,onkeyDown);
			var keyItemS:KeyBoardItem=new KeyBoardItem(Keyboard.S,onkeyDown);
			var keyItemD:KeyBoardItem=new KeyBoardItem(Keyboard.D,onkeyDown);
			var keyItemF:KeyBoardItem=new KeyBoardItem(Keyboard.F,onkeyDown);
			var keyItemG:KeyBoardItem=new KeyBoardItem(Keyboard.G,onkeyDown);
			//空格键 
			var keyItemSpace:KeyBoardItem=new KeyBoardItem(Keyboard.SPACE,onkeyDown);
			//键盘事件
			var keyItemP:KeyBoardItem=new KeyBoardItem(Keyboard.P,onKeyUp);//宠物
			var keyItemB:KeyBoardItem=new KeyBoardItem(Keyboard.B,onKeyUp);//背包
			var keyItemC:KeyBoardItem=new KeyBoardItem(Keyboard.C,onKeyUp);//角色
			var keyItemJ:KeyBoardItem=new KeyBoardItem(Keyboard.J,onKeyUp);//技能
			var keyItemH:KeyBoardItem=new KeyBoardItem(Keyboard.H,onKeyUp);//公会
			var keyItemI:KeyBoardItem=new KeyBoardItem(Keyboard.I,onKeyUp);//市场
			var keyItemV:KeyBoardItem=new KeyBoardItem(Keyboard.V,onKeyUp);//组队
			var keyItemU:KeyBoardItem=new KeyBoardItem(Keyboard.U,onKeyUp);//商城
			var keyItemY:KeyBoardItem=new KeyBoardItem(Keyboard.Y,onKeyUp);//排行榜
			var keyItemN:KeyBoardItem=new KeyBoardItem(Keyboard.N,onKeyUp);//坐骑
			var keyItemO:KeyBoardItem=new KeyBoardItem(Keyboard.O,onKeyUp);//好友
			var keyItemK:KeyBoardItem=new KeyBoardItem(Keyboard.K,onKeyUp);//锻造
//			var keyItemZ:KeyBoardItem=new KeyBoardItem(Keyboard.Z,onKeyUp);//挂机
			var keyItemM:KeyBoardItem=new KeyBoardItem(Keyboard.M,onKeyUp);//小地图
			var keyItemL:KeyBoardItem=new KeyBoardItem(Keyboard.L,onKeyUp);//任务
			var keyItemX:KeyBoardItem=new KeyBoardItem(Keyboard.X,onKeyUp);//上下马
			var keyItemPERIOD:KeyBoardItem=new KeyBoardItem(Keyboard.PERIOD,onKeyUp);//句号，GM工具
		//	var keyItemESC:KeyBoardItem=new KeyBoardItem(Keyboard.ESCAPE,onKeyUp);//系统
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(UI.isInTextInputState == true) return;
			var keyCode:int=e.keyCode;
			switch(keyCode){
				case Keyboard.P:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.PetOpen))	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUIClick);
					break;
				case Keyboard.B:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.BagOpen))	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagUIClick);
					break;
				case Keyboard.C:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CharacterUIClick);
					break;
				case Keyboard.J:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.SkillOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillUIClick);
					break;
				case Keyboard.H:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.GuildOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildUIClick);
					break;
				case Keyboard.I:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MarkcketOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MarketUIClick);
					break;
				case Keyboard.V:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.TeamOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamUIClick);
					break;
				case Keyboard.U:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MallOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MallUIClick);
					break;
				case Keyboard.Y:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RankUIClick);
					break;
				case Keyboard.N:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MountOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MountUIClick);
					break;
				case Keyboard.O:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.FriendOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendUIClick);
					break;
				case Keyboard.K:
					if(NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.ForageOpen))
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ForgeUIClick);
					break;
//				case Keyboard.ESCAPE:
//					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemUIClick);
//					break;
//				case Keyboard.Z:
//					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AutoUIClick);
//					break;
				case Keyboard.M:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapUIClick);
					break;
				case Keyboard.L:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskUIClick);
					break;
				case Keyboard.X:
					if(e.shiftKey)//天命神脉测试
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DivinePulseClick);
					else
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RideMountReq);
					break;
				case Keyboard.PERIOD://句号，GM工具
					if(e.ctrlKey)
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GMToolOpen);;
					break;
			}
		}
		
		private function cantrigger():Boolean
		{
			var isTriger:Boolean=true;
			if(StageProxy.Instance.stage.focus is TextField) ///不为文本时触发
			{
				if(TextField(StageProxy.Instance.stage.focus).type==TextFieldType.INPUT)isTriger==false	;
			}
			return isTriger;
		}
		private function onkeyDown(e:KeyboardEvent):void
		{
			if(UI.isInTextInputState == true) return;
			var keyCode:int=e.keyCode;
			switch(keyCode)
			{
				case Keyboard.NUMBER_1:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_1);
					}
					break;
				case Keyboard.NUMBER_2:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_2);
					}
						
					break;
				case Keyboard.NUMBER_3:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_3);
					}
					break;
				case Keyboard.NUMBER_4:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_4);
					}
					break;
				case Keyboard.NUMBER_5:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_5);
					}
					break;
				case Keyboard.NUMBER_6:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_6);
					}
					break;
				case Keyboard.NUMBER_7:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_7);
					}
					break;
				case Keyboard.NUMBER_8:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_8);
					}
					break;
				case Keyboard.NUMBER_9:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_9);
					}
					break;
				case Keyboard.NUMBER_0:
					if(cantrigger()) ///不为文本时触发
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_0);
					}
					break;
				case Keyboard.SPACE://空格键
					if(getTimer()-_currentTime>=SpaceCD)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownSpace);
						_currentTime=getTimer();
					}
					break;
				case Keyboard.Q:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownQ);
					break;
				case Keyboard.W:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownW);
					break;
				case Keyboard.E:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownE);
					break;
				case Keyboard.R:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownR);
					break;
				case Keyboard.T:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownT);
					break;
				case Keyboard.A:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownA);
					break;
				case Keyboard.S:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownS);
					break;
				case Keyboard.D:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownD);
					break;
				case Keyboard.F:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownF);
					break;
				case Keyboard.G:
					if(cantrigger())
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownG);
					break;
			}
		}
		
		
		private function escFunc(e:KeyboardEvent):void
		{
			if(MouseFollowManager.Instance.isStart()) //先去掉指示器
			{
				return ;
			}
			var len:int=LayerManager.WindowLayer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var window:Panel = LayerManager.WindowLayer.getChildAt(i) as Panel;
				if(window && window.isCloseing == false){
					window.close();
					return ;
				}
			}
			//如果  没有窗口 则  表示打开系统设置
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemUIClick);

		}
	}
}