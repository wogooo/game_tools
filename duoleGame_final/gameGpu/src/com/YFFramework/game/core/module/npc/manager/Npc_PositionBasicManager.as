package com.YFFramework.game.core.module.npc.manager
{
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**缓存  Npc_Position 表
	 */
	public class Npc_PositionBasicManager
	{
		private static var _instance:Npc_PositionBasicManager;
		private var _dict:Dictionary;
		
		/**以场景作为key值进行缓存
		 */		
		private var _sceneDict:Dictionary;
		
		private var _npcBasicDict:Dictionary;
		public function Npc_PositionBasicManager()
		{
			_dict=new Dictionary();
			_sceneDict=new Dictionary();
			_npcBasicDict=new Dictionary();
		}
		public static function get Instance():Npc_PositionBasicManager
		{
			if(_instance==null)_instance=new Npc_PositionBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var npc_PositionBasicVo:Npc_PositionBasicVo;
			var mapNPCArr:Array;
			for (var id:String in jsonData)
			{
				npc_PositionBasicVo=new Npc_PositionBasicVo();
				npc_PositionBasicVo.scene_id=jsonData[id].scene_id;
				npc_PositionBasicVo.npc_id=jsonData[id].npc_id;
				npc_PositionBasicVo.pos_y=jsonData[id].pos_y;
				npc_PositionBasicVo.pos_x=jsonData[id].pos_x;
				npc_PositionBasicVo.basic_id=jsonData[id].basic_id;
				npc_PositionBasicVo.styleId=jsonData[id].styleId;
				npc_PositionBasicVo.type=jsonData[id].type;
				npc_PositionBasicVo.small_map_des=jsonData[id].small_map_des;
				
				npc_PositionBasicVo.path=convertArrToPointArr(jsonData[id].path);
				
				_dict[npc_PositionBasicVo.npc_id]=npc_PositionBasicVo;
				
				if(!_sceneDict[npc_PositionBasicVo.scene_id])
				{
					_sceneDict[npc_PositionBasicVo.scene_id]=[];
				}
				mapNPCArr=_sceneDict[npc_PositionBasicVo.scene_id];
				mapNPCArr.push(npc_PositionBasicVo);
				
				
				//模版id映射  刷新 o
				_npcBasicDict[npc_PositionBasicVo.basic_id]=npc_PositionBasicVo;
			}
		}
		
		private function convertArrToPointArr(arr:Array):Array
		{
			var len:int=arr.length;
			var myArr:Array=[];
			var pt:Point;
			for(var i:int=0;i!=len;++i)
			{
				pt=new Point(arr[i][0],arr[i][1]);
				myArr.push(pt);
			}
			return myArr;
		}
		
		
		public function getNpc_PositionBasicVo(npc_id:int):Npc_PositionBasicVo
		{
			return _dict[npc_id];
		}
		
		public function getNpcPosVoByNpcBasicId(basic_id:int):Npc_PositionBasicVo{
			for each(var vo:Npc_PositionBasicVo in _dict){
				if(vo.basic_id==basic_id){
					return vo;
				}
			}
			return null;
		}
		
		/**  npc半身图像  和 NPC 小图标 图像的  id 是一样的
		 * npcPosId npc刷新 id    模版id 
		 */		
		private function getIconId(npcPosId:int):int
		{
			var positionVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcPosId);
			var npcBasicVo:Npc_ConfigBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(positionVo.basic_id);
			return npcBasicVo.icon_id
		}
		/**获取小图标地址
		 */		
		public function getSmallIconURL(npcPosId:int):String
		{
			var iconId:int=getIconId(npcPosId);
			return URLTool.getNpcSmallIcon(iconId);
		}
		/**获取半身像图标地址
		 */		
		public function getHalfIconURL(npcPosId:int):String
		{
			var iconId:int=getIconId(npcPosId);
			return URLTool.getNPCHalfIcon(npcPosId);
		}
		/**  获取 场景 mapId 的npc列表
		 */		
		public function getMapMPCList(mapId:int):Array
		{
			return _sceneDict[mapId];
		}
			
		
		
		/** npcbBasicId npc的静态 模版 id 
		 * 通过 模版id 随机找一个刷新位置id 
		 */
		public function getNPCPositonBasicVo(npcbBasicId:int):Npc_PositionBasicVo
		{
			return _npcBasicDict[npcbBasicId];
		}
		
		
	}
}