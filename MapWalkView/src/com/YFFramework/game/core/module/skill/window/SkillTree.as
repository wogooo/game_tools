package com.YFFramework.game.core.module.skill.window
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	
	import flash.utils.Dictionary;

	/**
	 * 技能树数据模型缓存 
	 * @author Administrator
	 * 
	 */
	public class SkillTree
	{
		public static const POS_1:uint = 1;
		public static const POS_2:uint = 2;
		public static const POS_3:uint = 3;
		public static const POS_4:uint = 4;
		
		public static const POS_105:uint = 105;
		public static const POS_106:uint = 106;
		public static const POS_107:uint = 107;
		public static const POS_108:uint = 108;
		public static const POS_109:uint = 109;
		public static const POS_110:uint = 110;
		
		public static const POS_205:uint = 205;
		public static const POS_206:uint = 206;
		public static const POS_207:uint = 207;
		public static const POS_208:uint = 208;
		public static const POS_209:uint = 209;
		public static const POS_210:uint = 210;
		
		private static var _ins:SkillTree;
		
		private var _basicSkillList:HashMap;
		private var _topTrees:Array;
		private var _leftTrees:Array;
		private var _rightTrees:Array;
		private var _typeMax:int = 3;
		private var _topTreeMax:int = 4;
		private var _leftTreeMax:int = 6;
		private var _rightTreeMax:int = 6;
		private var _allRef:Object = {};
		
		public function SkillTree()
		{
			_topTrees = [];
			_leftTrees = [];
			_rightTrees = [];
			for(var i:int=0;i<_typeMax;i++){
				_topTrees[i] = new Vector.<SkillBasicVo>(_topTreeMax);
				_leftTrees[i] = new Vector.<SkillBasicVo>(_leftTreeMax);
				_rightTrees[i] = new Vector.<SkillBasicVo>(_rightTreeMax);
			}
			_basicSkillList = SkillBasicManager.Instance.getSkillList(DataCenter.Instance.roleSelfVo.roleDyVo.career);
			var all:Array = _basicSkillList.values();
			all.reverse();
			var len:int = all.length;
			for(var obj:int=0;obj<len;obj++){
				var vo:SkillBasicVo = all[obj];
				var bigType:int = vo.skill_bigCategory;
				_allRef["big_"+bigType+"pos_"+vo.list_pos] = vo;
				switch(vo.list_pos){
					//左分支
					case POS_105:
						_leftTrees[bigType][0] = vo;
						break;
					case POS_106:
						_leftTrees[bigType][1] = vo;
						break;
					case POS_107:
						_leftTrees[bigType][2] = vo;
						break;
					case POS_108:
						_leftTrees[bigType][3] = vo;
						break;
					case POS_109:
						_leftTrees[bigType][4] = vo;
						break;
					case POS_110:
						_leftTrees[bigType][5] = vo;
						break;
					//右分支
					case POS_205:
						_rightTrees[bigType][0] = vo;
						break;
					case POS_206:
						_rightTrees[bigType][1] = vo;
						break;	
					case POS_207:
						_rightTrees[bigType][2] = vo;
						break;	
					case POS_208:
						_rightTrees[bigType][3] = vo;
						break;
					case POS_209:
						_rightTrees[bigType][4] = vo;
						break;	
					case POS_210:
						_rightTrees[bigType][5] = vo;
						break;	
					//顶部非分支
					case POS_1:
						_topTrees[bigType][0] = vo;
						break;
					case POS_2:
						_topTrees[bigType][1] = vo;
						break;	
					case POS_3:
						_topTrees[bigType][2] = vo;
						break;	
					case POS_4:
						_topTrees[bigType][3] = vo;
						break;
				}
			}
		}
		
		public static function reset():void
		{
			_ins = new SkillTree();
		}
		
		public static function init():void
		{
			if(_ins == null){
				_ins = new SkillTree();
			}
		}
		
		public static function getInstance():SkillTree
		{
			if(_ins == null){
				_ins = new SkillTree();
			}
			return _ins;
		}
		
		public function getTop(bigType:int):Vector.<SkillBasicVo>
		{
			return _topTrees[bigType];
		}
		
		public function getLeft(bigType:int):Vector.<SkillBasicVo>
		{
			return _leftTrees[bigType];
		}
		
		public function getRight(bigType:int):Vector.<SkillBasicVo>
		{
			return _rightTrees[bigType];
		}
		
	}
}