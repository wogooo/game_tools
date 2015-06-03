package com.YFFramework.game.core.module.DivinePulses.manager
{
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	import com.greensock.plugins.VolumePlugin;
	
	import flash.utils.Dictionary;

	/***
	 *天神命脉数据管理类
	 *@author ludingchang 时间：2013-11-13 下午1:39:03
	 */
	public class DivinePulseManager
	{
		private static var _inst:DivinePulseManager;
		public static function get Instence():DivinePulseManager
		{
			return _inst||=new DivinePulseManager;
		}
		public function DivinePulseManager()
		{
			_learned=new Dictionary;
		}
		/**选中的元素*/
		public var left_selected:int=1;
		/**右边选中数据(0表示中间主脉)*/
		public var right_selected:int=1;
		private var _learned:Dictionary;
		/**
		 *学习了一个神脉 
		 * @param id 神脉ID
		 * 
		 */		
		public function learnedPulse(id:int):void
		{
			if(id==0)//没学过
				return;
			var vo:Divine_pulseBasicVo=Divine_pulseBasicManager.Instance.getDivinePulseVoById(id);
			_learned[vo.element]=vo;
		}
		
		/**
		 *是否学习了神脉xx 
		 * @return 
		 * 
		 */		
		public function hasLearnedPulse(element:int,pos:int):Boolean
		{
			var vo:Divine_pulseBasicVo=_learned[element];
			if(vo)
			{
				if(vo.lv>1)//有一个神脉等级超过1表示这个元素的神脉都学习过了
					return true;
				else 
					return pos<=vo.pos;//等级为1时，小于当前神脉位置的神脉是学过的，
			}
			return false;
		}
		
		/**
		 * 得到已学习的神脉
		 */		
		public function getLearnedPulse(element:int,pos:int):Divine_pulseBasicVo
		{
			var vo:Divine_pulseBasicVo=_learned[element];
			if(vo)
			{
				if(pos<vo.pos)
					return Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(element,pos,vo.lv);
				else if(pos==vo.pos)
					return vo;
				else if(pos>vo.pos)
				{
					if(vo.lv>1)
						return Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(element,pos,vo.lv-1);
					else
						return null;
				}
			}
			return null;
		}
		
		/**
		 * 得到所有神脉相加后的属性 
		 * @return 一个含有加成属性值的VO，其他字段都是空
		 * 
		 */		
		public function getTotalBuff():Divine_pulseBasicVo
		{
			var total:Divine_pulseBasicVo=new Divine_pulseBasicVo;
			var total_pos:int=TypePulse.NUMBER_SUB_PULSES;
			var total_elentms:int=TypePulse.NUMBER_ELEMENT;
			
			for (var i:int=1;i<=total_elentms;i++)
			{
				for(var j:int=1;j<=total_pos;j++)
				{
					var temp_vo:Divine_pulseBasicVo=getLearnedPulse(i,j);
					if(temp_vo)
					{
						total.hp+=temp_vo.hp;
						total.mp+=temp_vo.mp;
						total.phy_atk+=temp_vo.phy_atk;
						total.phy_dfs+=temp_vo.phy_dfs;
						total.magic_atk+=temp_vo.magic_atk;
						total.magic_dfs+=temp_vo.magic_dfs;
						total.crit_rating+=temp_vo.crit_rating;
						total.avoid_rating+=temp_vo.avoid_rating;
						total.hit_rating+=temp_vo.hit_rating;
						total.tenacity_rating+=temp_vo.tenacity_rating;
						total.phy_pierce+=temp_vo.phy_pierce;
						total.magic_pierce+=temp_vo.magic_pierce;
					}
				}
			}
			return total;
		}
		
		
		/**更新右边自动选中*/
		public function updateCurrentSelected():void
		{
			//根据元素和取出所有支脉ID
			//根据ID取等级
			//遍历，取等级最小，如果等级相同比位置，
			var element:int=left_selected;
			var ids:Vector.<Divine_pulseBasicVo>=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVosByElement(element);
			var i:int,len:int=ids.length;
			var minLv:int=10;
			var vo:Divine_pulseBasicVo;
			var minPos:int=10;
			var res:Divine_pulseBasicVo;
			var lv:int;
			for(i=0;i<len;i++)
			{
				vo=getLearnedPulse(ids[i].element,ids[i].pos);
				if(!vo)
				{
					vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(ids[i].element,ids[i].pos,1);
					lv=0;
				}
				else
					lv=vo.lv;
				if(lv<minLv)
				{
					minLv=lv;
					minPos=vo.pos;
				}
				else if(lv==minLv)
				{
					if(vo.pos<minPos)
					{
						minPos=vo.pos;
					}
				}
			}
			right_selected=minPos;
		}
		
		public function getNextLearnVo(element:int,pos:int):Divine_pulseBasicVo
		{
			var vo:Divine_pulseBasicVo=getLearnedPulse(element,pos);
			if(!vo)
				vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(element,pos,1);
			else if(vo.lv<TypePulse.LV_PULSES)
				vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(element,pos,vo.lv+1);
			else
				vo=null;
			return vo;
		}
		
		
		
	}
}