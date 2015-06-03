package com.YFFramework.game.core.module.DivinePulses.manager
{
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	
	import flash.display3D.IndexBuffer3D;
	import flash.utils.Dictionary;

	public class Divine_pulseBasicManager
	{
		private static var _instance:Divine_pulseBasicManager;
		/**三维数组，第一维索引是元素（element）,第二维索引是位置（pos）,第三维索引是等级（lv）*/
		private var _dict:Vector.<Vector.<Vector.<Divine_pulseBasicVo>>>;
		/**以唯一ID为key的map*/
		private var _map:Dictionary;
		public function Divine_pulseBasicManager()
		{
			var i:int,elements:int=TypePulse.NUMBER_ELEMENT;
			var j:int,pulses:int=TypePulse.NUMBER_SUB_PULSES;
			var k:int,levels:int=TypePulse.LV_PULSES;
			_dict=new Vector.<Vector.<Vector.<Divine_pulseBasicVo>>>(elements);
			for(i=0;i<elements;i++)
			{
				_dict[i]=new Vector.<Vector.<Divine_pulseBasicVo>>(pulses);
				for(j=0;j<pulses;j++)
				{
					_dict[i][j]=new Vector.<Divine_pulseBasicVo>(levels);
				}
			}
			_map=new Dictionary;
		}
		public static function get Instance():Divine_pulseBasicManager
		{
			if(_instance==null)_instance=new Divine_pulseBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var divine_pulseBasicVo:Divine_pulseBasicVo;
			for (var id:String in jsonData)
			{
				divine_pulseBasicVo=new Divine_pulseBasicVo();
				divine_pulseBasicVo.limit_lv=jsonData[id].limit_lv;
				divine_pulseBasicVo.crit_rating=jsonData[id].crit_rating;
				divine_pulseBasicVo.see=jsonData[id].see;
				divine_pulseBasicVo.phy_dfs=jsonData[id].phy_dfs;
				divine_pulseBasicVo.daoju_num=jsonData[id].daoju_num;
				divine_pulseBasicVo.magic_pierce=jsonData[id].magic_pierce;
				divine_pulseBasicVo.diamond=jsonData[id].diamond;
				divine_pulseBasicVo.eff_id=jsonData[id].eff_id;
				divine_pulseBasicVo.icon_id=jsonData[id].icon_id;
				divine_pulseBasicVo.hp=jsonData[id].hp;
				divine_pulseBasicVo.magic_atk=jsonData[id].magic_atk;
				divine_pulseBasicVo.lv=jsonData[id].lv;
				divine_pulseBasicVo.name=jsonData[id].name;
				divine_pulseBasicVo.phy_pierce=jsonData[id].phy_pierce;
				divine_pulseBasicVo.tenacity_rating=jsonData[id].tenacity_rating;
				divine_pulseBasicVo.element=jsonData[id].element;
				divine_pulseBasicVo.phy_atk=jsonData[id].phy_atk;
				divine_pulseBasicVo.daoju_id=jsonData[id].daoju_id;
				divine_pulseBasicVo.des=jsonData[id].des;
				divine_pulseBasicVo.hit_rating=jsonData[id].hit_rating;
				divine_pulseBasicVo.magic_dfs=jsonData[id].magic_dfs;
				divine_pulseBasicVo.id=jsonData[id].id;
				divine_pulseBasicVo.avoid_rating=jsonData[id].avoid_rating;
				divine_pulseBasicVo.note=jsonData[id].note;
				divine_pulseBasicVo.mp=jsonData[id].mp;
				divine_pulseBasicVo.pos=jsonData[id].pos;
				divine_pulseBasicVo.pulse_id=jsonData[id].pulse_id;
				
				_dict[divine_pulseBasicVo.element-1][divine_pulseBasicVo.pos-1][divine_pulseBasicVo.lv-1]=divine_pulseBasicVo;
				_map[divine_pulseBasicVo.id]=divine_pulseBasicVo;
			}
		}
		
		public function getDivinePulseVoById(id:int):Divine_pulseBasicVo
		{
			return _map[id];
		}
		/**
		 *取Vo 
		 * @param element 元素
		 * @param pos 位置
		 * @param lv 等级
		 * @return 
		 * 
		 */		
		public function getDivine_pulseBasicVo(element:int,pos:int,lv:int):Divine_pulseBasicVo
		{
			return _dict[element-1][pos-1][lv-1];
		}
		
		/**
		 *取某个元素下面的所有等级为1的神脉的vo数组(按位置排序) 
		 * @param element：元素类型
		 * @return 
		 * 
		 */		
		public function getDivine_pulseBasicVosByElement(element:int):Vector.<Divine_pulseBasicVo>
		{
			var len:int=TypePulse.NUMBER_SUB_PULSES;
			var result:Vector.<Divine_pulseBasicVo>=new Vector.<Divine_pulseBasicVo>(len);
			for (var i:int=0;i<len;i++)
			{
				result[i]=_dict[element-1][i][0];
			}
			return result;
		}
		
		/**
		 *取所有元素的位置为最后一个等级为1的神脉组成的数组 
		 */		
		public function getAllElementsVo():Vector.<Divine_pulseBasicVo>
		{
			var elements:int=TypePulse.NUMBER_ELEMENT;
			var pulses:int=TypePulse.NUMBER_SUB_PULSES;
			var re:Vector.<Divine_pulseBasicVo>=new Vector.<Divine_pulseBasicVo>(elements);
			for(var i:int=0;i<elements;i++)
			{
				re[i]=_dict[i][pulses-1][0];
			}
			return re;
		}
		
		
		/**
		 *取某个元素的主脉VO（其实就是该元素的最后一个支脉 
		 * @param element
		 * @return 
		 * 
		 */		
		public function getMainPulseByElement(element:int):Divine_pulseBasicVo
		{
			return _dict[element-1][TypePulse.NUMBER_SUB_PULSES-1][0];
		}
	}
}