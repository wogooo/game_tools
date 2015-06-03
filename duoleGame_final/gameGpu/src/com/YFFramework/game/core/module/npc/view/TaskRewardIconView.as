package com.YFFramework.game.core.module.npc.view
{
	/**@author yefeng
	 * 2013 2013-5-20 下午1:54:06 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.YFFramework.game.core.module.npc.model.TaskRewardVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Label;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**任务奖励图标
	 */	
	public class TaskRewardIconView extends AbsView
	{
	
		private static const Speed:int=900; 
	
		
		
		public static const ICON_SIZE:Number=40;
		/**物理减伤害
		 */		
		private var _taskRewardVo:TaskRewardVo;
		private var _iconImage:IconImage;
		
		private var _label:Label;
		public function TaskRewardIconView(taskRewardVo:TaskRewardVo)
		{
			_taskRewardVo=taskRewardVo;
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_iconImage=new IconImage();
			addChild(_iconImage);
			if(_taskRewardVo.type==TypeProps.ITEM_TYPE_EQUIP) //装备
			{
				_iconImage.url=EquipBasicManager.Instance.getURL(_taskRewardVo.basicId);
				Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,0,_taskRewardVo.basicId);
			}
			else if(_taskRewardVo.type==TypeProps.ITEM_TYPE_PROPS)//道具  
			{
				_iconImage.url=PropsBasicManager.Instance.getURL(_taskRewardVo.basicId);
				Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,0,_taskRewardVo.basicId);
			}
			//设置数量
			if(_taskRewardVo.num>1)
			{
				_label=new Label(); 
				addChild(_label);
				_label.setText(_taskRewardVo.num.toString(),0xFFFFFF);
				_label.exactWidth();
				_label.exactHeight();
				_label.x=ICON_SIZE-_label.textWidth-8;
				_label.y=ICON_SIZE-_label.textHeight-5;
			}
		}
		
		public function clone():TaskRewardIconView
		{
			var view:TaskRewardIconView=new TaskRewardIconView(_taskRewardVo);
			var flashPt:Point=UIPositionUtil.getPosition(this,LayerManager.UIViewRoot);
			view.x=flashPt.x;
			view.y=flashPt.y;
			return view;	
		}
		/**缓动
		 */
		public function doTween():void
		{
			var pivot:Point=GameViewPositonProxy.getMovePivot();  
			var dif1:Number=YFMath.distance(x,y,pivot.x,pivot.y);
			var time1:Number=dif1/Speed;
			TweenLite.to(this,time1,{x:pivot.x,y:pivot.y,onComplete:omComplete});
		}
		
		/**完成
		 */
		private function omComplete():void
		{
			var pivot:Point=GameViewPositonProxy.getMovePivot();
			var dif1:Number=YFMath.distance(GameViewPositonProxy.BagX,GameViewPositonProxy.BagY,pivot.x,pivot.y);
			var time1:Number=dif1/Speed;
			TweenLite.to(this,time1,{x:GameViewPositonProxy.BagX,y:GameViewPositonProxy.BagY,onComplete:completeIt,delay:0.05}); 
		}
		
		private function completeIt():void
		{
			if(parent)parent.removeChild(this);
			dispose();
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_taskRewardVo=null;
			_iconImage=null;
			_label=null;
		}
	}
}