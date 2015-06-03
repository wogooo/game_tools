package com.YFFramework.game.core.module.mount.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.msg.mount_pro.MountInfo;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 上午11:45:45
	 * 
	 */
	public class MountDyManager{
		
		private static var instance:MountDyManager;
		private var _mounts:HashMap = new HashMap();
		private var _mountIdArr:Array = new Array();
		public static var crtMountId:int=-1;	//-1为没有坐骑
		public static var fightMountId:int=-1;	//-1为没有出战坐骑
		public static var isRiding:Boolean;
		
		public function MountDyManager(){
		}
		
		public static function get Instance():MountDyManager{
			return instance ||= new MountDyManager();
		}
		
		/**初始化选中坐骑id
		 **/
		public function initCrtMountId():void{
			if(_mounts.size()>0)	crtMountId=_mountIdArr[0];
			else	crtMountId=-1;
		}
		
		/**添加新的坐骑 
		 * @param m	MountInfo,收到的协议-坐骑信息 
		 */		
		public function addMount(m:MountInfo):void{
			var mount:MountDyVo = new MountDyVo();
			mount.dyId = m.mountId;
			mount.basicId = m.basicId;
//			mount.level=m.level;
//			mount.exp=m.exp;
			mount.addPhy = m.addSoulAttr.physique;
			mount.addStr = m.addSoulAttr.strength;
			mount.addAgi=m.addSoulAttr.agility;
			mount.addInt=m.addSoulAttr.intelligence;
			mount.addSpi=m.addSoulAttr.spirit;
//			mount.physique=m.mountAttr.physique;
//			mount.strength=m.mountAttr.strength;
//			mount.agility=m.mountAttr.agility;
//			mount.intell=m.mountAttr.intelligence;
//			mount.spirit=m.mountAttr.spirit;
			
			_mounts.put(mount.dyId,mount);
			_mountIdArr.push(mount.dyId);
		}
		
		public function updateFight(dyId:int):void{
			fightMountId = dyId;
			var len:int=_mountIdArr.length;
			for(var i:int=0;i<len;i++){
				if(_mountIdArr[i]==dyId){
					_mountIdArr.splice(i,1);
					break;
				}
			}
			_mountIdArr.unshift(dyId);
		}
		
//		/**转换坐骑属性 
//		 * @param id1	坐骑1的id
//		 * @param id2	坐骑2的id
//		 */		
//		public function exgMount(id1:int,id2:int):void{
//			var mount:MountDyVo = _mounts.get(id1);
//			var mount2:MountDyVo = _mounts.get(id2);
//			var tempM:MountDyVo = new MountDyVo();
//			tempM.level = mount.level;
//			tempM.exp = mount.exp;
//			tempM.addPhy=mount.addPhy;
//			tempM.addStr=mount.addStr;
//			tempM.addAgi=mount.addAgi;
//			tempM.addInt=mount.addInt;
//			tempM.addSpi=mount.addSpi;
//			
//			mount.level = mount2.level;
//			mount.exp = mount2.exp;
//			mount.addPhy=mount2.addPhy;
//			mount.addStr=mount2.addStr;
//			mount.addAgi=mount2.addAgi;
//			mount.addInt=mount2.addInt;
//			mount.addSpi=mount2.addSpi;
//			
//			mount2.level = tempM.level;
//			mount2.exp = tempM.exp;
//			mount2.addPhy=tempM.addPhy;
//			mount2.addStr=tempM.addStr;
//			mount2.addAgi=tempM.addAgi;
//			mount2.addInt=tempM.addInt;
//			mount2.addSpi=tempM.addSpi;
//		}
		
		/**放生坐骑 
		 * @param dyId	放生的坐骑id
		 */		
		public function dropMount(dyId:int):void{
			_mounts.remove(dyId);
			var len:int=_mountIdArr.length;
			for(var i:int=0;i<len;i++){
				if(_mountIdArr[i]==dyId){
					_mountIdArr.splice(i,1);
					break;
				}
			}
		}
		
		/**获得当前选中坐骑
		 * @return MountDyVo
		 */		
		public function getCrtMount():MountDyVo{
			return _mounts.get(crtMountId);
		}
		
		/**根据id获取坐骑 
		 * @param dyId	坐骑dyId
		 * @return MountDyVo
		 */
		public function getMount(dyId:int):MountDyVo{
			return _mounts.get(dyId);
		}
		
		/**获得坐骑顺序Arr
		 * @return Array	坐骑顺序Array
		 */		
		public function getMountsIdArr():Array{
			return _mountIdArr;
		}
		
		/**获取上马坐骑的速度
		 * @return int	上马坐骑速度,如果没有上马或出战坐骑，返回-1
		 */		
		public function getRidingMountSpeed():int{
			if(isRiding==true && fightMountId!=-1)	return MountBasicManager.Instance.getMountBasicVo(getMount(fightMountId).basicId).speed;
			return -1;
		}
		
		/** 获得所有坐骑(实际只有一只),返回mountDyVo */
		public function getAllMount():Array
		{
			return _mounts.values();
		}
	}
} 