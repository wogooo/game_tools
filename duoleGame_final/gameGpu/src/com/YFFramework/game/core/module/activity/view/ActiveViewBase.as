package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseRewardVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.systemReward.view.IconCtrl;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/***
	 *活动子视图基类
	 *@author ludingchang 时间：2013-12-30 上午10:13:02
	 */
	public class ActiveViewBase
	{
		/**是否显示星星*/
		protected var _showStar:Boolean=true;
		protected var _mc:MovieClip;
		protected var _list:List;
		protected var _txtArr:Array=new Array();
		protected var _spArr:Array = new Array();
		protected var _descTxt:TextField;
		protected var _icons:Vector.<IconCtrl>;
		/**icon个数*/
		public static const Icon_Num:int=12;
		public function ActiveViewBase(mc:MovieClip)
		{
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			
			_list = Xdis.getChild(_mc,"view_list");
			setRender();
			_list.addEventListener(Event.CHANGE,onSelectUpdate);
			
			if(_showStar)
			{
				for(var i:int=1;i<=3;i++){
					_txtArr.push(Xdis.getChild(_mc,"t"+i));
					_spArr.push(Xdis.getChild(_mc,"i"+i));
				}
			}
			
			_descTxt = Xdis.getChild(_mc,"descTxt");
			
			_icons=new Vector.<IconCtrl>(Icon_Num);
			for(i=0;i<Icon_Num;i++){
				_icons[i]=new IconCtrl(Xdis.getChild(_mc,"reward"+(i+1)));
				_icons[i].hideNum();
				_icons[i].visible=false;
			}
		}
		/**设置list的itemRender*/
		protected function setRender():void
		{
//			_list.itemRender = RaidRender;
		}
		/**
		 *用于子类重写（将listitem里的VO装换为统一的activeBaseVo）， 
		 * @param vo list里面的Vo
		 * @return ActiveBaseVo
		 * 
		 */		
		protected function getActiveBaseVo():ActiveBaseVo
		{
			return new ActiveBaseVo;
		}
		/**选择更新
		 * @param e
		 */		
		private function onSelectUpdate(e:Event):void
		{
			var vo:ActiveBaseVo = getActiveBaseVo();
			if(_showStar)
			{
				var index:int=0;
				clearContent();
				var star:Sprite;
				if(vo.expStar!=0){
					_txtArr[index].text = "经验奖励：";
					for(var i:int=0;i<vo.expStar;i++){
						star = ClassInstance.getInstance("bagUI_star");
						star.x = i*20;
						_spArr[index].addChild(star);
					}
					index++;
				}
				if(vo.moneyStar!=0){
					_txtArr[index].text = "金钱奖励：";
					for(i=0;i<vo.moneyStar;i++){
						star = ClassInstance.getInstance("bagUI_star");
						star.x = i*20;
						_spArr[index].addChild(star);
					}
					index++;
				}
				if(vo.propsStar!=0){
					_txtArr[index].text = "道具奖励：";
					for(i=0;i<vo.propsStar;i++){
						star = ClassInstance.getInstance("bagUI_star");
						star.x = i*20;
						_spArr[index].addChild(star);
					}
					index++;
				}
			}
			
			_descTxt.text = vo.desc;
			
			var vec:Vector.<ActiveBaseRewardVo> =vo.rewards;
			var len:int = vec.length;
			for(i=0;i<Icon_Num;i++){
				ActiveRewardIconTips.clearAllTips(_icons[i].icon);
				if(i<len)
				{
					switch(vec[i].type)
					{
						case RewardTypes.PROPS:
							var propsBasicVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(vec[i].id);
							_icons[i].icon.url = URLTool.getGoodsIcon(propsBasicVo.icon_id);
							Xtip.registerLinkTip(_icons[i].icon,PropsTip,TipUtil.propsTipInitFunc,0,vec[i].id);
							break;
						case RewardTypes.EQUIP:
							var equipBasicVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vec[i].id);
							_icons[i].icon.url = URLTool.getGoodsIcon(equipBasicVo.icon_id);
							Xtip.registerLinkTip(_icons[i].icon,EquipTipMix,TipUtil.equipTipInitFunc,0,vec[i].id);
							break;
						default:
							_icons[i].icon.url=URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(vec[i].type));
							Xtip.registerTip(_icons[i].icon,RewardTypes.getTypeStr(vec[i].type));
							break;
					}
					_icons[i].visible=true;
				}
				else
				{
					_icons[i].visible=false;
					_icons[i].icon.clear();
				}
			}
		}
		
		/**清除内容
		 */		
		private function clearContent():void{
			if(_showStar)
			{
				for(var i:int=0;i<3;i++){
					_txtArr[i].text="";
					while(_spArr[i].numChildren>0){
						_spArr[i].removeChildAt(0);
					}
				}
			}
			_descTxt.text="";
		}
		
		/**切换更新，用于子类重写*/
		public function onTabUpdate():void
		{
			
		}
	}
}